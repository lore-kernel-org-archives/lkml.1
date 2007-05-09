Return-Path: <linux-kernel-owner+w=401wt.eu-S969309AbXEIBvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969309AbXEIBvs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 21:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967555AbXEIBvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 21:51:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59711
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S967446AbXEIBvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 21:51:41 -0400
Date: Tue, 08 May 2007 18:51:41 -0700 (PDT)
Message-Id: <20070508.185141.85412154.davem@davemloft.net>
To: clameter@sgi.com
Cc: mpm@selenic.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: +
 fix-spellings-of-slab-allocator-section-in-init-kconfig.patch added to -mm
 tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0705081828300.17376@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0705081746500.16914@schroedinger.engr.sgi.com>
	<20070509012725.GZ11115@waste.org>
	<Pine.LNX.4.64.0705081828300.17376@schroedinger.engr.sgi.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>
Date: Tue, 8 May 2007 18:32:35 -0700 (PDT)

> That SLUB cannot do. And I do not believe you. SLOB must have some way to 
> distinguish the objects and their sizes since kfree does not include size 
> information. You can mix slabs of different size on the same page without 
> metadata. Magic?
> 
> So how does kfree then know how to free the object? There must be some way 
> where you get the metainformation. What is the point of your 8 byte 
> metadata that keeps getting inserted? That does not consume memory on a 
> page?

SLOB uses metadata, but that metadata seemingly only needs to be
uptodate in freed objects.

SLOB seems to look at the descriptor in the previous blob to figure
out how big the being-freed blob is.  That's actually kind of clever
:-)

