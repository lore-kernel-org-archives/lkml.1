Return-Path: <linux-kernel-owner+w=401wt.eu-S1760042AbXGIUtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760042AbXGIUtr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 16:49:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754781AbXGIUtk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 16:49:40 -0400
Received: from ns1.suse.de ([195.135.220.2]:49087 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754659AbXGIUtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 16:49:39 -0400
Date: Mon, 9 Jul 2007 22:49:38 +0200
From: Bernhard Walle <bwalle@suse.de>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: Determine version of kernel that produced vmcore
Message-ID: <20070709204938.GA21663@suse.de>
Mail-Followup-To: kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org
References: <20070706132814.GA7079@suse.de> <20070706145804.GA31409@localdomain> <20070709092154.GA19705@suse.de> <20070709114131.GA18750@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070709114131.GA18750@localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

* Dan Aloni <da-x@monatomic.org> [2007-07-09 13:41]:
> > > A patch that I am working on will make it possible to integrate
> > > the output of 'makedumpinfo -g' into vmlinux as the final build
> > > stage of the kernel. This information will be presented itself
> > > as /proc/kcore.info for the first kernel throughout its entire
> > > execution.
> > 
> > That sounds good. But I doubt that kernel developers like the idea of
> > needing another utility in the build process ...
> 
> I don't think it would add much complexity to build process as it 
> is now, just like the other tools that transparently do post-linking 
> modifications. As far as the developer is concerned, there's just
> the vmlinux and/or bzImage files that get emitted at the end.

I didn't complain about the complexity but about the requirement of an
additional tool. However, I think it will be configurable.

> > > Then inside initramfs of the first kernel, a small 
> > > util will modify the vmlinux file of the kdump kernel before it
> > > gets loaded so that another special file appearing as 
> > > /proc/vmcore.info under the kdump kernel will present the same
> > > info. 
> > 
> > Where do you get the info from? If you're in the kdump initrd,
> > then the kdump kernel is already loaded. Do you want to attach the
> > info from the crashed kernel to the initrd of the kdump kernel?
> 
> Not exactly. Let me describe the procedure in greater detail.
> Basically, it would go like this:
> 
> 1. <normal bootloader boot>
> 2. <normal initramfs>
> 3. embed_configfile /proc/kcore.info /vmlinux-kdump
> 4. kexec -l vmlinux-kdump <....>
> 5. <boot continues>
> 6. <crash>
> 7. <kdump kernel boot>
> 8. <kdump initramfs runs>
> 9. makedumpfile -i /proc/vmcore.info <....>

I don't see why an additional tool would be needed here. kexec already
modifies symbols, so why not adding the functionality into kexec? The
advantage would be that there's no on-disk modification necessary.

Another issue: Some parameters of makedumpfile (currently the page
size) are read from the running system. If you build the configuration
file while building the kernel, you always have the .config which
contains the page size. So it would be possible to extend the
makedumpfile utility to read that parts from a .config, and that would
remove a dependency that page size of the running kernel matches the
page size of the building kernel. On IA64, that's not always the case.

> BTW I think there could be a confusion between makedumpfile's 
> CONFIGFILE and the .config file, so we should pick a different 
> name for it...

Aggreed. Your suggestion? :)


Thanks,
   Bernhard
