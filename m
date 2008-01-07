Return-Path: <linux-kernel-owner+w=401wt.eu-S1758847AbYAGX6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758847AbYAGX6O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 18:58:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756251AbYAGX57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 18:57:59 -0500
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:63131 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606AbYAGX56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 18:57:58 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 216.15.117.105
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18NkSAfcU7jg4qp3zpeZEPg
Message-ID: <4782BC56.9050607@reed.com>
Date: Mon, 07 Jan 2008 18:57:10 -0500
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.9) Gecko/20071115 Fedora/2.0.0.9-1.fc8 Thunderbird/2.0.0.9 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Rene Herman <rene.herman@keyaccess.nl>, Bodo Eggert <7eggert@gmx.de>,
       Christer Weinigel <christer@weinigel.se>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rene Herman <rene.herman@gmail.com>, Paul Rolland <rol@as2917.net>,
       Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: [linux-kernel] Re: [PATCH] x86: provide a DMI based port 0x80
 I/O delay override.
References: <9BdU5-1YW-9@gated-at.bofh.it> <9BeZN-3Gf-5@gated-at.bofh.it> <9BnTB-1As-31@gated-at.bofh.it> <9BrX4-8go-1@gated-at.bofh.it> <9BuBG-4eR-51@gated-at.bofh.it> <9BvRd-6aL-71@gated-at.bofh.it> <9GRQW-1DX-13@gated-at.bofh.it> <9GSah-23W-1@gated-at.bofh.it> <9GSDy-2GD-23@gated-at.bofh.it> <9GTpK-40d-15@gated-at.bofh.it> <9GUvy-5H2-11@gated-at.bofh.it> <9GVKU-7SS-25@gated-at.bofh.it> <E1JBxnV-00046d-CS@be1.7eggert.dyndns.org> <478281A6.1000704@zytor.com> <alpine.LSU.0.999.0801072226060.16143@be1.lrz> <4782A355.1070207@zytor.com> <alpine.LSU.0.999.0801072316440.16143@be1.lrz> <4782AED5.1060406@keyaccess.nl> <4782B4B9.2020608@zytor.com>
In-Reply-To: <4782B4B9.2020608@zytor.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



H. Peter Anvin wrote:
> Rene Herman wrote:
>>
>> Is this only about the ones then left for things like legacy PIC and 
>> PIT? Does anyone care about just sticking in a udelay(2) (or 1) there 
>> as a replacement and call it a day?
>>
>
> PIT is problematic because the PIT may be necessary for udelay setup.
>
The PIT usage for calibrating the delay loop can be moderated, if need 
by, by using the PC BIOS which by definition uses the PIT correctly it 
its int 15 function 83 call..   Just do it before coming up in a state 
where the PC BIOS int 15h calls no longer work.  I gave code to do this 
in a much earlier message.

This is the MOST reliable way to use the PIT early in boot, on a PC 
compatible.  God knows how one should do it on a Macintosh running a 
386/20  :-).   But the ONLY old bat-PIT machines are, thank god, PC 
compatible, maybe.

