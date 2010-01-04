Return-Path: <linux-kernel-owner+w=401wt.eu-S1753578Ab0ADR0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578Ab0ADR0j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 12:26:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753333Ab0ADR0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 12:26:37 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:49512 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab0ADR0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 12:26:36 -0500
Date: Mon, 4 Jan 2010 11:26:23 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Haicheng Li <haicheng.li@linux.intel.com>
cc: Andi Kleen <andi@firstfloor.org>, Eric Dumazet <eric.dumazet@gmail.com>,
       linux-mm@kvack.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab: initialize unused alien cache entry as NULL at
 alloc_alien_cache().
In-Reply-To: <4B31FDCF.9050208@linux.intel.com>
Message-ID: <alpine.DEB.2.00.1001041125090.7191@router.home>
References: <4B30BDA8.1070904@linux.intel.com> <alpine.DEB.2.00.0912220945250.12048@router.home> <4B31BE44.1070308@linux.intel.com> <4B31EC7C.7000302@gmail.com> <20091223102343.GD20539@basil.fritz.box> <4B31FDCF.9050208@linux.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Dec 2009, Haicheng Li wrote:

> > It should have been set up by the SRAT parser (modulo regressions)
> >
> > Haicheng, did you verify with printk it's really incorrect at this point?
>
> Yup. See below debug patch & Oops info.
>
> If we can make sure that SRAT parser must be able to detect out all possible
> node (even the node, cpu+mem, is not populated on the motherboard), it would
> be ACPI Parser issue or BIOS issue rather than a slab issue. In such case, I
> think this patch might become a workaround for buggy system board; and we
> might need to look into ACPI SRAT parser code as well:).

Right. Lets fix the SRAT / ACPI issue. Code elsewhere also dimensions
arrays to nr_node_ids.
