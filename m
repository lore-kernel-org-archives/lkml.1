Return-Path: <linux-kernel-owner+w=401wt.eu-S1761741AbXF2JGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761741AbXF2JGp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 05:06:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754738AbXF2JGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 05:06:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53523
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754303AbXF2JGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 05:06:35 -0400
Date: Fri, 29 Jun 2007 02:06:55 -0700 (PDT)
Message-Id: <20070629.020655.35469430.davem@davemloft.net>
To: clameter@sgi.com
Cc: hugh@veritas.com, James.Bottomley@steeleye.com, rmk+lkml@arm.linux.org.uk,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Containment measures for slab objects on scatter
 gather lists
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0706282357540.12146@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0706282128570.11739@schroedinger.engr.sgi.com>
	<20070628.220606.112621271.davem@davemloft.net>
	<Pine.LNX.4.64.0706282357540.12146@schroedinger.engr.sgi.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>
Date: Fri, 29 Jun 2007 00:00:39 -0700 (PDT)

> On Thu, 28 Jun 2007, David Miller wrote:
> 
> > Really, it would be great if we could treat kmalloc() objects
> > just like real pages.  Everything wants to do I/O on pages
> > but sometimes (like the networking) you have a kmalloc
> > chunk which is technically just a part of a page.
> > 
> > The fact that there is no easy way to make this work is
> > frustrating :-)
> 
> There is easy way: Allocate a page and just use the first N bytes. You can 
> specify the bytes to be used when putting the memory onto the scatter 
> gather list. This wastes memory but it works. You have real refcounting 
> since you got a real page.
> 
> How frequent are these objects?

Every single network packet.
