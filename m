Return-Path: <linux-kernel-owner+w=401wt.eu-S1755470AbYDWSh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470AbYDWSh3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 14:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751267AbYDWShV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 14:37:21 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:38615
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbYDWShU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 14:37:20 -0400
Date: Wed, 23 Apr 2008 20:37:18 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Robin Holt <holt@sgi.com>, Nick Piggin <npiggin@suse.de>,
       Jack Steiner <steiner@sgi.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel@lists.sourceforge.net, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       Roland Dreier <rdreier@cisco.com>,
       Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, linux-mm@kvack.org,
       general@lists.openfabrics.org, Hugh Dickins <hugh@veritas.com>,
       akpm@linux-foundation.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 01 of 12] Core of mmu notifiers
Message-ID: <20080423183718.GL24536@duo.random>
References: <ea87c15371b1bd49380c.1208872277@duo.random> <Pine.LNX.4.64.0804221315160.3640@schroedinger.engr.sgi.com> <20080422223545.GP24536@duo.random> <20080422230727.GR30298@sgi.com> <20080423133619.GV24536@duo.random> <20080423144747.GU30298@sgi.com> <20080423155940.GY24536@duo.random> <Pine.LNX.4.64.0804231105090.12373@schroedinger.engr.sgi.com> <20080423181928.GI24536@duo.random> <Pine.LNX.4.64.0804231122410.12373@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804231122410.12373@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2008 at 11:27:21AM -0700, Christoph Lameter wrote:
> There is a potential issue in move_ptes where you call 
> invalidate_range_end after dropping i_mmap_sem whereas my patches did the 
> opposite. Mmap_sem saves you there?

Yes, there's really no risk of races in this area after introducing
mm_lock, any place that mangles over ptes and doesn't hold any of the
three locks is buggy anyway. I appreciate the audit work (I also did
it and couldn't find bugs but the more eyes the better).
