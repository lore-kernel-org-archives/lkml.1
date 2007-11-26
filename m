Return-Path: <linux-kernel-owner+w=401wt.eu-S1756692AbXKZW61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692AbXKZW61 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 17:58:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754066AbXKZW6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 17:58:20 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56399 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753341AbXKZW6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 17:58:19 -0500
Date: Mon, 26 Nov 2007 14:58:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: greg@kroah.com, kay.sievers@vrfy.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Kobjects: drop child->parent ref at unregistration
Message-Id: <20071126145810.eb848f23.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.44L0.0711191047230.4806-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0711191047230.4806-100000@iolanthe.rowland.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Nov 2007 10:53:40 -0500 (EST)
Alan Stern <stern@rowland.harvard.edu> wrote:

> This patch (as1015) reverts changes that were made to the driver core
> about four years ago.  The intent back then was to avoid certain kinds
> of invalid memory accesses by leaving kernel objects allocated as long
> as any of their children were still allocated.  The original and
> correct approach was to wait only as long as any children were still
> _registered_; that's what this patch reinstates.

What happened with this?

> This fixes a problem in the SCSI core made visible by the class_device
> to regular device conversion: A reference loop (scsi_device holds
> reference to request_queue, which is the child of a gendisk, which is
> the child of the scsi_device) prevents the data structures from being
> released, even though they are deregistered okay.
> 
> It's possible that this change will cause a few bugs to surface,
> things that have been hidden for several years.  They can be fixed
> easily enough by having the child device take an explicit reference to
> the parent whenever needed.
> 

How will such bugs manifest?  Ideally via a nice printk and a stack trace
followed by damage avoidance.

If it's via a mysterious crash or something similarly obscure then can we
improve that?

