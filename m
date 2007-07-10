Return-Path: <linux-kernel-owner+w=401wt.eu-S1758994AbXGJIOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758994AbXGJIOi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 04:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754346AbXGJIO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 04:14:26 -0400
Received: from noname.neutralserver.com ([70.84.186.210]:52698 "EHLO
	noname.neutralserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017AbXGJIOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 04:14:25 -0400
Date: Tue, 10 Jul 2007 11:14:14 +0300
From: Dan Aloni <da-x@monatomic.org>
To: Vivek Goyal <vgoyal@in.ibm.com>
Cc: Neil Horman <nhorman@redhat.com>,
       "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: Determine version of kernel that produced vmcore
Message-ID: <20070710081413.GA29034@localdomain>
References: <20070706132814.GA7079@suse.de> <20070706145804.GA31409@localdomain> <20070710064817.GC5471@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070710064817.GC5471@in.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - noname.neutralserver.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - monatomic.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2007 at 12:18:17PM +0530, Vivek Goyal wrote:
> On Fri, Jul 06, 2007 at 05:58:04PM +0300, Dan Aloni wrote:
> > 
>[..]
> > It contains enough information in order to make a compact kernel
> > dump (makedumpinfo needs to go over the struct page arrays). As
> > you see, it also contains the kernel version.
> > 
> 
> But this will not solve Bernhard's problem where looking at a vmcore
> he wants to know which vmlinux (kernel version with time stamp) has
> generated this vmcore. So adding a ELF NOTE should help.

That, or pass it in *runtime* by other means.
 
> > However, this file needs to be passed somehow to the rootfs
> > of the kdump kernel. This poses a chicken-and-egg problem on 
> > my setup where the initramfs of the first kernel contains 
> > a staticlu linked version of the kexec executable along with a
> > kdump kernel to be loaded before mount rootfs and running 
> > init. 
> > 
> 
> Why are you loading kdump kernel from first kernel's initramfs?
> I guess to enable the dump capture as soon as possible so if some
> driver panics() you can capture the dump?

Yes, that's one of the reasons.
 
> Can't we modify the initramfs generation process (mkinitrd) to take
> care of this situation?. By the way, how is second kernel's initramfs
> is generated currently? The moment we start packing a file which contains
> the debuginfo for first kernel, initramfs of second kernel becomes dependent
> on first kernel and to me its not a good approach.

That's not what I'm aiming for, they are actually independent (my 
initramfs is a build-time constant). I have described it in another
mail.
 
> A dump kernel and its initrd should be independent of the crashing kernel.

I agree.

-- 
Dan Aloni
XIV LTD, http://www.xivstorage.com
da-x (at) monatomic.org, dan (at) xiv.co.il
