Return-Path: <linux-kernel-owner+w=401wt.eu-S1761414AbXGKI6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761414AbXGKI6p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 04:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757559AbXGKI6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 04:58:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:35896 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755939AbXGKI6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 04:58:36 -0400
Date: Wed, 11 Jul 2007 10:58:10 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Vivek Goyal <vgoyal@in.ibm.com>
Cc: Dan Aloni <da-x@monatomic.org>,
       "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>,
       Neil Horman <nhorman@redhat.com>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: Determine version of kernel that produced vmcore
Message-ID: <20070711085810.GB23466@suse.de>
Mail-Followup-To: Vivek Goyal <vgoyal@in.ibm.com>,
	Dan Aloni <da-x@monatomic.org>,
	Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp>,
	Neil Horman <nhorman@redhat.com>, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org
References: <20070706132814.GA7079@suse.de> <20070706145804.GA31409@localdomain> <20070710064817.GC5471@in.ibm.com> <20070710120904.GB10121@hmsendeavour.rdu.redhat.com> <20070710165201.GA7984@localdomain> <20070711060726.GA5310@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070711060726.GA5310@in.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Vivek Goyal <vgoyal@in.ibm.com> [2007-07-11 08:07]:
> On Tue, Jul 10, 2007 at 07:52:01PM +0300, Dan Aloni wrote:
> > On Tue, Jul 10, 2007 at 08:09:04AM -0400, Neil Horman wrote:
> > > On Tue, Jul 10, 2007 at 12:18:17PM +0530, Vivek Goyal wrote:
> > > > On Fri, Jul 06, 2007 at 05:58:04PM +0300, Dan Aloni wrote:
> > > > > On Fri, Jul 06, 2007 at 03:28:14PM +0200, Bernhard Walle wrote:
> > > > > > Hello,
> > [...]
> > > > > It contains enough information in order to make a compact kernel
> > > > > dump (makedumpinfo needs to go over the struct page arrays). As
> > > > > you see, it also contains the kernel version.
> > > > > 
> > > > 
> > > > But this will not solve Bernhard's problem where looking at a vmcore
> > > > he wants to know which vmlinux (kernel version with time stamp) has
> > > > generated this vmcore. So adding a ELF NOTE should help.
> > > > 
> > > I think an ELF note would be a fine idea.
> > 
> > Okay, so here's an implemenation.
> > 
> > See the attached proof-of-concept patches to the kernel-side kexec and 
> > kexec-tools (might need some cleanup though). Next to follow, a patch 
> > to makedumpfile. With these patches a new "LINUX" elf note generated 
> > by the kernel in the format that makedumpfile expects and is being 
> > passed on by the kexec util to the kdump kernel.
> > 
> > As a bonus, with this patch you don't even have to compile the kernel 
> > with debug information in order for the filtering to work.
> > 
> 
> This implementation looks interesting. No need of debug compiled
> vmlinux for dump filtering purposes. No run time vmlinux binary modifications
> as suggested by your previous mails. People can export kernel CONFIG info
> like PAGESIZE etc with the help of this ELF note and any tool which is
> processing kernel core file can benifit from this. No guesses required for
> determining the page size of crashed kernel.

I also like way of implementing it. :)


Thanks,
   Bernhard
