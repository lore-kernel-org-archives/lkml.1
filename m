Return-Path: <linux-kernel-owner+w=401wt.eu-S1754648AbYAVVvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648AbYAVVvr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 16:51:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751512AbYAVVvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 16:51:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47796 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbYAVVvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 16:51:38 -0500
Message-ID: <47966546.6040002@zytor.com>
Date: Tue, 22 Jan 2008 13:51:02 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: factor out common s2ram wakeup code
References: <20080122193719.GA3791@elf.ucw.cz> <4796519C.6040501@zytor.com> <20080122205625.GC4317@elf.ucw.cz> <47965B13.9080705@zytor.com> <20080122212440.GF4317@elf.ucw.cz>
In-Reply-To: <20080122212440.GF4317@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
>>
>> The biggest question is if your 16-bit code needs to touch symbols in the 
>> 32/64-bit code, or vice versa.  That complicates things a little bit, 
>> obviously.
> 
> The code is in arch/x86/kernel/acpi/wakeup_32.S
> . acpi_copy_wakeup_routine needs to know offsets within 16-bit 
> code. I'd like to somehow call code from arch/x86/boot/video*.c
> ... current version just took (old) .S code, and cut&paste-s it.
> 

Right, I know.

>> If not, the easiest way is to link the 16-bit code into a separate binary 
>> (including both assembly and C code) which can then be included in the 
>> kernel proper as a binary blob.  If it *does* need to reference outside 
>> symbols, then it needs to be part of the overall link, which means mucking 
>> with the top-level link script.
>> That's obviously more complex.
>>
>> Either way, the Makefile bit of this will be a lot easier if we move the 
>> 16-bit code into a separate directory.
> 
> I only need arch/x86/boot/video*.c ...
> 
>> Let me know which way you think makes more sense, and I can send you a 
>> framework patch.
> 
> I need to access data in that 16-bit code...

Would a shared structure be OK for that?  That's easier than dealing 
with symbols.

	-hpa
