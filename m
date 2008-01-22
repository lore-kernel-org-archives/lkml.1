Return-Path: <linux-kernel-owner+w=401wt.eu-S1753791AbYAVWDD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791AbYAVWDD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 17:03:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751072AbYAVWCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 17:02:53 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:47135 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750843AbYAVWCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 17:02:52 -0500
Date: Tue, 22 Jan 2008 23:03:01 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: factor out common s2ram wakeup code
Message-ID: <20080122220301.GA8019@elf.ucw.cz>
References: <20080122193719.GA3791@elf.ucw.cz> <4796519C.6040501@zytor.com> <20080122205625.GC4317@elf.ucw.cz> <47965B13.9080705@zytor.com> <20080122212440.GF4317@elf.ucw.cz> <47966546.6040002@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47966546.6040002@zytor.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-01-22 13:51:02, H. Peter Anvin wrote:
> Pavel Machek wrote:
>>>
>>> The biggest question is if your 16-bit code needs to touch symbols in the 
>>> 32/64-bit code, or vice versa.  That complicates things a little bit, 
>>> obviously.
>>
>> The code is in arch/x86/kernel/acpi/wakeup_32.S
>> . acpi_copy_wakeup_routine needs to know offsets within 16-bit code. I'd 
>> like to somehow call code from arch/x86/boot/video*.c
>> ... current version just took (old) .S code, and cut&paste-s it.
>>
>
> Right, I know.
>
>>> If not, the easiest way is to link the 16-bit code into a separate binary 
>>> (including both assembly and C code) which can then be included in the 
>>> kernel proper as a binary blob.  If it *does* need to reference outside 
>>> symbols, then it needs to be part of the overall link, which means 
>>> mucking with the top-level link script.
>>> That's obviously more complex.
>>>
>>> Either way, the Makefile bit of this will be a lot easier if we move the 
>>> 16-bit code into a separate directory.
>>
>> I only need arch/x86/boot/video*.c ...
>>
>>> Let me know which way you think makes more sense, and I can send you a 
>>> framework patch.
>>
>> I need to access data in that 16-bit code...
>
> Would a shared structure be OK for that?  That's easier than dealing with 
> symbols.

Shared structure would be okay, plus I need pointer to beggining and
end of code so that I can copy it to lowmem.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
