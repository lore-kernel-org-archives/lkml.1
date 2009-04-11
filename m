Return-Path: <linux-kernel-owner+w=401wt.eu-S1753548AbZDKLwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbZDKLwS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 07:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752261AbZDKLwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 07:52:04 -0400
Received: from bgo1smout1.broadpark.no ([217.13.4.94]:59039 "EHLO
	bgo1smout1.broadpark.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbZDKLwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 07:52:02 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Message-id: <49E08454.2060205@bakke.com>
Date: Sat, 11 Apr 2009 13:51:48 +0200
From: Dag Bakke <dag@bakke.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090102)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: video (VGA) object-files unconditionally built/included?
References: <49DF2DCE.5050102@bakke.com>
 <20090410204308.155b7d65.akpm@linux-foundation.org>
 <49E016EB.3000800@zytor.com>
In-reply-to: <49E016EB.3000800@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote, On 04/11/2009 06:04 AM:
> Andrew Morton wrote:
>>>
>>> The video* objects sums up to 87kB. Can I get rid of that somehow? I am
>>> using current git.
>>>
>>> This is my .config:
>>> http://tapas.homeip.net/~dagb/tiny.config
>>
>> I don't think those video things end up consuming memory after the
>> kernel has booted?
>>
> 
> They aren't.  Plus, they don't add up to 87K -- more like 13K.
> 

First, I was more concerned about the size of the kernel image in the
flash memory, not runtime size. Is there an intrinsic reason these bits
must be part of the kernel image?


Second, my reasoning for the claim of 87k:

The build process goes like this:
[.....]
  LZMA    arch/x86/boot/compressed/vmlinux.bin.lzma
[....]
  CC      arch/x86/boot/video.o
  CC      arch/x86/boot/video-mode.o
  CC      arch/x86/boot/version.o
  CC      arch/x86/boot/video-vga.o
  CC      arch/x86/boot/video-vesa.o
  CC      arch/x86/boot/video-bios.o
[... no further compression? ...]
  BUILD   arch/x86/boot/bzImage

So the videobits appear to be built and added on to the kernel image
after the main chunk gets compressed. And the size of the video*.o
objects sums up to 87k.


If my reasoning is too stupid for words, would you mind providing a
graphical illustration of my stupidity?  :-)


Dag B
