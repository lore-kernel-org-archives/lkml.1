Return-Path: <linux-kernel-owner+w=401wt.eu-S1760606AbZFXRw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760606AbZFXRw1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 13:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753395AbZFXRwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 13:52:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48506 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546AbZFXRwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 13:52:20 -0400
Date: Wed, 24 Jun 2009 16:37:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, James Morris <jmorris@namei.org>,
       Ingo Molnar <mingo@elte.hu>, Chris Wright <chrisw@sous-sol.org>,
       linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 1/1] mm_for_maps: simplify, use ptrace_may_access()
Message-ID: <20090624143706.GC18662@redhat.com>
References: <20090507090459.GE19133@elte.hu> <20090507092009.GC3036@sequoia.sous-sol.org> <alpine.LRH.2.00.0905071951530.29219@tundra.namei.org> <20090507102015.GB8901@elte.hu> <alpine.LRH.2.00.0905072135580.29806@tundra.namei.org> <20090623141451.GA8133@redhat.com> <20090623174918.GA24430@infradead.org> <20090623192451.GA27853@redhat.com> <20090623192532.GB27853@redhat.com> <20090624092547.D6B684059B@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090624092547.D6B684059B@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24, Roland McGrath wrote:
>
> > Also, we do not need to take ->mmap_sem in advance. In fact I think
> > mm_for_maps() should not play with ->mmap_sem at all, the caller should
> > take this lock.
>
> Agreed.  It has only one caller (though two forks of it) in
> fs/proc/task_{no,}mmu.c and it looks easy to change.
>
> > With or without this patch, without ->cred_guard_mutex held we can race
> > with exec() and get the new ->mm but check old creds.
>
> It looks safe and proper for mm_for_maps() to take that mutex around its
> check.  Your patch looks good to me as it is, and taking cred_guard_mutex
> can be another security fix patch on top.

Agreed, will do.

Oleg.

