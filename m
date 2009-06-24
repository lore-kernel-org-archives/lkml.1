Return-Path: <linux-kernel-owner+w=401wt.eu-S1759927AbZFXOXJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759927AbZFXOXJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 10:23:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752795AbZFXOXD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 10:23:03 -0400
Received: from tundra.namei.org ([65.99.196.166]:53157 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752456AbZFXOXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 10:23:01 -0400
Date: Thu, 25 Jun 2009 00:21:57 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 1/1] mm_for_maps: simplify, use ptrace_may_access()
In-Reply-To: <20090624030627.GA6459@us.ibm.com>
Message-ID: <alpine.LRH.2.00.0906250021460.20443@tundra.namei.org>
References: <20090507085742.GB3036@sequoia.sous-sol.org> <20090507090459.GE19133@elte.hu> <20090507092009.GC3036@sequoia.sous-sol.org> <alpine.LRH.2.00.0905071951530.29219@tundra.namei.org> <20090507102015.GB8901@elte.hu> <alpine.LRH.2.00.0905072135580.29806@tundra.namei.org>
 <20090623141451.GA8133@redhat.com> <20090623174918.GA24430@infradead.org> <20090623192451.GA27853@redhat.com> <20090623192532.GB27853@redhat.com> <20090624030627.GA6459@us.ibm.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009, Serge E. Hallyn wrote:

> Quoting Oleg Nesterov (oleg@redhat.com):
> > It would be nice to kill __ptrace_may_access(). It requires task_lock(),
> > but this lock is only needed to read mm->flags in the middle.
> > 
> > Convert mm_for_maps() to use ptrace_may_access(), this also simplifies
> > the code a little bit.
> > 
> > Also, we do not need to take ->mmap_sem in advance. In fact I think
> > mm_for_maps() should not play with ->mmap_sem at all, the caller should
> > take this lock.
> 
> Yeah I think that makes sense.
> 
> > With or without this patch, without ->cred_guard_mutex held we can race
> > with exec() and get the new ->mm but check old creds.
> > 
> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> 
> reasoning on the security check also makes sense.
> 
> Reviewed-by: Serge Hallyn <serue@us.ibm.com>


Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next


-- 
James Morris
<jmorris@namei.org>
