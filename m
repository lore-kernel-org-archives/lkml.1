Return-Path: <linux-kernel-owner+w=401wt.eu-S1758858AbYAWRvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758858AbYAWRvs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 12:51:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757800AbYAWRvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 12:51:19 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:56646 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757805AbYAWRvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 12:51:18 -0500
Date: Wed, 23 Jan 2008 09:46:39 -0800
From: Greg KH <greg@kroah.com>
To: Ian Abbott <abbotti@mev.co.uk>
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net, gregkh@suse.de,
       kristen.c.accardi@intel.com
Subject: Re: [RESEND][PATCH-2.6.24-rc8] Fix fakephp deadlock
Message-ID: <20080123174639.GB10387@kroah.com>
References: <4795FD78.6020208@mev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4795FD78.6020208@mev.co.uk>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2008 at 02:28:08PM +0000, Ian Abbott wrote:
> #include <linux/init.h>
> #include <linux/string.h>
> #include <linux/slab.h>
> +#include <linux/workqueue.h>
> #include "../pci.h"
> #if !defined(MODULE)
> @@ -63,10 +64,13 @@ struct dummy_slot {
> 	struct list_head node;
> 	struct hotplug_slot *slot;
> 	struct pci_dev *dev;
> +	struct work_struct remove_work;
> +	unsigned long removed;

You are treating "removed" as an atomic value, so why not just make it
an atomic_t?

And what is protecting the fact that the flag could be set right after
it gets checked?  I don't see a lock here :)

thanks,

greg k-h
