Return-Path: <linux-kernel-owner+w=401wt.eu-S1752705AbYIPUeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbYIPUeU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 16:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751144AbYIPUeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 16:34:09 -0400
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:34228 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750851AbYIPUeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 16:34:08 -0400
Message-ID: <48D0183E.9010301@lwfinger.net>
Date: Tue, 16 Sep 2008 15:34:06 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Michael Buesch <mb@bu3sch.de>, Adel Gadllah <adel.gadllah@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       wireless <linux-wireless@vger.kernel.org>, bcm43xx-dev@lists.berlios.de
Subject: Re: Regression in 2.6.27-rcX caused by commit bc19d6e0b74ef03a3baf035412c95192b54dfc6f
References: <48CFC03A.8020708@lwfinger.net> <200809161742.15527.mb@bu3sch.de> <48CFE820.7010305@lwfinger.net> <20080916195134.GB14879@srcf.ucam.org>
In-Reply-To: <20080916195134.GB14879@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> On Tue, Sep 16, 2008 at 12:08:48PM -0500, Larry Finger wrote:
> 
>> I agree with Michael. From what I know, the only possible reason for
>> having this state would be if user space could somehow affect the
>> state of the hardware switch. As the user's finger is the only such
>> thing, then there is no use for the RFKILL_STATE_HARD_BLOCKED state,
>> particularly when it breaks LED operations.
> 
> RFKILL_STATE_HARD_BLOCKED indicates that the hardware is disabled in a 
> way that userspace can't influence, so sounds like exactly the right 
> state to have here. I still have absolutely no idea what b43 rfkill is 
> supposed to be doing - why on earth is it requesting rfkill-input, and 
> why does it generate keypress events? I /think/ it should e something 
> like the following (untested, I'm not near any of my b43 hardware at the 
> moment). This basically does the following:
> 
> 1) Split the update function in two, so it can be called by either 
> polling or an interrupt driven event on newer hardware (not implemented 
> yet)
> 2) Remove all the input handling
> 3) Change the state updates to use rfkill_force_state, which will 
> generate an event that gets sent up to userland
> 4) Retains the RFKILL_STATE_HARD_BLOCKED code
> 
> When the user flicks a switch or presses a button that physically 
> disables the radio, the state will now automatically change to 
> RFKILL_STATE_HARD_BLOCKED. If they have a key that generates KEY_WLAN 
> but doesn't change the radio state, rfkill-input will trigger a change 
> to RFKILL_STATE_SOFT_BLOCKED.
> 
> Like I said, this is only build-tested - I won't be back at a b43 until 
> next week. If someone could give this a go, that would be great.

It locks up tight with a kernel panic when booting. I have a screen
picture that I will send separately to Matthew.

Larry
