Return-Path: <linux-kernel-owner+w=401wt.eu-S934340AbZFLNtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934340AbZFLNtv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933915AbZFLNon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:44:43 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:47273 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933858AbZFLNoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:44:39 -0400
Date: Fri, 12 Jun 2009 09:44:04 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, mingo@elte.hu, akpm@linux-foundation.org,
       npiggin@suse.de
Subject: Re: slab: setup allocators earlier in the boot sequence
In-Reply-To: <1244796211.30512.32.camel@penberg-laptop>
Message-ID: <alpine.DEB.1.10.0906120941550.15809@gentwo.org>
References: <200906111959.n5BJxFj9021205@hera.kernel.org>  <1244770230.7172.4.camel@pasglop>  <1244779009.7172.52.camel@pasglop>  <1244780756.7172.58.camel@pasglop> <1244783235.7172.61.camel@pasglop>  <Pine.LNX.4.64.0906120913460.26843@melkki.cs.Helsinki.FI>
  <1244792079.7172.74.camel@pasglop>  <1244792745.30512.13.camel@penberg-laptop>  <1244796045.7172.82.camel@pasglop> <1244796211.30512.32.camel@penberg-laptop>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Jun 2009, Pekka Enberg wrote:

> Yes, you're obviously right. I overlooked the fact that arch code have
> their own special slab_is_available() heuristics (yikes!).

Thats another area where we would need some cleanup in the future. The
slab_is_available() has become a check for the end of the use of bootmem.

What would be clearer is to have something like

allocator_bootstrap_complete()

to tell us that all memory allocators are available (slab, page, percpu,
vmalloc);
