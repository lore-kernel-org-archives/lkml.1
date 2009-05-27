Return-Path: <linux-kernel-owner+w=401wt.eu-S1759556AbZE0VhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759556AbZE0VhK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 17:37:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbZE0Vg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 17:36:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39234 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514AbZE0Vg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 17:36:59 -0400
Date: Wed, 27 May 2009 23:32:22 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ptrace: do_notify_parent_cldstop: fix the wrong
	->nsproxy usage
Message-ID: <20090527213222.GA6770@redhat.com>
References: <20090525185502.GA20781@redhat.com> <20090526210514.C1C91FC2BD@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090526210514.C1C91FC2BD@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26, Roland McGrath wrote:
>
> Acked-by: Roland McGrath <roland@redhat.com>

I didn't remove this ack to remind Andrew about this patch ;)

> ptrace_notify, ptrace_signal,

Actually, ptrace_signal() is fine wrt pid_ns. task_pid_vnr(current->parent)
returns 0 if the tracer is not seen from the tracee's namespace, this is
correct. So, afaics only ptrace_notify() needs the (low priority) fix.

Oleg.

