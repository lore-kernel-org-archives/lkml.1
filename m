Return-Path: <linux-kernel-owner+w=401wt.eu-S1756453AbYFJSa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453AbYFJSa3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 14:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753149AbYFJSaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 14:30:21 -0400
Received: from relay1.sgi.com ([192.48.171.29]:37666 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752934AbYFJSaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 14:30:20 -0400
Date: Tue, 10 Jun 2008 11:30:19 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Vegard Nossum <vegard.nossum@gmail.com>
cc: Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       David Howells <dhowells@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, cooloney@kernel.org,
       mpm@selenic.com
Subject: Re: [PATCH] nommu: fix kobjsize() for SLOB and SLUB, v2.
In-Reply-To: <19f34abd0806101118r5edbc065t8a19b69abf9aea5c@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0806101128450.17349@schroedinger.engr.sgi.com>
References: <20080602072706.GB28268@linux-sh.org> 
 <Pine.LNX.4.64.0806101027220.17093@schroedinger.engr.sgi.com>
 <19f34abd0806101118r5edbc065t8a19b69abf9aea5c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2008, Vegard Nossum wrote:

> Are you sure it shouldn't be virt_addr_valid()? If yes, can you please
> explain the difference? Thanks :-)

from include/asm-x86/page.h

#define virt_addr_valid(kaddr) pfn_valid(__pa(kaddr) >> PAGE_SHIFT)

#define virt_to_page(kaddr)     pfn_to_page(__pa(kaddr) >> PAGE_SHIFT)


Yes virt_addr_valid is better to use. I was thinking too much using the 
basic ops.


