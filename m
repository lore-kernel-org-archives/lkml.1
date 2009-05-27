Return-Path: <linux-kernel-owner+w=401wt.eu-S1757234AbZE0XSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234AbZE0XSP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 19:18:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756391AbZE0XSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 19:18:00 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58698 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753746AbZE0XR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 19:17:59 -0400
Date: Thu, 28 May 2009 01:12:48 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ptrace: do_notify_parent_cldstop: fix the wrong
	->nsproxy usage
Message-ID: <20090527231248.GB10032@redhat.com>
References: <20090525185502.GA20781@redhat.com> <20090526210514.C1C91FC2BD@magilla.sf.frob.com> <20090527213222.GA6770@redhat.com> <20090527222337.0507EFC36B@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527222337.0507EFC36B@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27, Roland McGrath wrote:
>
> > Actually, ptrace_signal() is fine wrt pid_ns. task_pid_vnr(current->parent)
> > returns 0 if the tracer is not seen from the tracee's namespace, this is
> > correct. So, afaics only ptrace_notify() needs the (low priority) fix.
>
> Oh, both are correct.  Sorry.  These are signals received by tracee, which
> is current, so task_pid_vnr() dtrt.

No, task_pid_vnr(current) in ptrace_notify() is not right. If the tracer
does PTRACE_GETSIGINFO it gets the wrong .si_pid.

Oleg.

