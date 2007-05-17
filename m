Return-Path: <linux-kernel-owner+w=401wt.eu-S1758938AbXEQXWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758938AbXEQXWe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 19:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755413AbXEQXW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 19:22:27 -0400
Received: from terminus.zytor.com ([192.83.249.54]:46387 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755112AbXEQXW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 19:22:27 -0400
Message-ID: <464CE38B.8010802@zytor.com>
Date: Thu, 17 May 2007 16:21:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Linux Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Further update of the i386 boot documentation
References: <200705172250.l4HMol8f004870@tazenda.hos.anvin.org> <464CE105.7030808@goop.org>
In-Reply-To: <464CE105.7030808@goop.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> H. Peter Anvin wrote:
>> +Field name:	boot_flag
>> +Type:		read
>> +Offset/size:	0x1fe/2
>> +Protocol:	ALL
>> +
>> +  Contains 0xAA55.  This is the closest thing old Linux kernels have
>> +  to a magic number.
>>   
> 
> Endianess?  I guess a blanket statement saying that all constants are
> stored little-endian enough (which is obvious, but its always good to be
> explicit).

Next time I make a revision I'll put that in; since we're talking about
x86 here it's, as you say, obvious that it's littleendian.  As such, I
think it can wait.

>> +
>> +Field name:	header
>> +Type:		read
>> +Offset/size:	0x202/4
>> +Protocol:	2.00+
>> +
>> +  Contains the magic number "HdrS" (0x53726448).
>>   
> 
> This is a bit confusing from an endian perspective.  Does the "HdrS"
> notation mean that it is a byte array containing 'H', 'd', 'r', 'S', as
> the string syntax suggests?  Or is that the ascii interpretation of each
> byte of a 4-byte value read as a little-endian encoding from that location?

Given that we have already established littleendian byte order, it's the
same thing.

>> +
>> +Field name:	version
>> +Type:		read
>> +Offset/size:	0x206/2
>> +Protocol:	2.00+
>> +
>> +  Contains the boot protocol version, e.g. 0x0204 for version 2.04.
>>   
> 
> So the version is in BCD?

Valid objection.  It probably should be considered as (major, minor)
bytes, but we haven't had any releases where it hasn't also been valid
BCD.  I would prefer separate bytes myself, so 2.10 = 0x20a instead of
2.10 = 0x210.

>> +Field name:	readmode_swtch
>> +Type:		modify (optional)
>> +Offset/size:	0x208/4
>> +Protocol:	2.00+
>> +
>> +  Boot loader hook (see separate chapter.)
>>   
> 
> Chapter?  Is there a more specific reference you could make?

Fair enough...

>> +Field name:	kernel_version
>> +Type:		read
>> +Offset/size:	0x20e/2
>> +Protocol:	2.00+
>> +
>> +  If set to a nonzero value, contains a pointer to a null-terminated
>>   
> 
> "nil-terminated"? "\0-terminated"?

Uh?  That seems more than a little silly.  Yes, I guess formally
speaking we're talking about "NUL-terminated", but the term
"null-terminated" has over 800,000 hits on Google -- 10 times as many as
"NUL-terminated" -- and is hardly an ambiguous term ("NUL-terminated" is
ugly, and "zero-terminated" is ambiguous.)

>> +  human-readable kernel version number string, less 0x200.  This can
>> +  be used to display the kernel version to the user.  This value
>> +  should be less than (0x200*setup_sects).  For example, if this value
>> +  is set to 0x1c00, the kernel version number string can be found at
>> +  offset 0x1e00 in the kernel file.  This is a valid value if and only
>> +  if the "setup_sects" field contains the value 14 or higher.
>>   
> How about something like:
> 
>     This example is only valid if "setup_sects" is greater than
> 
>         ((0x1e00 - 0x200) / 0x200) = 14.

Probably makes sense.

	-hpa

