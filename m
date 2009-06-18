Return-Path: <linux-kernel-owner+w=401wt.eu-S1758542AbZFRC6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758542AbZFRC6r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 22:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755170AbZFRC61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 22:58:27 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:57435 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295AbZFRC6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 22:58:25 -0400
Date: Thu, 18 Jun 2009 11:57:36 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Marco <marco.stornelli@gmail.com>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux@arm.linux.org.uk,
       linux-m68k@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Daniel Walker <dwalker@soe.ucsc.edu>
Subject: Re: [PATCH 13/14] Pramfs: Write Protection
Message-ID: <20090618025736.GB26531@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Marco <marco.stornelli@gmail.com>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	linux@arm.linux.org.uk, linux-m68k@lists.linux-m68k.org,
	uclinux-dist-devel@blackfin.uclinux.org,
	Linux Embedded <linux-embedded@vger.kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Daniel Walker <dwalker@soe.ucsc.edu>
References: <4A392098.9060205@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A392098.9060205@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 06:58:00PM +0200, Marco wrote:
> Jared Hulbert wrote:
> > > Why not just fix flush_tlb_range()?
> > > 
> > > If an arch has a flush_tlb_kernel_page() that works then it stands to
> > > reason that the flush_tlb_kernel_range() shouldn't work with minimal
> > > effort, no?
> > 
> > flush_tlb_kernel_page() is a new one to me, it doesn't have any mention
> > in Documentation/cachetlb.txt anyways.
> > 
> > Many of the flush_tlb_kernel_range() implementations do ranged checks
> > with tunables to determine whether it is more expensive to selectively
> > flush vs just blowing the entire TLB away.
> > 
> > Likewise, there is no reason why those 4 architectures can not just shove
> > that if (end <= start + PAGE_SIZE) check in the beginning of their
> > flush_tlb_kernel_range() and fall back on flush_tlb_kernel_page() for
> > those cases. Hiding this in generic code is definitely not the way to go.
> 
> Ok I'll change that function at arch level and I'll remove the ifdef,
> I'll call only flush_tlb_kernel_page(), but I'd like to know what is
> the opinion of the arch maintainers to do that.  (Who is the maintainer
> of H8300 arch?)
> 
No, you should call flush_tlb_kernel_range() and just fix up the
flush_tlb_kernel_range() calls to wrap in to flush_tlb_kernel_page(). As
far as the kernel is concerned, flush_tlb_kernel_page() is not a standard
interface, as it has no mention in Documentation/cachetlb.txt.
flush_tlb_page() and flush_tlb_kernel_range() on the other hand are both
standard interfaces.

H8300 is a nommu platform, so it has no TLB to flush. Yoshinori Sato is
the maintainer. Consult the MAINTAINERS file, that's what it is there for.
