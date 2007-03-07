Return-Path: <linux-kernel-owner+w=401wt.eu-S1422684AbXCGJoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422684AbXCGJoo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 04:44:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422686AbXCGJoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 04:44:44 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:42983 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422684AbXCGJon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 04:44:43 -0500
Date: Wed, 7 Mar 2007 01:44:20 -0800
From: Bill Irwin <bill.irwin@oracle.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management <linux-mm@kvack.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "Paolo 'Blaisorblade' Giarrusso" <blaisorblade@yahoo.it>
Subject: Re: [patch 4/6] mm: merge populate and nopage into fault (fixes nonlinear)
Message-ID: <20070307094420.GL18774@holomorphy.com>
Mail-Followup-To: Bill Irwin <bill.irwin@oracle.com>,
	Nick Piggin <npiggin@suse.de>, Ingo Molnar <mingo@elte.hu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management <linux-mm@kvack.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
References: <20070221023656.6306.246.sendpatchset@linux.site> <20070221023735.6306.83373.sendpatchset@linux.site> <20070306225101.f393632c.akpm@linux-foundation.org> <20070307070853.GB15877@wotan.suse.de> <20070307081948.GA9563@wotan.suse.de> <20070307082755.GA25733@elte.hu> <20070307003520.08b1a082.akpm@linux-foundation.org> <20070307085323.GB27337@elte.hu> <20070307092821.GB8609@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070307092821.GB8609@wotan.suse.de>
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2007 at 10:28:21AM +0100, Nick Piggin wrote:
> Depending on whether anyone wants it, and what features they want, we
> could emulate the old syscall, and make a new restricted one which is
> much less intrusive.
> For example, if we can operate only on MAP_ANONYMOUS memory and specify
> that nonlinear mappings effectively mlock the pages, then we can get
> rid of all the objrmap and unmap_mapping_range handling, forget about
> the writeout and msync problems...

Anonymous-only would make it a doorstop for Oracle, since its entire
motive for using it is to window into objects larger than user virtual
address spaces (this likely also applies to UML, though they should
really chime in to confirm). Restrictions to tmpfs and/or ramfs would
likely be liveable, though I suspect some things might want to do it to
shm segments (I'll ask about that one). There's definitely no need for a
persistent backing store for the object to be remapped in Oracle's case,
in any event. It's largely the in-core destination and source of IO, not
something saved on-disk itself.


-- wli
