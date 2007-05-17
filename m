Return-Path: <linux-kernel-owner+w=401wt.eu-S1759313AbXEQXLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759313AbXEQXLQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 19:11:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755746AbXEQXLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 19:11:04 -0400
Received: from gw.goop.org ([64.81.55.164]:36237 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755951AbXEQXLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 19:11:03 -0400
Message-ID: <464CE105.7030808@goop.org>
Date: Thu, 17 May 2007 16:11:01 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Linux Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Further update of the i386 boot documentation
References: <200705172250.l4HMol8f004870@tazenda.hos.anvin.org>
In-Reply-To: <200705172250.l4HMol8f004870@tazenda.hos.anvin.org>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> +Field name:	boot_flag
> +Type:		read
> +Offset/size:	0x1fe/2
> +Protocol:	ALL
> +
> +  Contains 0xAA55.  This is the closest thing old Linux kernels have
> +  to a magic number.
>   

Endianess?  I guess a blanket statement saying that all constants are
stored little-endian enough (which is obvious, but its always good to be
explicit).

> +
> +Field name:	jump
> +Type:		read
> +Offset/size:	0x200/2
> +Protocol:	2.00+
> +
> +  Contains an x86 jump instruction, 0xEB followed by a signed offset
> +  relative to byte 0x202.  This can be used to determine the size of
> +  the header.
> +
> +Field name:	header
> +Type:		read
> +Offset/size:	0x202/4
> +Protocol:	2.00+
> +
> +  Contains the magic number "HdrS" (0x53726448).
>   

This is a bit confusing from an endian perspective.  Does the "HdrS"
notation mean that it is a byte array containing 'H', 'd', 'r', 'S', as
the string syntax suggests?  Or is that the ascii interpretation of each
byte of a 4-byte value read as a little-endian encoding from that location?

> +
> +Field name:	version
> +Type:		read
> +Offset/size:	0x206/2
> +Protocol:	2.00+
> +
> +  Contains the boot protocol version, e.g. 0x0204 for version 2.04.
>   

So the version is in BCD?

> +
> +Field name:	readmode_swtch
> +Type:		modify (optional)
> +Offset/size:	0x208/4
> +Protocol:	2.00+
> +
> +  Boot loader hook (see separate chapter.)
>   

Chapter?  Is there a more specific reference you could make?

> +
> +Field name:	start_sys
> +Type:		read
> +Offset/size:	0x20c/4
> +Protocol:	2.00+
> +
> +  The load low segment (0x1000).  Obsolete.
> +
> +Field name:	kernel_version
> +Type:		read
> +Offset/size:	0x20e/2
> +Protocol:	2.00+
> +
> +  If set to a nonzero value, contains a pointer to a null-terminated
>   

"nil-terminated"? "\0-terminated"?

> +  human-readable kernel version number string, less 0x200.  This can
> +  be used to display the kernel version to the user.  This value
> +  should be less than (0x200*setup_sects).  For example, if this value
> +  is set to 0x1c00, the kernel version number string can be found at
> +  offset 0x1e00 in the kernel file.  This is a valid value if and only
> +  if the "setup_sects" field contains the value 14 or higher.
>   
How about something like:

    This example is only valid if "setup_sects" is greater than

        ((0x1e00 - 0x200) / 0x200) = 14.

Just to make the calculation explicit.

    J
