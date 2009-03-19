Return-Path: <linux-kernel-owner+w=401wt.eu-S1760239AbZCSSTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760239AbZCSSTa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 14:19:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756474AbZCSSTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 14:19:19 -0400
Received: from kroah.org ([198.145.64.141]:58723 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754760AbZCSSTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 14:19:18 -0400
Date: Thu, 19 Mar 2009 11:09:19 -0700
From: Greg KH <greg@kroah.com>
To: Alex Chiang <achiang@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 06/12] PCI: Introduce pci_rescan_bus()
Message-ID: <20090319180919.GA26985@kroah.com>
References: <20090318222426.887.1008.stgit@bob.kio> <20090318223956.887.57080.stgit@bob.kio> <20090319022735.f24b7329.akpm@linux-foundation.org> <20090319170548.GE8074@ldl.fc.hp.com> <20090319174215.GB26248@kroah.com> <20090319174938.GJ8074@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090319174938.GJ8074@ldl.fc.hp.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 19, 2009 at 11:49:38AM -0600, Alex Chiang wrote:
> * Greg KH <greg@kroah.com>:
> > On Thu, Mar 19, 2009 at 11:05:48AM -0600, Alex Chiang wrote:
> > > * Andrew Morton <akpm@linux-foundation.org>:
> > > > On Wed, 18 Mar 2009 16:39:56 -0600 Alex Chiang <achiang@hp.com> wrote:
> > > > 
> > > > >  EXPORT_SYMBOL(pci_add_new_bus);
> > > > >  EXPORT_SYMBOL(pci_scan_slot);
> > > > >  EXPORT_SYMBOL(pci_scan_bridge);
> > > > >  EXPORT_SYMBOL_GPL(pci_scan_child_bus);
> > > > > +EXPORT_SYMBOL_GPL(pci_rescan_bus);
> > > > 
> > > > uhm, is there any rationale for the seemingly-random mixup of export types
> > > > in this interface?
> > > 
> > > History?
> > > 
> > > I've no clue why we're mixing EXPORT_SYMBOL and EXPORT_SYMBOL_GPL.
> > 
> > I do :)
> > 
> > New PCI core exports were added with _GPL, it's the older ones that were
> > left at the "normal" level.
> > 
> > > git-blame says that the mishmash existed pre-git.
> > > 
> > > For my new interface, I thought that EXPORT_SYMBOL_GPL would be
> > > most appropriate, but maybe not?
> > 
> > Yes it is, pci hotplug exports has always been EXPORT_SYMBOL_GPL(), in
> > fact I think it was the first in-tree user of this marking.
> > 
> > > What would you like me to do? Make them all the same?
> > 
> > New ones should be _GPL() please.
> > 
> > But please put the export in the proper place, checkpatch.pl will
> > complain if you do not.  Which means you didn't run it on your patches
> > :)
> 
> Andrew already yelled at me privately about checkpatch.
> 
> I went over and ran it on all my patches, and that was indeed one
> of the complaints.
> 
> But when it comes to file consistency vs "letter of the law" I
> like to keep things consistent (even if broken) in the file.
> 
> I could go back and move all those EXPORT_SYMBOL declarations to
> the "proper" place. Is that too much noise though?

Too much noise for this patch, yes.

Put things in the right place for new patches/changes.

If you want to go back and just make a "fix this file to be checkpatch
clean" patch, that's fine as well, but don't merge it with other changes
at the same time, as that makes it pretty unreviewable.

Hope this helps,

greg k-h
