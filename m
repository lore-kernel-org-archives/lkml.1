Return-Path: <linux-kernel-owner+w=401wt.eu-S1760766AbXF0OL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760766AbXF0OL6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 10:11:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753036AbXF0OLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 10:11:50 -0400
Received: from mailgw1.fraunhofer.de ([153.96.1.18]:53384 "EHLO
	mailgw1.fraunhofer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926AbXF0OLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 10:11:49 -0400
Date: Wed, 27 Jun 2007 15:45:44 +0200
From: Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling)
To: bunk@stusta.de, dwmw2@infradead.org
Cc: david@lang.hm, linux-kernel@vger.kernel.org, schilling@fokus.fraunhofer.de
Subject: Re: Linux Kernel include files
Message-ID: <46826a08.aydgAULQ8LQL0IWi%Joerg.Schilling@fokus.fraunhofer.de>
User-Agent: nail 11.22 3/20/05
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO8859-1
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 27 Jun 2007 13:47:42.0354 (UTC) FILETIME=[BBDF9720:01C7B8C1]
X-Fraunhofer-Email-Policy: accepted
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@stusta.de> wrote:

> > Personally, I think that's a load of bollocks. And it certainly doesn't
> > apply to Linux-specific files like <linux/cdrom.h>, which are perfectly
> > entitled to use a C standard from last millennium, regardless of
> > namespace 'pollution' issues. That's why we continue to use the crappy
> > __u32 types. Can you be more specific about why this is a problem? Don't
> > we mostly define those crappy types using arch-specific knowledge, as
> > 'int', 'long', etc?
> >...
>
> It would certainly help if Joerg would tell what exactly breaks, but I 
> spot one likely problem in include/asm-i386/types.h:
>
> #if defined(__GNUC__) && !defined(__STRICT_ANSI__)
> typedef __signed__ long long __s64;
> typedef unsigned long long __u64;
> #endif
>
> It might make sense to remove the #if and simply require that
> a C compiler under Linux must know about the C99 "long long"?

The Sun compiler did support the long long type before gcc did.
This is not a problem.

I get e.g.:

 ==> COMPILING "scsihack.o"
"/usr/include/linux/byteorder/little_endian.h", line 43: inline keyword applied to __le64: must be a function identifier
"/usr/include/linux/byteorder/little_endian.h", line 43: syntax error before or at: __cpu_to_le64p
"/usr/include/linux/byteorder/little_endian.h", line 45: operands must have arithmetic type: op "*"
"/usr/include/linux/byteorder/little_endian.h", line 47: syntax error before or at: *
"/usr/include/linux/byteorder/little_endian.h", line 49: undefined symbol: p
"/usr/include/linux/byteorder/little_endian.h", line 49: cannot dereference non-pointer type
"/usr/include/linux/byteorder/little_endian.h", line 67: inline keyword applied to __be64: must be a function identifier
"/usr/include/linux/byteorder/little_endian.h", line 67: syntax error before or at: __cpu_to_be64p
"/usr/include/linux/byteorder/little_endian.h", line 69: syntax error before or at: __swab64p
"/usr/include/linux/byteorder/little_endian.h", line 71: syntax error before or at: *
"/usr/include/linux/byteorder/little_endian.h", line 73: undefined symbol: p
"scsi-linux-sg.c", line 1152: warning: statement not reached
cc: acomp failed for scsihack.c

And it seems that yout proposal did point into the right direction.

After copying /usr/include/linux/types.h  to
/opt/sunstudio12/prod/include/cc/linux/types.h and removing all 

#if defined(__GNUC__) && !defined(__STRICT_ANSI__) 
...
#endif

stuff, I got cdrtools compiled using "suncc" and I did even get a woring 
cdrecord.

Thanks for the help!

Jörg

-- 
 EMail:joerg@schily.isdn.cs.tu-berlin.de (home) Jörg Schilling D-13353 Berlin
       js@cs.tu-berlin.de                (uni)  
       schilling@fokus.fraunhofer.de     (work) Blog: http://schily.blogspot.com/
 URL:  http://cdrecord.berlios.de/old/private/ ftp://ftp.berlios.de/pub/schily
