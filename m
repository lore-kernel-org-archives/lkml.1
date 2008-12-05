Return-Path: <linux-kernel-owner+w=401wt.eu-S1756646AbYLEPa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646AbYLEPa5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 10:30:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754710AbYLEPas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 10:30:48 -0500
Received: from ns2.suse.de ([195.135.220.15]:41643 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754589AbYLEPas (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 10:30:48 -0500
Date: Fri, 5 Dec 2008 07:26:44 -0800
From: Greg KH <gregkh@suse.de>
To: Jiri Slaby <jirislaby@gmail.com>, Mark McLoughlin <markmc@redhat.com>,
       Michael Tokarev <mjt@tls.msk.ru>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
       Anthony Liguori <aliguori@us.ibm.com>
Subject: Re: [PATCH] virtio: make PCI devices take a virtio_pci module ref
Message-ID: <20081205152644.GA27847@suse.de>
References: <1228394671.3732.77.camel@blaa> <49385DB7.4060306@gmail.com> <4938EE0B.8020501@msgid.tls.msk.ru> <493929D2.4070900@gmail.com> <1228488921.3858.25.camel@blaa> <493947EB.3050404@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <493947EB.3050404@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2008 at 04:25:31PM +0100, Jiri Slaby wrote:
> Mark McLoughlin wrote:
> >> Fix the virtio bus instead.
> > 
> > Yeah, the patch I posted wasn't meant as a fix for this traceback.
> 
> So what's the module_get patch needed for?
> 
> > Here's one that does fix it.
> ...
> > From: Mark McLoughlin <markmc@redhat.com>
> > Subject: [PATCH] virtio: add device release() function
> > 
> > Add a release() function for virtio_pci devices so as to avoid:
> > 
> >   Device 'virtio0' does not have a release() function, it is broken and must be fixed

Just providing an empty release function to the kernel is the complete
wrong thing.  Do you not think the kernel is actually trying to tell you
something here?  If it could test for an empty release function it would
complain about that as well, providing one is no "fix" at all.

You need to free your memory in the release function that is owned by
the device/structure.  Please read the file, Documentation/kobject.txt
for details as to what you need to do.

thanks,

greg k-h
