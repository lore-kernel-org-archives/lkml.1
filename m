Return-Path: <linux-kernel-owner+w=401wt.eu-S1764256AbXGJS0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764256AbXGJS0f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 14:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756239AbXGJS00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 14:26:26 -0400
Received: from noname.neutralserver.com ([70.84.186.210]:39654 "EHLO
	noname.neutralserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764171AbXGJS0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 14:26:25 -0400
Date: Tue, 10 Jul 2007 21:26:08 +0300
From: Dan Aloni <da-x@monatomic.org>
To: Neil Horman <nhorman@redhat.com>
Cc: Vivek Goyal <vgoyal@in.ibm.com>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, Bernhard Walle <bwalle@suse.de>
Subject: Re: Determine version of kernel that produced vmcore
Message-ID: <20070710182608.GA2145@localdomain>
References: <20070706132814.GA7079@suse.de> <20070706145804.GA31409@localdomain> <20070709092154.GA19705@suse.de> <20070709114131.GA18750@localdomain> <20070710150037.GB10216@in.ibm.com> <20070710171740.GA11130@hmsendeavour.rdu.redhat.com> <20070710173541.GA21743@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070710173541.GA21743@localdomain>
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

On Tue, Jul 10, 2007 at 08:35:41PM +0300, Dan Aloni wrote:
> On Tue, Jul 10, 2007 at 01:17:40PM -0400, Neil Horman wrote:
> > On Tue, Jul 10, 2007 at 08:30:37PM +0530, Vivek Goyal wrote:
> > > I am still thinking that why can't we change initrd building process
> > > (Be it mkinitrd or mkdumprd depending on distriution). Whole idea is
> > > that while building an initrd/initramfs for the first kernel, one will
> > > ask user for kdump kernel (if user wishes to load kdump kenrel through
> > > initrd) and then it will generate kdump kenrel's initrd and pack into
> > > first kernel's initrd.
> > > 
> > > So steps would look something like this.
> > > 
> > > - mkinitrd takes second kernel's vmlinux as argument
> > > - mkinitrd runs "makedumpfile -g" on debug version of first kernel's vmlinux.
> > > - mkinitrd generates the initramfs for kdump kernel and packs output
> > >   of "makedumpfile -g" into that.
> > > - mkinitrd packs statically linked kexec, kdump kernel vmlinux/bzImage,
> > >   and kdump kernel initramfs into first kernel's initramfs.
> > > 
> > Agreed, this is exactly what happens right now.
> 
> Isn't there some sort of a circular dependency going on here? As I 
> understand it the vmlinux binary already contains the initramfs as 
> built-in data (at least that's what I use here for initramfs). It 
> makes more sense if you guys are creating an _initrd_ image (that's 
> what mkinitrd originally did AFAIK) and supply it to the boot-loader.

I see you are using an _external_ initramfs image. Sorry, I forgot 
that option existed...

-- 
Dan Aloni
XIV LTD, http://www.xivstorage.com
da-x (at) monatomic.org, dan (at) xiv.co.il
