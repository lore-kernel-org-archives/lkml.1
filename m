Return-Path: <linux-kernel-owner+w=401wt.eu-S1754176AbYIPRJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbYIPRJA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 13:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752361AbYIPRIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 13:08:51 -0400
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:51755 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751574AbYIPRIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 13:08:50 -0400
Message-ID: <48CFE820.7010305@lwfinger.net>
Date: Tue, 16 Sep 2008 12:08:48 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: bcm43xx-dev@lists.berlios.de, John Linville <linville@tuxdriver.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Adel Gadllah <adel.gadllah@gmail.com>,
       wireless <linux-wireless@vger.kernel.org>
Subject: Re: Regression in 2.6.27-rcX caused by commit bc19d6e0b74ef03a3baf035412c95192b54dfc6f
References: <48CFC03A.8020708@lwfinger.net> <200809161742.15527.mb@bu3sch.de>
In-Reply-To: <200809161742.15527.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Buesch wrote:
> On Tuesday 16 September 2008 16:18:34 Larry Finger wrote:
>> Since commit bc19d6e0b74ef03a3baf035412c95192b54dfc6f entitled
>> "b43/b43legacy: add RFKILL_STATE_HARD_BLOCKED support", the radio LED
>> no longer responds to rfkill switch events.
>>
>> ATM, I do not have a fix, other than reversion of this commit.
> 
> It's kind of bogus that it pokes with the software rfkill state
> from within the hardware rfkill handler.
> 
> Please revert this patch. The commit log says nothing about
> why this is needed and I don't see a point in overriding the state
> in the rfkill-private data structure from within the driver.

I agree with Michael. From what I know, the only possible reason for
having this state would be if user space could somehow affect the
state of the hardware switch. As the user's finger is the only such
thing, then there is no use for the RFKILL_STATE_HARD_BLOCKED state,
particularly when it breaks LED operations.

Please revert the patch.

Larry
