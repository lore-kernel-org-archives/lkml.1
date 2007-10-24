Return-Path: <linux-kernel-owner+w=401wt.eu-S1753898AbXJXQQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbXJXQQz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:16:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752705AbXJXQQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:16:48 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:31842 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968AbXJXQQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:16:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iyiPpdF6k1BDS0NcsZPh1LVqSX6UaRbJsOtGEVP3ZYWkJx7Pwk+7S/kFnN6VXr68J7qJ3DUgzb2Dcy+9zniA55D2FYnUf6fc9dkurwzzJ/PA5ErBOynB6ly/GyVXBehTNwFQwF+ibZksDlAKAV48T3Vah/uLoQdyDuNQmsAKvvc=
Message-ID: <64de5c8b0710240916k485bbcf9n88ad8f0ecf920409@mail.gmail.com>
Date: Wed, 24 Oct 2007 21:46:45 +0530
From: "Rajkumar S" <rajkumars@gmail.com>
To: "Robert Hancock" <hancockr@shaw.ca>
Subject: Re: HIGHMEM64G Kernel (2.6.23.1) makes system crawl
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <471F560D.4040909@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.7rN1uBoDAvdkB/ZVQAe63J/uvnk@ifi.uio.no>
	 <471F560D.4040909@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/07, Robert Hancock <hancockr@shaw.ca> wrote:
> Rajkumar S wrote:
> > Hello,
> >
> > I am using a Core 2 Duo E6750 CPU on an intel DG33FB mother board with
> > 4GB Ram, running Debian Lenny.
> >
> > Since the box has 4 GB ram I compiled a big mem kernel, but the
> > machine is very slow while running big mem kernel. It takes about 37
> > minutes to compile the intel e1000 driver  (e1000-7.6.5.tar.gz) from
> > intel site. But it's performing normally when using a non big mem
> > kernel. The diff of the .config between working and non working is as
> > follows.
>
> Post your contents of /proc/mtrr. Likely a BIOS bug which has been seen
> on a number of Intel boards, which doesn't mark all of RAM as cachable.

I have upgraded the bios to latest  (v. 0293 October 02, 2007)
Previously the /proc/mtrr was:

ravanan:~# cat /proc/mtrr
reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
reg01: base=0x80000000 (2048MB), size=1024MB: write-back, count=1
reg02: base=0xc0000000 (3072MB), size= 256MB: write-back, count=1
reg03: base=0xcf800000 (3320MB), size=   8MB: uncachable, count=1
reg04: base=0xcf600000 (3318MB), size=   2MB: uncachable, count=1
reg05: base=0xcf500000 (3317MB), size=   1MB: uncachable, count=1
reg06: base=0x100000000 (4096MB), size= 512MB: write-back, count=1
reg07: base=0x120000000 (4608MB), size= 128MB: write-back, count=1

Now after upgrading the bios it's

reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
reg01: base=0x80000000 (2048MB), size=1024MB: write-back, count=1
reg02: base=0xc0000000 (3072MB), size= 256MB: write-back, count=1
reg03: base=0xcf800000 (3320MB), size=   8MB: uncachable, count=1
reg04: base=0xcf400000 (3316MB), size=   4MB: uncachable, count=1
reg05: base=0x100000000 (4096MB), size= 512MB: write-back, count=1
reg06: base=0x120000000 (4608MB), size= 128MB: write-back, count=1

raj
