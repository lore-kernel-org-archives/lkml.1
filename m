Return-Path: <linux-kernel-owner+w=401wt.eu-S1757855AbXGJNFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757855AbXGJNFS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 09:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753128AbXGJNFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 09:05:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:38409 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752758AbXGJNFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 09:05:05 -0400
Date: Tue, 10 Jul 2007 15:05:03 +0200
From: Bernhard Walle <bwalle@suse.de>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: Determine version of kernel that produced vmcore
Message-ID: <20070710130503.GD22862@suse.de>
Mail-Followup-To: kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org
References: <20070706132814.GA7079@suse.de> <20070706145804.GA31409@localdomain> <20070710064817.GC5471@in.ibm.com> <20070710081413.GA29034@localdomain> <20070710121225.GC10121@hmsendeavour.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070710121225.GC10121@hmsendeavour.rdu.redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Neil Horman <nhorman@redhat.com> [2007-07-10 14:12]:
> On Tue, Jul 10, 2007 at 11:14:14AM +0300, Dan Aloni wrote:
> > On Tue, Jul 10, 2007 at 12:18:17PM +0530, Vivek Goyal wrote:
> > > On Fri, Jul 06, 2007 at 05:58:04PM +0300, Dan Aloni wrote:
> > > > 
> > >[..]
> > > > It contains enough information in order to make a compact kernel
> > > > dump (makedumpinfo needs to go over the struct page arrays). As
> > > > you see, it also contains the kernel version.
> > > > 
> > > 
> > > But this will not solve Bernhard's problem where looking at a vmcore
> > > he wants to know which vmlinux (kernel version with time stamp) has
> > > generated this vmcore. So adding a ELF NOTE should help.
> > 
> > That, or pass it in *runtime* by other means.
> Wait a second,  I may have been confused before.  Do you want to know the
> version of the crashing kernel when you look at a core in the crash utilty, or
> do you want to know it when you are capturing the crash?  If you want the
> former, then an ELF NOTE would be perfect.  If you want to know the latter, my
> suggestion would be to simply modify mkdumprd to place the name of the crashing
> kernel, along with its version directly into the kdump initramfs init script.
> We can use makedumpfile or readelf to fish out the utsname and just embed it.
> Either approach is rather easy to do I think, the former would require a kernel
> modification, while the latter would require some extra scripting.

Well, mkdumprd is RedHat specific. (We use the normal mkinitrd for
this.) 

Also, I don't want to rebuild the initrd of the kdump kernel just only
after changing the running kernel. That would require to rebuild the
initrd for the kdump kernel on *every* boot of a kernel that's another
version than the last booted kernel.



Thanks,
   Bernhard
