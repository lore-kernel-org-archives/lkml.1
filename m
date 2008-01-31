Return-Path: <linux-kernel-owner+w=401wt.eu-S1760305AbYAaCfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760305AbYAaCfe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 21:35:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755032AbYAaCfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 21:35:18 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:35069 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755101AbYAaCeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 21:34:03 -0500
Date: Wed, 30 Jan 2008 20:34:01 -0600
From: Robin Holt <holt@sgi.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrea Arcangeli <andrea@qumranet.com>, Nick Piggin <npiggin@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>,
       kvm-devel@lists.sourceforge.net, daniel.blueman@quadrics.com,
       Robin Holt <holt@sgi.com>, Hugh Dickins <hugh@veritas.com>
Subject: Re: [kvm-devel] [patch 2/6] mmu_notifier: Callbacks to invalidate
	address ranges
Message-ID: <20080131023401.GY26420@sgi.com>
References: <20080130000039.GA7233@v2.random> <20080130161123.GS26420@sgi.com> <20080130170451.GP7233@v2.random> <20080130173009.GT26420@sgi.com> <20080130182506.GQ7233@v2.random> <Pine.LNX.4.64.0801301147330.30568@schroedinger.engr.sgi.com> <20080130235214.GC7185@v2.random> <Pine.LNX.4.64.0801301555550.1722@schroedinger.engr.sgi.com> <20080131003434.GE7185@v2.random> <Pine.LNX.4.64.0801301728110.2454@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801301728110.2454@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Well the GRU uses follow_page() instead of get_user_pages. Performance is 
> a major issue for the GRU. 

Worse, the GRU takes its TLB faults from within an interrupt so we
use follow_page to prevent going to sleep.  That said, I think we
could probably use follow_page() with FOLL_GET set to accomplish the
requirements of mmu_notifier invalidate_range call.  Doesn't look too
promising for hugetlb pages.

Thanks,
Robin
