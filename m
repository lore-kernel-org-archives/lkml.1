Return-Path: <linux-kernel-owner+w=401wt.eu-S2992535AbXCWVYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992535AbXCWVYb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 17:24:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992573AbXCWVYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 17:24:31 -0400
Received: from mail.kroah.org ([69.55.234.183]:40862 "EHLO perch.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992535AbXCWVYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 17:24:30 -0400
Date: Fri, 23 Mar 2007 14:07:29 -0700
From: Greg KH <gregkh@suse.de>
To: Mitch Williams <mitch.a.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, auke-jan.h.kok@intel.com,
       john.ronciak@intel.com, jesse.brandeburg@intel.com
Subject: Re: [PATCH 2.6.20.3] Flush writes to MSI-X table
Message-ID: <20070323210729.GC12182@suse.de>
References: <1174597699.24177.32.camel@strongmad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174597699.24177.32.camel@strongmad>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2007 at 02:08:19PM -0700, Mitch Williams wrote:
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

Is this needed for any hardware that is public today?

Also, it seems a bit too big of a patch for -stable right now,
especially as the mainline patch will not make it into 2.6.22 at the
earliest.

thanks,

greg k-h
