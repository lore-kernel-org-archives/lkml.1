Return-Path: <linux-kernel-owner+w=401wt.eu-S1761294AbYFQXQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761294AbYFQXQq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 19:16:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759097AbYFQXQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 19:16:34 -0400
Received: from sous-sol.org ([216.99.217.87]:48227 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755327AbYFQXQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 19:16:33 -0400
Date: Tue, 17 Jun 2008 16:13:34 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Greg KH <greg@kroah.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Stable Kernel <stable@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [stable] [PATCH 2/2] xen: don't drop NX bit
Message-ID: <20080617231334.GK21814@sequoia.sous-sol.org>
References: <4856E2D4.3020402@goop.org> <20080616223508.GA1165@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080616223508.GA1165@kroah.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH (greg@kroah.com) wrote:
> On Mon, Jun 16, 2008 at 03:01:56PM -0700, Jeremy Fitzhardinge wrote:
> > When converting the pfn/mfn in a pagetable entry, make sure we mask
> > out the protection flags properly.  Formerly, this code was losing the
> > NX bit, and not dealing with extra Xen-defined software flags in ptes.
> > 
> > Because NX is now enforced properly, we must put the hypercall page
> > into the .text segment so that it is executable.
> > 
> > Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> > Cc: Stable Kernel <stable@kernel.org>
> 
> While it's great that you tell the stable people about this, but is it
> realistic?  Is anyone using Xen as contained in the mainline kernel
> these days?
> 
> If a distro were to be based on 2.6.25 and we take this patch, they will
> just revert it back out due to their very large Xen patchset they apply
> on top to get a "working" Xen version, right?

Fedora uses proper pv-ops for Xen.  It's a good -stable candidate.

Acked-by: Chris Wright <chrisw@sous-sol.org>

thanks,
-chris
