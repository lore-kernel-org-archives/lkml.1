Return-Path: <linux-kernel-owner+w=401wt.eu-S1758332AbYA3Tlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758332AbYA3Tlo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 14:41:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754634AbYA3Tlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 14:41:36 -0500
Received: from relay2.sgi.com ([192.48.171.30]:46487 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751822AbYA3Tlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 14:41:35 -0500
Date: Wed, 30 Jan 2008 11:41:29 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Jack Steiner <steiner@sgi.com>
cc: Andrea Arcangeli <andrea@qumranet.com>, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       Nick Piggin <npiggin@suse.de>, kvm-devel@lists.sourceforge.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, daniel.blueman@quadrics.com,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch 2/6] mmu_notifier: Callbacks to invalidate address ranges
In-Reply-To: <20080130144305.GA25193@sgi.com>
Message-ID: <Pine.LNX.4.64.0801301140320.30568@schroedinger.engr.sgi.com>
References: <20080129162004.GL7233@v2.random>
 <Pine.LNX.4.64.0801291153520.25300@schroedinger.engr.sgi.com>
 <20080129211759.GV7233@v2.random> <Pine.LNX.4.64.0801291327330.26649@schroedinger.engr.sgi.com>
 <20080129220212.GX7233@v2.random> <Pine.LNX.4.64.0801291407380.27104@schroedinger.engr.sgi.com>
 <20080130000039.GA7233@v2.random> <Pine.LNX.4.64.0801291620170.28027@schroedinger.engr.sgi.com>
 <20080130002804.GA13840@sgi.com> <20080130133720.GM7233@v2.random>
 <20080130144305.GA25193@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jan 2008, Jack Steiner wrote:

> I see what you mean. I need to review to mail to see why this changed
> but in the original discussions with Christoph, the invalidate_range
> callouts were suppose to be made BEFORE the pages were put on the freelist.

Seems that we cannot rely on the invalidate_ranges for correctness at all?
We need to have invalidate_page() always. invalidate_range() is only an 
optimization.


