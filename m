Return-Path: <linux-kernel-owner+w=401wt.eu-S1755206AbYA3I1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206AbYA3I1V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 03:27:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753312AbYA3I1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 03:27:11 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:41789 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920AbYA3I1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 03:27:10 -0500
Subject: Re: [patch 2/6] mmu_notifier: Callbacks to invalidate address
	ranges
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Christoph Lameter <clameter@sgi.com>, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       Nick Piggin <npiggin@suse.de>, kvm-devel@lists.sourceforge.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Hugh Dickins <hugh@veritas.com>
In-Reply-To: <20080130005912.GC7233@v2.random>
References: <20080128202923.849058104@sgi.com>
	 <20080129162004.GL7233@v2.random>
	 <Pine.LNX.4.64.0801291153520.25300@schroedinger.engr.sgi.com>
	 <20080129211759.GV7233@v2.random>
	 <Pine.LNX.4.64.0801291327330.26649@schroedinger.engr.sgi.com>
	 <20080129220212.GX7233@v2.random>
	 <Pine.LNX.4.64.0801291407380.27104@schroedinger.engr.sgi.com>
	 <20080130000039.GA7233@v2.random> <20080130000559.GB7233@v2.random>
	 <Pine.LNX.4.64.0801291621380.28027@schroedinger.engr.sgi.com>
	 <20080130005912.GC7233@v2.random>
Content-Type: text/plain
Date: Wed, 30 Jan 2008 09:26:22 +0100
Message-Id: <1201681582.28547.160.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-01-30 at 01:59 +0100, Andrea Arcangeli wrote:
> On Tue, Jan 29, 2008 at 04:22:46PM -0800, Christoph Lameter wrote:
> > That is only partially true. pte are created wronly in order to track 
> > dirty state these days. The first write will lead to a fault that switches 
> > the pte to writable. When the page undergoes writeback the page again 
> > becomes write protected. Thus our need to effectively deal with 
> > page_mkclean.
> 
> Well I was talking about anonymous memory.

Just to be absolutely clear on this (I lost track of what exactly we are
talking about here), nonlinear mappings no not do the dirty accounting,
and are not allowed on a backing store that would require dirty
accounting.



