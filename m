Return-Path: <linux-kernel-owner+w=401wt.eu-S1752437AbYBRV6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437AbYBRV6Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 16:58:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752578AbYBRV6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 16:58:16 -0500
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:59169 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbYBRV6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 16:58:15 -0500
Message-ID: <47B9FFD5.6040801@keyaccess.nl>
Date: Mon, 18 Feb 2008 22:59:49 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "David P. Reed" <dpreed@reed.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Dmitry Torokhov <dtor_core@ameritech.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: use explicit timing delay for pit accesses in kernel
 and pcspkr driver
References: <6gr00g$g7qpu0@smtp01.lnh.mail.rcn.net> <47B9ECE0.70000@keyaccess.nl> <47B9EDF1.5050404@zytor.com> <47B9F2EC.4070308@keyaccess.nl> <47B9FC3A.2010508@zytor.com>
In-Reply-To: <47B9FC3A.2010508@zytor.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -0.6 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18-02-08 22:44, H. Peter Anvin wrote:
> Rene Herman wrote:
>>
>> I mean that before the linux kernel used a port 0x80 write as an I/O 
>> delay it used a short jump (two in a row actually...) as such and this 
>> was at the time that it actually ran on the old legacy stuff that is 
>> of most concern here.
>>
>> No, if I'm not mistaken, those two jumps are actually what the 
>> udelay() is going to do anyway as part of delay_loop() at that early 
>> stage so that even before loops_per_jiffy calibration, I believe we 
>> should still be okay.
>>
> 
> That doesn't make any sense at all.  The whole point why the two jumps 
> were obsoleted with the P5 (or even late P4, if I'm not mistaken) was 
> because they were utterly insufficient when the CPU ran at something 
> much higher than the external speed.

Yes, but generally not any P5+ system is going to need the PIT delay in the 
first place meaning it just doesn't matter. There were the VIA issues with 
the PIC but unless I missed it not with the PIT.

That's the point. It's fairly unclean to say udelay(2) and then not delay 
for 2 microseconds but you _have_ done the two short jumps meaning 386 and 
486 systems are okay and later systems were okay to start with.

Rene.
