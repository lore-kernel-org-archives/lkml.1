Return-Path: <linux-kernel-owner+w=401wt.eu-S1761760AbZEFUs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761760AbZEFUs1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 16:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760452AbZEFUsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 16:48:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34995 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760082AbZEFUsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 16:48:15 -0400
Date: Wed, 6 May 2009 16:47:07 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 3/3a] ptrace: add _ptrace_may_access()
Message-ID: <20090506204700.GA24160@infradead.org>
References: <20090505224729.GA965@redhat.com> <20090506080050.GF17457@elte.hu> <20090506203224.684C7FC39E@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506203224.684C7FC39E@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 06, 2009 at 01:32:24PM -0700, Roland McGrath wrote:
> > Something like the patch below allows the reuse of the locked 
> > version of __ptrace_may_access and pushes the int->bool conversion 
> > into an inline.
> 
> I think it would be cleaner and safe/simple enough to invert the public
> ptrace_may_access() to just return the int and invert the ! on all the
> callers (all one in fs/proc/task_mmu.c and all four in fs/proc/base.c).

Yeah.  And at the same time we might move it out of ptrace.c and give it
a more descriptive name given that most users aren't related to ptrace
in any way.  may_inspect_task maybe?  I'm good at naming things..

