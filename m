Return-Path: <linux-kernel-owner+w=401wt.eu-S933151AbYDVWgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933151AbYDVWgB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 18:36:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758857AbYDVWfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 18:35:53 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:59111
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425AbYDVWfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 18:35:53 -0400
Date: Wed, 23 Apr 2008 00:35:45 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <npiggin@suse.de>, Jack Steiner <steiner@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel@lists.sourceforge.net, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       Roland Dreier <rdreier@cisco.com>,
       Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, linux-mm@kvack.org,
       Robin Holt <holt@sgi.com>, general@lists.openfabrics.org,
       Hugh Dickins <hugh@veritas.com>, akpm@linux-foundation.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 01 of 12] Core of mmu notifiers
Message-ID: <20080422223545.GP24536@duo.random>
References: <ea87c15371b1bd49380c.1208872277@duo.random> <Pine.LNX.4.64.0804221315160.3640@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804221315160.3640@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 01:19:29PM -0700, Christoph Lameter wrote:
> 3. As noted by Eric and also contained in private post from yesterday by 
>    me: The cmp function needs to retrieve the value before
>    doing comparisons which is not done for the == of a and b.

I retrieved the value, which is why mm_lock works perfectly on #v13 as
well as #v12. It's not mandatory to ever return 0, so it won't produce
any runtime error (there is a bugcheck for wrong sort ordering in my
patch just in case it would generate any runtime error and it never
did, or I would have noticed before submission), which is why I didn't
need to release any hotfix yet and I'm waiting more time to get more
comments before sending an update to clean up that bit.

Mentioning this as the third and last point I guess shows how strong
are your arguments against merging my mmu-notifier-core now, so in the
end doing that cosmetical error payed off somehow.

I'll send an update in any case to Andrew way before Saturday so
hopefully we'll finally get mmu-notifiers-core merged before next
week. Also I'm not updating my mmu-notifier-core patch anymore except
for strict bugfixes so don't worry about any more cosmetical bugs
being introduced while optimizing the code like it happened this time.

The only other change I did has been to move mmu_notifier_unregister
at the end of the patchset after getting more questions about its
reliability and I documented a bit the rmmod requirements for
->release. we'll think later if it makes sense to add it, nobody's
using it anyway.
