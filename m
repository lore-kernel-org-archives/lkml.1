Return-Path: <linux-kernel-owner+w=401wt.eu-S1757468AbZFKPVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468AbZFKPVH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 11:21:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754142AbZFKPU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 11:20:56 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:45604 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753354AbZFKPU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 11:20:56 -0400
Date: Thu, 11 Jun 2009 11:20:50 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: linux-kernel@vger.kernel.org, mel@csn.ul.ie, Larry.Finger@lwfinger.net
Subject: Re: [PATCH 2/2] SLUB: Disable debugging if it increases the minimum
 page order
In-Reply-To: <1244733119.17483.56.camel@penberg-laptop>
Message-ID: <alpine.DEB.1.10.0906111118350.14020@gentwo.org>
References: <Pine.LNX.4.64.0906111143490.6132@melkki.cs.Helsinki.FI>  <alpine.DEB.1.10.0906110941520.29827@gentwo.org>  <1244728824.17483.51.camel@penberg-laptop>  <alpine.DEB.1.10.0906111021340.29827@gentwo.org> <1244733119.17483.56.camel@penberg-laptop>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Jun 2009, Pekka Enberg wrote:

> I think my patch is the simplest solution here: it turns off debugging
> for those caches where the metadata bumps up the minimum allocation
> order and I suspect that we disable cache only for 4096 in practice.

There could be other slab caches that would randomly be affected by this.
I ran a couple of times into situations where I had to hack slab to do
debugging of exempted slabs.

> Also note that when we switch back to more aggressive page allocator
> pass-through, we lose SLUB debugging support.

Debugging options can have side effects. Slab debugging is not something
suitable by default for production environments.

