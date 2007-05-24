Return-Path: <linux-kernel-owner+w=401wt.eu-S1761428AbXEXD4E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761428AbXEXD4E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 23:56:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758517AbXEXDzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 23:55:53 -0400
Received: from ozlabs.org ([203.10.76.45]:33787 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758457AbXEXDzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 23:55:52 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18005.2746.374990.29287@cargo.ozlabs.ibm.com>
Date: Thu, 24 May 2007 13:47:06 +1000
From: Paul Mackerras <paulus@samba.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: Define CONFIG_BOUNCE to avoid useless inclusion of bounce buffer
 logic.
In-Reply-To: <Pine.LNX.4.64.0705231011000.19822@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0705212100420.24947@schroedinger.engr.sgi.com>
	<20070522133906.ae9c362a.kamezawa.hiroyu@jp.fujitsu.com>
	<Pine.LNX.4.64.0705212225590.25388@schroedinger.engr.sgi.com>
	<20070523140702.GA16972@flint.arm.linux.org.uk>
	<Pine.LNX.4.64.0705231011000.19822@schroedinger.engr.sgi.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter writes:

> > The DMA zone is for memory allocations _for_ _DMA_.  If all your memory
> > is DMA-able then it belongs in the DMA zone.
> 
> Nope. The DMA zone is for crappy DMA devices that can only use a portion 
> of memory.

That is (presumably) true today, but is in fact a redefinition of what
ZONE_DMA historically was for.

Also there is the problem that some drivers use ZONE_DMA allocations
because their device can only generate addresses below some limit, but
on a platform with an IOMMU there is in fact no restriction on what
memory the device can access.

Paul.
