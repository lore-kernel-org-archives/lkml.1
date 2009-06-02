Return-Path: <linux-kernel-owner+w=401wt.eu-S1759443AbZFBG1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759443AbZFBG1q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 02:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756980AbZFBG1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 02:27:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52286 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755866AbZFBG1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 02:27:38 -0400
Date: Tue, 2 Jun 2009 08:27:38 +0200
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
       Mel Gorman <mel@csn.ul.ie>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <cl@linux-foundation.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3 -mmotm] oom: invoke oom killer for __GFP_NOFAIL
Message-ID: <20090602062738.GA31556@wotan.suse.de>
References: <alpine.DEB.2.00.0906011828040.6936@chino.kir.corp.google.com> <alpine.DEB.2.00.0906011830490.6936@chino.kir.corp.google.com> <20090601225602.3482cd0d.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090601225602.3482cd0d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 01, 2009 at 10:56:02PM -0700, Andrew Morton wrote:
> On Mon, 1 Jun 2009 18:31:14 -0700 (PDT) David Rientjes <rientjes@google.com> wrote:
> Do we know of any callsites which do greater-than-order-0 allocations
> with GFP_NOFAIL?  If so, we should fix them.

Yeah, we have GFP_NOFAIL going to the slab allocator, so all bets are
off in regard to the order.

Hmm, checkpatch should warn about it too shouldn't it? We recently
acquired one right on the IO submission path, unfortunately.

7ba1ba12eeef0aa7113beb16410ef8b7c748e18b

