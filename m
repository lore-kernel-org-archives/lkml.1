Return-Path: <linux-kernel-owner+w=401wt.eu-S1761669AbZE0X3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761669AbZE0X3L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 19:29:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755784AbZE0X25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 19:28:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34551 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850AbZE0X25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 19:28:57 -0400
Date: Thu, 28 May 2009 01:24:25 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ptrace: do_notify_parent_cldstop: fix the wrong
	->nsproxy usage
Message-ID: <20090527232425.GC10032@redhat.com>
References: <20090525185502.GA20781@redhat.com> <20090525193932.GA22261@redhat.com> <20090527010612.0264FFC36B@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527010612.0264FFC36B@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26, Roland McGrath wrote:
>
> > While this change is correct in any case (I hope), I wonder whether
> > we need another one:
> [...]
> > If the sub-thread is not traced, but ->group_leader is, perhaps it makes
> > more sense to notify the leader's tracer, not parent?
>
> I don't think so.

Agreed.

> > Not that I think this is really important. Just curious about what was
> > the intent.
>
> Here is how I would describe the intent (admittedly this logic is
> retrospective, not necessarily articulated as such when the code was
> written).  If the the triggering task is ptrace'd, this report is "for
> ptrace purposes"--even if it's the CLD_STOPPED case.  Otherwise, what's
> being reported is "the whole POSIX process is now stopped as per POSIX
> definitions".  The latter properly goes to the parent of the process,
> which is the group_leader->real_parent.

Yes. And I forgot that in this case the traced group_leader has already
reported CLD_STOPPED to tracer.

Oleg.

