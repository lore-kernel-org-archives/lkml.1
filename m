Return-Path: <linux-kernel-owner+w=401wt.eu-S1763027AbZEHPoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763027AbZEHPoY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 11:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754620AbZEHPoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 11:44:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42028 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323AbZEHPoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 11:44:14 -0400
Subject: Re: [PATCH 2/2] SLUB: Use GFP_PANIC for early-boot allocations
From: Peter Zijlstra <peterz@infradead.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <cl@linux-foundation.org>, akpm@linux-foundation.org,
       gorcunov@openvz.org, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie,
       riel@redhat.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       rientjes@google.com
In-Reply-To: <1241797017.28600.63.camel@penberg-laptop>
References: <1241795429.28600.61.camel@penberg-laptop>
	 <alpine.DEB.1.10.0905081127240.26361@qirst.com>
	 <1241797017.28600.63.camel@penberg-laptop>
Content-Type: text/plain
Date: Fri, 08 May 2009 17:42:44 +0200
Message-Id: <1241797364.6311.2914.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-08 at 18:36 +0300, Pekka Enberg wrote:
> On Fri, 2009-05-08 at 11:28 -0400, Christoph Lameter wrote:
> > On Fri, 8 May 2009, Pekka Enberg wrote:
> > 
> > > This patch converts SLUB early-boot code to use GFP_PANIC instead of explicit
> > > BUG_ON() calls.
> > 
> > Yirks this is not only early boot code. create_unique_id may be executed
> > whenever a slab is created.
> 
> Argh. We should do -ENOMEM there then. I'll drop that hunk.

BUG_ON((gfp & __GFP_PANIC) && (system_state != STATE_BOOTING));

?

