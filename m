Return-Path: <linux-kernel-owner+w=401wt.eu-S1756459AbZEFHOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756459AbZEFHOn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 03:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752623AbZEFHOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 03:14:34 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44507 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbZEFHOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 03:14:34 -0400
Date: Wed, 6 May 2009 03:14:01 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptrace_get_task_struct: s/tasklist/rcu/, make it static
Message-ID: <20090506071400.GB3223@infradead.org>
References: <20090505232820.GA4377@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090505232820.GA4377@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 06, 2009 at 01:28:20AM +0200, Oleg Nesterov wrote:
> - Use rcu_read_lock() instead of tasklist_lock to find/get the task
>   in ptrace_get_task_struct().
> 
> - Make it static, it has no callers outside of ptrace.c.

FYI, there are a couple of other functions in ptrace.c that can be
static now that everyone uses the common sys_ptrace implementation,
e.g. ptrace_traceme and ptrace_attach.

> - The comment doesn't match the reality, this helper does not do
>   any checks. Beacuse it is really trivial and static I removed the
>   whole comment.

Yeah, when I added the helper it did those checks and it was non-static
for the various arch ptrace implementations.  Now that it's a private
helper with just two callers not doing much anymore it's not needed.

