Return-Path: <linux-kernel-owner+w=401wt.eu-S1757818AbXFWLMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757818AbXFWLMj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 07:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754121AbXFWLMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 07:12:32 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:53927 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828AbXFWLMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 07:12:31 -0400
Date: Sat, 23 Jun 2007 16:42:16 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Andi Kleen <ak@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Muli Ben-Yehuda <muli@il.ibm.com>, Yinghai Lu <Yinghai.Lu@sun.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86-64: disable the GART before allocate aperture
Message-ID: <20070623111216.GA8726@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <200706221219.16243.yinghai.lu@sun.com> <m18xabbrp6.fsf@ebiederm.dsl.xmission.com> <20070622231951.4d516215@the-village.bc.nu> <200706230214.02535.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706230214.02535.ak@suse.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2007 at 02:14:01AM +0200, Andi Kleen wrote:
> On Saturday 23 June 2007 00:19:51 Alan Cox wrote:
> > > YH do you think you can look at simply reserving a portion of the iommu?
> > > And having the kexec on panic kernel use the reserved portion?
> > 
> > How about simply reserving all of it for the base kernel and using soft
> > iommu for the panic kernel, its hardly high performance criticial at this
> > point.
> 
> The kdump kernel should be normally all <4GB anyways. You won't
> need any IOMMU for its IO unless you O_DIRECT/sendfile out of /proc/kcore.
> Just don't do that (but I suspect it won't work anyways)
> 

Hi Andi,

Yes, kdump kernel is generally <4GB . Won't I require IOMMU while I am 
copying the high memory contents in second kernel (lets say 16 GB of memory
and destination device is not capable of addressing anything more than 4G
for DMA operation)?

> If it's not then swiotlb will also not work because it won't get 
> any memory <4GB.
> 

Will using IOMMU instead of swiotlb give noticeable perfomance boost.
One of the goals is to automatically save the crash dump as soon as
possible and boot back into production kernel to reduce system down
time and reduce availability.

Right now I am trvelling. After OLS will try to come up with a patch
for reserving a couple of IOMMU entries for kdump purposes. Only issue
is that any boot time reservation requirements make it impossible to
enable a feature at run time without rebooting the system.

Thanks
Vivek
