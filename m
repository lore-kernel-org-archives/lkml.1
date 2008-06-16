Return-Path: <linux-kernel-owner+w=401wt.eu-S1758902AbYFPWlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758902AbYFPWlr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 18:41:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758774AbYFPWlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 18:41:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:41776 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756955AbYFPWlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 18:41:35 -0400
Date: Mon, 16 Jun 2008 15:35:08 -0700
From: Greg KH <greg@kroah.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Stable Kernel <stable@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [stable] [PATCH 2/2] xen: don't drop NX bit
Message-ID: <20080616223508.GA1165@kroah.com>
References: <4856E2D4.3020402@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4856E2D4.3020402@goop.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2008 at 03:01:56PM -0700, Jeremy Fitzhardinge wrote:
> When converting the pfn/mfn in a pagetable entry, make sure we mask
> out the protection flags properly.  Formerly, this code was losing the
> NX bit, and not dealing with extra Xen-defined software flags in ptes.
> 
> Because NX is now enforced properly, we must put the hypercall page
> into the .text segment so that it is executable.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Cc: Stable Kernel <stable@kernel.org>

While it's great that you tell the stable people about this, but is it
realistic?  Is anyone using Xen as contained in the mainline kernel
these days?

If a distro were to be based on 2.6.25 and we take this patch, they will
just revert it back out due to their very large Xen patchset they apply
on top to get a "working" Xen version, right?

thanks,

greg k-h
