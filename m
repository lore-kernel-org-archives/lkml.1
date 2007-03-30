Return-Path: <linux-kernel-owner+w=401wt.eu-S1752041AbXC3TNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041AbXC3TNm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 15:13:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbXC3TNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 15:13:41 -0400
Received: from ns1.suse.de ([195.135.220.2]:39719 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041AbXC3TNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 15:13:41 -0400
Date: Fri, 30 Mar 2007 12:09:51 -0700
From: Greg KH <gregkh@suse.de>
To: Mitch Williams <mitch.a.williams@intel.com>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, ebiederm@xmission.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       auke-jan.h.kok@intel.com
Subject: Re: [PATCH 2.6.20.4] Flush MSI-X table writes (rev 3)
Message-ID: <20070330190951.GA18351@suse.de>
References: <1175281427.17652.16.camel@strongmad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1175281427.17652.16.camel@strongmad>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2007 at 12:03:47PM -0700, Mitch Williams wrote:
> This patch fixes a kernel bug which is triggered when using the
> irqbalance daemon with MSI-X hardware.
> 
> Because both MSI-X interrupt messages and MSI-X table writes are posted,
> it's possible for them to cross while in-flight.  This results in
> interrupts being received long after the kernel thinks they're disabled,
> and in interrupts being sent to stale vectors after rebalancing.
> 
> This patch performs a read flush after writes to the MSI-X table for
> mask and unmask operations.  Since the SMP affinity is set while
> the interrupt is masked, and since it's unmasked immediately after,
> no additional flushes are required in the various affinity setting
> routines.
> 
> This patch has been validated with (unreleased) network hardware which
> uses MSI-X.
> 
> Revised with input from Eric Biederman.
> 
> Signed-off-by: Mitch Williams <mitch.a.williams@intel.com>

Sorry, but this isn't going to go into 2.6.20 any time soon as it
doesn't fit the rules for the -stable tree.

But I'll take an updated version for my pci tree to go to Linus after
2.6.21 is out.

thanks,

greg k-h
