Return-Path: <linux-kernel-owner+w=401wt.eu-S1763709AbZFLOId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763709AbZFLOId (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 10:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759382AbZFLOIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 10:08:04 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:37732 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764869AbZFLOIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 10:08:02 -0400
Date: Fri, 12 Jun 2009 10:07:57 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, mingo@elte.hu, akpm@linux-foundation.org,
       npiggin@suse.de
Subject: Re: slab: setup allocators earlier in the boot sequence
In-Reply-To: <1244814852.30512.67.camel@penberg-laptop>
Message-ID: <alpine.DEB.1.10.0906121006540.15809@gentwo.org>
References: <200906111959.n5BJxFj9021205@hera.kernel.org>  <1244770230.7172.4.camel@pasglop>  <1244779009.7172.52.camel@pasglop>  <1244780756.7172.58.camel@pasglop> <1244783235.7172.61.camel@pasglop>  <Pine.LNX.4.64.0906120913460.26843@melkki.cs.Helsinki.FI>
  <1244792079.7172.74.camel@pasglop>  <1244792745.30512.13.camel@penberg-laptop>  <1244796045.7172.82.camel@pasglop>  <1244796211.30512.32.camel@penberg-laptop>  <1244796837.7172.95.camel@pasglop>  <1244797659.30512.37.camel@penberg-laptop> 
 <alpine.DEB.1.10.0906120944540.15809@gentwo.org> <1244814852.30512.67.camel@penberg-laptop>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Jun 2009, Pekka Enberg wrote:

> The problem here is that it's not enough that we make GFP_RECLAIM_MASK a
> variable. There are various _debugging checks_ that happen much earlier
> than that. We need to mask out those too which adds overhead to
> kmalloc() fastpath, for example.

True. The GFP_RECLAIM_MASK only addresses the passing of gfp flags from a
derived allocator to the page allocator. It will deal only with the issue
of GFP_WAIT handling.


