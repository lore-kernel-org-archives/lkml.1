Return-Path: <linux-kernel-owner+w=401wt.eu-S1760181AbZAWNom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760181AbZAWNom (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 08:44:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756246AbZAWNoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 08:44:32 -0500
Received: from mx2.suse.de ([195.135.220.15]:45948 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756232AbZAWNo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 08:44:29 -0500
Date: Fri, 23 Jan 2009 14:44:23 +0100
From: Nick Piggin <npiggin@suse.de>
To: Hugh Dickins <hugh@veritas.com>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Christoph Lameter <clameter@engr.sgi.com>
Subject: Re: [patch] SLQB slab allocator
Message-ID: <20090123134423.GI19986@wotan.suse.de>
References: <20090121143008.GV24891@wotan.suse.de> <1232613933.11429.127.camel@ymzhang> <20090123090042.GB19986@wotan.suse.de> <Pine.LNX.4.64.0901231326520.9011@blonde.anvils>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0901231326520.9011@blonde.anvils>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2009 at 01:34:49PM +0000, Hugh Dickins wrote:
> On Fri, 23 Jan 2009, Nick Piggin wrote:
> > 
> > ... Would you be able to test with this updated patch
> > (which also includes Hugh's fix ...
> 
> In fact not: claim_remote_free_list() still has the offending unlocked
> +	VM_BUG_ON(!l->remote_free.list.head != !l->remote_free.list.tail);

Doh, thanks. Turned out to still miss a few cases where it wasn't
checking for memoryless nodes (Andi explains why I didn't see it
with x86-64: because it handles the case differently and assigns
the default node to the nearest one with memory. I think).

Working on a new version, so I've definitely got your bug covered
now :)

