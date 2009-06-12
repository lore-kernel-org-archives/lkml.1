Return-Path: <linux-kernel-owner+w=401wt.eu-S1757460AbZFLNyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460AbZFLNyX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756000AbZFLNyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:54:13 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:42180 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754835AbZFLNyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:54:11 -0400
Subject: Re: slab: setup allocators earlier in the boot sequence
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, mingo@elte.hu, akpm@linux-foundation.org,
       npiggin@suse.de
In-Reply-To: <alpine.DEB.1.10.0906120944540.15809@gentwo.org>
References: <200906111959.n5BJxFj9021205@hera.kernel.org>
	 <1244770230.7172.4.camel@pasglop>  <1244779009.7172.52.camel@pasglop>
	 <1244780756.7172.58.camel@pasglop> <1244783235.7172.61.camel@pasglop>
	 <Pine.LNX.4.64.0906120913460.26843@melkki.cs.Helsinki.FI>
	 <1244792079.7172.74.camel@pasglop>
	 <1244792745.30512.13.camel@penberg-laptop>
	 <1244796045.7172.82.camel@pasglop>
	 <1244796211.30512.32.camel@penberg-laptop>
	 <1244796837.7172.95.camel@pasglop>
	 <1244797659.30512.37.camel@penberg-laptop>
	 <alpine.DEB.1.10.0906120944540.15809@gentwo.org>
Date: Fri, 12 Jun 2009 16:54:12 +0300
Message-Id: <1244814852.30512.67.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On Fri, 2009-06-12 at 09:49 -0400, Christoph Lameter wrote:
> Best thing to do is to recognize the fact that we are still in early boot
> in the allocators. Derived allocators (such as slab and vmalloc) mask bits
> using GFP_RECLAIM_MASK and when doing allocations through the page
> allocator. You could make GFP_RECLAIM_MASK a variable. During boot
> __GFP_WAIT would not be set in GFP_RECLAIM_MASK.

Ben's patch does something like that and I have patches that do that
floating around too.

The problem here is that it's not enough that we make GFP_RECLAIM_MASK a
variable. There are various _debugging checks_ that happen much earlier
than that. We need to mask out those too which adds overhead to
kmalloc() fastpath, for example.

			Pekka

