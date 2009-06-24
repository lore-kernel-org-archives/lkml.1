Return-Path: <linux-kernel-owner+w=401wt.eu-S1759454AbZFXJs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759454AbZFXJs7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 05:48:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752885AbZFXJsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 05:48:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759362AbZFXJsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 05:48:46 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, James Morris <jmorris@namei.org>,
       Ingo Molnar <mingo@elte.hu>, Chris Wright <chrisw@sous-sol.org>,
       linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 1/1] mm_for_maps: simplify, use ptrace_may_access()
In-Reply-To: Oleg Nesterov's message of  Tuesday, 23 June 2009 21:25:32 +0200 <20090623192532.GB27853@redhat.com>
References: <20090507083851.GA19133@elte.hu>
	<20090507085742.GB3036@sequoia.sous-sol.org>
	<20090507090459.GE19133@elte.hu>
	<20090507092009.GC3036@sequoia.sous-sol.org>
	<alpine.LRH.2.00.0905071951530.29219@tundra.namei.org>
	<20090507102015.GB8901@elte.hu>
	<alpine.LRH.2.00.0905072135580.29806@tundra.namei.org>
	<20090623141451.GA8133@redhat.com>
	<20090623174918.GA24430@infradead.org>
	<20090623192451.GA27853@redhat.com>
	<20090623192532.GB27853@redhat.com>
Emacs: it's not slow --- it's stately.
Message-Id: <20090624092547.D6B684059B@magilla.sf.frob.com>
Date: Wed, 24 Jun 2009 02:25:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Also, we do not need to take ->mmap_sem in advance. In fact I think
> mm_for_maps() should not play with ->mmap_sem at all, the caller should
> take this lock.

Agreed.  It has only one caller (though two forks of it) in
fs/proc/task_{no,}mmu.c and it looks easy to change.

> With or without this patch, without ->cred_guard_mutex held we can race
> with exec() and get the new ->mm but check old creds.

It looks safe and proper for mm_for_maps() to take that mutex around its
check.  Your patch looks good to me as it is, and taking cred_guard_mutex
can be another security fix patch on top.


Thanks,
Roland
