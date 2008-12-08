Return-Path: <linux-kernel-owner+w=401wt.eu-S1752788AbYLHKDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbYLHKDt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 05:03:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751516AbYLHKDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 05:03:40 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:43551 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbYLHKDk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 05:03:40 -0500
Message-ID: <493CF0CE.1000405@cosmosbay.com>
Date: Mon, 08 Dec 2008 11:02:54 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Giangiacomo Mariotti <gg.mariotti@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
Subject: Re: [HW PROBLEM] Intel I7 MCE. Erratum or not?
References: <12bfabe40812060421j10c93b3dg75a48aa304f633e8@mail.gmail.com>	 <493AE770.5030507@shaw.ca>	 <12bfabe40812061343j400f55d8r43571c8bd514adde@mail.gmail.com>	 <493AF2EA.4030601@shaw.ca>	 <12bfabe40812061416u1b6f800dn7261beae5ce36b2f@mail.gmail.com>	 <493B4242.1040202@shaw.ca>	 <12bfabe40812071355r65c13e52g5f3d94d3b060c939@mail.gmail.com>	 <20081207141337.588aede5@infradead.org>	 <12bfabe40812072248n3c931ce0hf030b3ac758026d4@mail.gmail.com>	 <493CCFE4.2080802@jp.fujitsu.com> <12bfabe40812080004p7438744eqeb884b42673bd73c@mail.gmail.com> <493CEAA0.50201@jp.fujitsu.com> <493CEF38.3060004@linux.intel.com>
In-Reply-To: <493CEF38.3060004@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Mon, 08 Dec 2008 11:02:55 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen a écrit :
> 
>> IIRC, this error is not what happen on the time [301.7320xx] during
>> boot, but happen before the boot.  Since the record says "Processor
>> context corrupt," MCE handler should call panic(or do something stop
>> the system) if the context actually corrupted during the boot.
> 
> The weird thing is that 301 seconds is quite a long delay for that.
> It should happen  relatively quickly at boot as the CPUs are initialized.
> 

Rings a bell here

include/linux/jiffies.h:157:#define INITIAL_JIFFIES ((unsigned long)(unsigned int) (-300*HZ))

Could it be related to INITIAL_JIFFIES ?

>>
>> In other words, it seems that 1) the error was recorded at last time
>> when your machine crashed unexpectedly(by cosmic-ray etc.) and not
>> cleared
>> yet, or 2) your machine is doing something wrong in every reset/poweroff.
> 
> When it happens consistently at each boot then yes it's likely something
> leaking from the BIOS initialization sequence. Perhaps try a BIOS update?
> 
>

