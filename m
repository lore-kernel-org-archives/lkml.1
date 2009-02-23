Return-Path: <linux-kernel-owner+w=401wt.eu-S1753860AbZBWK0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860AbZBWK0g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 05:26:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbZBWK02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 05:26:28 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:39079 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbZBWK01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 05:26:27 -0500
Subject: Re: [patch 2/2] slub: add min_partial sysfs tunable
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.0902230126080.19494@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0902221710430.26165@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.0902221712160.26165@chino.kir.corp.google.com>
	 <1235377162.6216.5.camel@penberg-laptop>
	 <alpine.DEB.2.00.0902230126080.19494@chino.kir.corp.google.com>
Date: Mon, 23 Feb 2009 12:26:24 +0200
Message-Id: <1235384784.6216.34.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Mon, 23 Feb 2009, Pekka Enberg wrote:
> > The patches look good but the description is bit lacking. Does this
> > actually fix up something? Why don't we fix the limit calculations
> > instead?
> > 
> > I'm a sucker for numbers so I'm easily fooled into merging patches with
> > statements of the form "this shaves off N bytes/kb/mb on XYZ systems".

On Mon, 2009-02-23 at 01:58 -0800, David Rientjes wrote:
> The memory savings from simply moving min_partial from struct 
> kmem_cache_node to struct kmem_cache is obviously not significant (unless 
> maybe you're from SGI or something), at the largest it's
> 
> 	# allocated caches * (MAX_NUMNODES - 1) * sizeof(unsigned long)
> 
> The true savings occurs when userspace reduces the number of partial slabs 
> that would otherwise be wasted, especially on machines with a large 
> number of nodes (ia64 with CONFIG_NODES_SHIFT at 10 for default?).  As 
> well as the kernel estimates ideal values for n->min_partial and ensures 
> it's within a sane range, userspace has no other input other than writing 
> to /sys/kernel/slab/cache/shrink.

Applied with the above explanation added to the changelog. Thanks!

			Pekka

