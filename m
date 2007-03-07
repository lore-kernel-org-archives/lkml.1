Return-Path: <linux-kernel-owner+w=401wt.eu-S1422655AbXCGJ3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422655AbXCGJ3f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 04:29:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422660AbXCGJ3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 04:29:35 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:54255 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422655AbXCGJ3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 04:29:32 -0500
Date: Wed, 7 Mar 2007 01:29:03 -0800
From: Bill Irwin <bill.irwin@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
       Linux Memory Management <linux-mm@kvack.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "Paolo 'Blaisorblade' Giarrusso" <blaisorblade@yahoo.it>
Subject: Re: [patch 4/6] mm: merge populate and nopage into fault (fixes nonlinear)
Message-ID: <20070307092903.GJ18774@holomorphy.com>
Mail-Followup-To: Bill Irwin <bill.irwin@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
	Linux Memory Management <linux-mm@kvack.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
References: <20070221023656.6306.246.sendpatchset@linux.site> <20070221023735.6306.83373.sendpatchset@linux.site> <20070306225101.f393632c.akpm@linux-foundation.org> <20070307070853.GB15877@wotan.suse.de> <20070307081948.GA9563@wotan.suse.de> <20070307082755.GA25733@elte.hu> <20070307003520.08b1a082.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070307003520.08b1a082.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2007 09:27:55 +0100 Ingo Molnar <mingo@elte.hu> wrote:
>> btw., if we decide that nonlinear isnt worth the continuing maintainance 
>> pain, we could internally implement/emulate sys_remap_file_pages() via a 
>> call to mremap() and essentially deprecate it, without breaking the ABI 
>> - and remove all the nonlinear code. (This would split fremap areas into 
>> separate vmas)

On Wed, Mar 07, 2007 at 12:35:20AM -0800, Andrew Morton wrote:
> I'm rather regretting having merged it - I don't think it has been used for
> much.
> Paolo's UML speedup patches might use nonlinear though.

Guess what major real-life application not only uses nonlinear daily
but would even be very happy to see it extended with non-vma-creating
protections and more? It's not terribly typical for things to be
truncated while remap_file_pages() is doing its work, though it's been
proposed as a method of dynamism. It won't stress remap_file_pages() vs.
truncate() in any meaningful way, though, as userspace will be rather
diligent about clearing in-use data out of the file offset range to be
truncated away anyway, and all that via O_DIRECT.


-- wli
