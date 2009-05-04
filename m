Return-Path: <linux-kernel-owner+w=401wt.eu-S1755700AbZEDN6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700AbZEDN6k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 09:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754242AbZEDN6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 09:58:31 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:49262 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbZEDN6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 09:58:30 -0400
Date: Mon, 4 May 2009 09:47:45 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Mel Gorman <mel@csn.ul.ie>, LKML <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH -tip] mm: introduce __GFP_PANIC modifier
In-Reply-To: <20090504131638.GJ4173@lenovo>
Message-ID: <alpine.DEB.1.10.0905040940490.9553@qirst.com>
References: <20090504122740.GH4173@lenovo> <20090504131311.GA23330@elte.hu> <20090504131638.GJ4173@lenovo>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Could you try to avoid consuming another GFP flag? __GFP_BITS_SHIFT is
used elsewhere to figure out where to put miscellanous flags into the gfp
mask. This is pretty limited right now and so the patch does work.

But maybe we can combine some flags __GFP_NOFAIL | __GFP_REPEAT or so?

__GFP_NOFAIL already has the semantics that the allocation cannot fail and
that the page allocator must never return NULL.


