Return-Path: <linux-kernel-owner+w=401wt.eu-S1757771AbXFWNPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757771AbXFWNPH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 09:15:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753698AbXFWNO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 09:14:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:54667 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525AbXFWNO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 09:14:57 -0400
From: Andi Kleen <ak@suse.de>
To: vgoyal@in.ibm.com
Subject: Re: [PATCH] x86-64: disable the GART before allocate aperture
Date: Sat, 23 Jun 2007 15:14:00 +0200
User-Agent: KMail/1.9.1
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Muli Ben-Yehuda <muli@il.ibm.com>, Yinghai Lu <Yinghai.Lu@sun.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200706221219.16243.yinghai.lu@sun.com> <200706230214.02535.ak@suse.de> <20070623111216.GA8726@in.ibm.com>
In-Reply-To: <20070623111216.GA8726@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706231514.01328.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Yes, kdump kernel is generally <4GB . Won't I require IOMMU while I am
> copying the high memory contents in second kernel (lets say 16 GB of memory
> and destination device is not capable of addressing anything more than 4G
> for DMA operation)?

It cannot happen; you don't support mmap on vmcore. Also even if it
was possible it would likely work for networking/block IO because
they support bouncing using their own mechanism.

When you read() from vmcore to write the data out you will always use the CPU 
to copy and then do IO from the copied data.

> > If it's not then swiotlb will also not work because it won't get
> > any memory <4GB.
>
> Will using IOMMU instead of swiotlb give noticeable perfomance boost.

The difference is not that dramatic and less and less IO devices need
it anyways. And if you're <4GB you will never need it.

-Andi
