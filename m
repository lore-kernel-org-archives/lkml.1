Return-Path: <linux-kernel-owner+w=401wt.eu-S1756004AbXJXXSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004AbXJXXSw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 19:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752110AbXJXXSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 19:18:44 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:13935 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081AbXJXXSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 19:18:43 -0400
Date: Wed, 24 Oct 2007 17:18:14 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: HIGHMEM64G Kernel (2.6.23.1) makes system crawl
In-reply-to: <fa.USaSUutC3B7gcx/C3bJNmlbDfJk@ifi.uio.no>
To: Rajkumar S <rajkumars@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Message-id: <471FD2B6.4020303@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <fa.wTdv3mFEbQaGOciq1qlqjQYioTk@ifi.uio.no>
 <fa.5twmqnTSoQ6RAav3LKQBxq5jBTw@ifi.uio.no>
 <fa.USaSUutC3B7gcx/C3bJNmlbDfJk@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rajkumar S wrote:
> On 10/24/07, Robert Hancock <hancockr@shaw.ca> wrote:
>> Rajkumar S wrote:
>>> Hello,
>>>
>>> I am using a Core 2 Duo E6750 CPU on an intel DG33FB mother board with
>>> 4GB Ram, running Debian Lenny.
>>>
>>> Since the box has 4 GB ram I compiled a big mem kernel, but the
>>> machine is very slow while running big mem kernel. It takes about 37
>>> minutes to compile the intel e1000 driver  (e1000-7.6.5.tar.gz) from
>>> intel site. But it's performing normally when using a non big mem
>>> kernel. The diff of the .config between working and non working is as
>>> follows.
>> Post your contents of /proc/mtrr. Likely a BIOS bug which has been seen
>> on a number of Intel boards, which doesn't mark all of RAM as cachable.
> 
> I have upgraded the bios to latest  (v. 0293 October 02, 2007)
> Previously the /proc/mtrr was:
> 
> ravanan:~# cat /proc/mtrr
> reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
> reg01: base=0x80000000 (2048MB), size=1024MB: write-back, count=1
> reg02: base=0xc0000000 (3072MB), size= 256MB: write-back, count=1
> reg03: base=0xcf800000 (3320MB), size=   8MB: uncachable, count=1
> reg04: base=0xcf600000 (3318MB), size=   2MB: uncachable, count=1
> reg05: base=0xcf500000 (3317MB), size=   1MB: uncachable, count=1
> reg06: base=0x100000000 (4096MB), size= 512MB: write-back, count=1
> reg07: base=0x120000000 (4608MB), size= 128MB: write-back, count=1
> 
> Now after upgrading the bios it's
> 
> reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
> reg01: base=0x80000000 (2048MB), size=1024MB: write-back, count=1
> reg02: base=0xc0000000 (3072MB), size= 256MB: write-back, count=1
> reg03: base=0xcf800000 (3320MB), size=   8MB: uncachable, count=1
> reg04: base=0xcf400000 (3316MB), size=   4MB: uncachable, count=1
> reg05: base=0x100000000 (4096MB), size= 512MB: write-back, count=1
> reg06: base=0x120000000 (4608MB), size= 128MB: write-back, count=1

Yup, it's a BIOS bug. Your BIOS only marks ram up to physical address of 
4736MB as cacheable, while the actual RAM reported by the BIOS goes up 
to physical address 4800MB.

I think we had a patch in -mm to detect this case and disable the extra 
memory (64MB in this case) to keep the kernel from using it.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

