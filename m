Return-Path: <linux-kernel-owner+w=401wt.eu-S933751AbXC0AL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933751AbXC0AL4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 20:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933832AbXC0ALz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 20:11:55 -0400
Received: from canuck.infradead.org ([209.217.80.40]:54718 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933751AbXC0ALz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 20:11:55 -0400
Date: Mon, 26 Mar 2007 17:09:51 -0700
From: Greg KH <greg@kroah.com>
To: Mitch Williams <mitch.a.williams@intel.com>,
       Michael Ellerman <michael@ellerman.id.au>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, gregkh@suse.de, ebiederm@xmission.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       auke-jan.h.kok@intel.com
Subject: Re: [PATCH 2.6.21-rc5] MSI: read-flush MSI-X table
Message-ID: <20070327000951.GA11555@kroah.com>
References: <1174951102.22190.15.camel@strongmad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174951102.22190.15.camel@strongmad>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2007 at 04:18:22PM -0700, Mitch Williams wrote:
> This patch fixes a kernel bug which is triggered when using the
> irqbalance daemon with MSI-X hardware.
> 
> Because both MSI-X interrupt messages and MSI-X table writes are posted,
> it's possible for them to cross while in-flight.  This results in
> interrupts being received long after the kernel thinks they're disabled,
> and in interrupts being sent to stale vectors after rebalancing.
> 
> This patch performs a read flush after writes to the MSI-X table for
> enable/disable and rebalancing operations.  Because this is an expensive
> operation, we do not perform the read flush after mask/unmask
> operations.  Hardware which supports MSI-X typically also supports some
> sort of interrupt moderation, so a read-flush is not necessary for
> mask/unmask operations.
> 
> This patch has been validated with (unreleased) network hardware which
> uses MSI-X.

How well does this play with the MSI core changes that Michael Ellerman
has proposed on the linux-pci mailing list?

thanks,

greg k-h
