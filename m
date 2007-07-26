Return-Path: <linux-kernel-owner+w=401wt.eu-S934735AbXGZR4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934735AbXGZR4S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 13:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763243AbXGZR4B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 13:56:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33422 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762801AbXGZR4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 13:56:00 -0400
Message-ID: <46A8E02D.8010609@zytor.com>
Date: Thu, 26 Jul 2007 10:55:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Xudong Guan <xudong.guan@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23-rc1: no setup signature found...
References: <20070724112618.GA4431@gollum.tnic> <20070726150854.GA7034@xguan-laptop> <46A8BB6C.6050903@zytor.com> <20070726152604.GA25792@xguan-laptop> <46A8C7BA.3040008@zytor.com> <20070726162439.GA13387@xguan-laptop> <46A8CB3F.7040207@zytor.com> <20070726171609.GA16236@xguan-laptop>
In-Reply-To: <20070726171609.GA16236@xguan-laptop>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Xudong Guan wrote:
> On 09:26(-0700) Thu 26 Jul, H. Peter Anvin wrote:
>> Xudong Guan wrote:
>>> On 09:11(-0700) Thu 26 Jul, H. Peter Anvin wrote:
>>>> Could you send me a copy of that Qemu image?
>>> I can only upload the 70M bz2 file 2 hours later, when I return home
>>> and have no upload restrictions. If you can not wait, you can try
>>> to download some old DSL ISO image and play with it in qemu to
>>> install it to a harddisk image yourself.
>>> Sorry I can not figure out which ISO version I used.
>>> http://www.damnsmalllinux.org/download.html
>>>
>> Waiting is fine; it's morning here.
> 
> I removed almost all the files in the file system and reduced the file to 9M.
> 
> http://www.ebanpo.com/roamingo/256M.raw.gz   9884879 bytes
> md5sum: 55b3b0836ca61695627a0d0e43293651
> 
> The Makefile that I used to play with it is also included below.
> 

Tracing through this with gdb, it appears that grub is trying to load
the correct number of sectors, but ends up with garbage in the latter
part of the setup code.  It is wrong before the kernel has executed even
a single instruction, so it's not the kernel's fault.

It is not random garbage, either, which implies that Grub is loading
from the wrong part of the disk -- specifically, the first 8K look
correct in memory, and anything beyond that is total garbage.

The protected-mode part of the kernel looks correct in memory, and it
starts at the right point, so it's not a matter of grub simply loading
the wrong number of sectors that the kernel could conceivably fix up.

I doubt the Grub people are interested in a bug report for a version
this ancient.  Looking through the Grub changelog, it looks to me that
this bug was fixed on 2002-07-12 "Rewrite the Linux booting support
radically", over five years ago; the first release which had that fix in
it was 0.93.

	-hpa
