Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1751442AbYLQT1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751442AbYLQT1V (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 14:27:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751383AbYLQT0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 14:26:50 -0500
Received: from sj-iport-1.cisco.com ([171.71.176.70]:51545 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbYLQT0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 14:26:48 -0500
X-IronPort-AV: E=Sophos;i="4.36,238,1228089600"; 
   d="scan'208";a="119645503"
From: Roland Dreier <rdreier@cisco.com>
To: "Matt Turner" <mattst88@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Ivan Kokshaysky" <ink@jurassic.park.msu.ru>,
        rth@twiddle.net, "Jay Estabrook" <jay.estabrook@hp.com>
Subject: Re: questions about native alpha futex implementation
References: <b4198de60812171113r72d8d04ao67cde38c62185bcc@mail.gmail.com>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 17 Dec 2008 11:26:47 -0800
In-Reply-To: <b4198de60812171113r72d8d04ao67cde38c62185bcc@mail.gmail.com>
	(Matt Turner's message of "Wed, 17 Dec 2008 14:13:15 -0500")
Message-ID: <adaprjqzjpk.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 17 Dec 2008 19:26:47.0637 (UTC) FILETIME=[6742A850:01C9607D]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Alpha uses a generic futex implementation, which causes some problems [1].

Summarizing this: the generic futex implementation leaves
futex_atomic_cmpxchg_inatomic() as a stub that just returns -ENOSYS, and
glibc robust futex code can't handle this return value, which leads to
glibc tests hanging.

 > I've read through the code, and it appears as if the implementation
 > could be done by using the ldq_l/stq_c instructions, relatively easy I
 > might add. I'm definitely interested in implementing this, but first...
 > 
 > I have only a few questions.
 > 
 > 1) What are the benefits of a native futex implementation, other than
 > fixing the glibc test failures?

Presumably native implementations can use optimized assembly, which
would be somewhat faster than a generic implementation in C.

 > 2) Is there a technical reason it hasn't been implemented on Alpha?

I don't know for sure, but I would guess it's just that no one has cared
enough about optimizing futexes on alpha.

A native implementation for alpha is probably an amusing project, but
also figuring out a way of implementing the missing operations for
generic futexes would be nice too (given that glibc uses them now).
Although a generic futex_atomic_cmpxchg_inatomic() that works for SMP
might be tricky.

 - R.
