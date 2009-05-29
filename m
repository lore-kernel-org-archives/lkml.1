Return-Path: <linux-kernel-owner+w=401wt.eu-S1759409AbZE2M25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759409AbZE2M25 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 08:28:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758360AbZE2M2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 08:28:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55823 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757120AbZE2M2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 08:28:48 -0400
Date: Fri, 29 May 2009 14:24:11 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 11/12 v2] ptrace: mv task_struct->ptrace_message
	ptrace_ctx->message
Message-ID: <20090529122411.GC19812@redhat.com>
References: <20090528113601.GA18725@redhat.com> <20090528114100.GA18744@redhat.com> <20090528212418.2F605FC2BD@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090528212418.2F605FC2BD@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28, Roland McGrath wrote:
>
> > Perhaps it is better to optimize out "mask != 0" check in ptrace_event().
> > This special !mask case is only needed for _report_clone(), we can use
> > mask == PT_PTRACED instead.
>
> Sure, that is fine.  But note it should always have been compiled away
> before anyway, since it's inline and constant in every caller.

Ah, I missed that.

I wonder if can kill "int trace" in do_fork/copy_process. Looks like we
can...

Oleg.

