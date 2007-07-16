Return-Path: <linux-kernel-owner+w=401wt.eu-S1762814AbXGPMZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762814AbXGPMZ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 08:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758608AbXGPMZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 08:25:19 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:37242 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758289AbXGPMZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 08:25:17 -0400
Date: Mon, 16 Jul 2007 17:55:18 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       Bernhard Walle <bwalle@suse.de>,
       "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
Subject: Re: Determine version of kernel that produced vmcore
Message-ID: <20070716122518.GA10506@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <20070710120243.GA10121@hmsendeavour.rdu.redhat.com> <20070713200533oomichi@mail.jp.nec.com> <20070713131550.GB10985@suse.de> <20070716041918.GA11390@in.ibm.com> <20070716115707.GA29923@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070716115707.GA29923@suse.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2007 at 01:57:07PM +0200, Bernhard Walle wrote:
> * Vivek Goyal <vgoyal@in.ibm.com> [2007-07-16 06:19]:
> > On Fri, Jul 13, 2007 at 03:15:50PM +0200, Bernhard Walle wrote:
> > > * Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp> [2007-07-13 13:05]:
> > > > 
> > > > BTW, I'd like to remove PAGESIZE from a mkdfinfo file.
> > > > While 2nd-kernel is running, new makedumpfile comes to consider
> > > > 2nd-kernel PAGESIZE as 1st-kernel PAGESIZE without getting PAGESIZE
> > > > from a mkdfinfo file.
> > > 
> > > I don't think that's a good idea. IMO the kernel should be modified to
> > > export the page size in a variable for that purpose. That would solve
> > > all problems and dependencies, doesn't it?
> > > 
> > 
> > Agreed. We need to export PAGESIZE from kernel instead of assuming that
> > second kernel as got same page size as first kernel.
> 
> So what about this? Do you think it has a chance to get included?
> Should the variable not be inside mm/ but otherwhere?
> 
> 
> Signed-off-by: Bernhard Walle <bwalle@suse.de>
> 
> ---
>  mm/mmap.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -35,6 +35,16 @@
>  #define arch_mmap_check(addr, len, flags)	(0)
>  #endif
> 
> +#ifdef CONFIG_KEXEC
> +
> +/*
> + * Although that variable is not needed for the kernel, initialise it here
> + * to have the page size available in the vmlinux binary.
> + */
> +int page_size = PAGE_SIZE;
> +

Ok. Now there seems to be two ways for accessing such info.
- Through global variables
- Export through ELF notes.

Personally, I like the approach taken by Dan Aloni of exporting required
info through ELF notes. That seems to be more standard in the sense we 
are not dependent on somebody removing above variable tomorrow.

Dan, are you planning to put the modified patch for discussions on LKML?

Thanks
Vivek
