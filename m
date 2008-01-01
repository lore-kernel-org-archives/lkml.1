Return-Path: <linux-kernel-owner+w=401wt.eu-S1756317AbYAARei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317AbYAARei (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 12:34:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754745AbYAARe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 12:34:29 -0500
Received: from mho-02-bos.mailhop.org ([63.208.196.179]:59164 "EHLO
	mho-02-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058AbYAARe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 12:34:28 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 216.15.117.105
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18aLTG86Bp5xvrgLS14xdiV
Message-ID: <477A7967.7030108@reed.com>
Date: Tue, 01 Jan 2008 12:33:27 -0500
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.9) Gecko/20071115 Fedora/2.0.0.9-1.fc8 Thunderbird/2.0.0.9 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
       Rene Herman <rene.herman@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Paul Rolland <rol@as2917.net>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
References: <20071216152250.GA21245@elte.hu> <4765D43E.1010800@gmail.com> <4765D95C.4010404@zytor.com> <4765DCB0.8030901@gmail.com> <4765EE7F.80002@zytor.com> <47667366.7010405@gmail.com> <4766AE88.4080904@zytor.com> <4766D175.7040807@reed.com> <20071217212509.5edaa372@the-village.bc.nu> <477A634C.8040000@reed.com> <20080101173126.GB1889@ucw.cz>
In-Reply-To: <20080101173126.GB1889@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
>> 2. there is some "meaning" to certain byte values being written (the
>> _PTS and _WAK use of arguments that come from callers to store into port
>> 80 makes me suspicious.)   That might mean that the freeze happens only
>> when certain values are written, or when they are written closely in
>> time to some other action - being used to communicate something to the
>>     
>
> There's nothing easier than always writing 0 to the 0x80 to check if
> it hangs in such case...?
> 								Pavel
>
>   
I did try that.  Machine in question does hang when you write 0 to 0x80 
in a loop a few thousand times.  This particular suspicion was that the 
problem was caused by the following sort of thing (it's a multi-cpu 
system...)

First, some ACPI code writes "meaningful value" X to  port 80 that is 
sort of a "parameter" to whatever follows.  Just because the DSDT 
disassembly *calls* it the DBUG port doesn't mean it is *only* used for 
debugging.   We (Linux) use it for timing delays, after all...

 then Linux driver writes some random value (!=X) including zero to port 80.

then ACPI writes some other values that cause SMI or some other thing to 
happen,

There are experiments that are not so simple that could rule this 
particular guess out.   I have them on my queue of experiments I might 
try (locking out ACPI).  Of course if the BIOS were GPL, we could look 
at the comments, etc...

I may today pull the laptop apart to see if I can see what chips are on 
it, besides the nvidia chipset and the processor.  That might give a 
clue as to what SuperIO or other logic chips are there.


 
