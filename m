Return-Path: <linux-kernel-owner+w=401wt.eu-S1759664AbYDVQqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759664AbYDVQqa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 12:46:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754293AbYDVQqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 12:46:22 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:59461
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030AbYDVQqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 12:46:21 -0400
Date: Tue, 22 Apr 2008 18:46:15 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Christoph Lameter <clameter@sgi.com>, Nick Piggin <npiggin@suse.de>,
       Jack Steiner <steiner@sgi.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel@lists.sourceforge.net, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       Roland Dreier <rdreier@cisco.com>,
       Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, linux-mm@kvack.org,
       Robin Holt <holt@sgi.com>, general@lists.openfabrics.org,
       Hugh Dickins <hugh@veritas.com>, akpm@linux-foundation.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 01 of 12] Core of mmu notifiers
Message-ID: <20080422164615.GG24536@duo.random>
References: <ea87c15371b1bd49380c.1208872277@duo.random> <480DFC8A.8040105@cosmosbay.com> <20080422151529.GE24536@duo.random> <480E0642.6080109@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480E0642.6080109@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 05:37:38PM +0200, Eric Dumazet wrote:
> I am saying your intent was probably to test
>
> else if ((unsigned long)*(spinlock_t **)a ==
> 	    (unsigned long)*(spinlock_t **)b)
> 		return 0;

Indeed...

> Hum, it's not a micro-optimization, but a bug fix. :)

The good thing is that even if this bug would lead to a system crash,
it would be still zero risk for everybody that isn't using KVM/GRU
actively with mmu notifiers. The important thing is that this patch
has zero risk to introduce regressions into the kernel, both when
enabled and disabled, it's like a new driver. I'll shortly resend 1/12
and likely 12/12 for theoretical correctness. For now you can go ahead
testing with this patch as it'll work fine despite of the bug (if it
wasn't the case I would have noticed already ;).
