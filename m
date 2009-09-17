Return-Path: <linux-kernel-owner+w=401wt.eu-S1753158AbZIRB4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158AbZIRB4G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 21:56:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751825AbZIRB4C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 21:56:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64383 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392AbZIRB4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 21:56:01 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/utrace
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, "Frank Ch. Eigler" <fche@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, utrace-devel@redhat.com
Subject: Re: tracehooks changes && 2.6.32 -mm merge plans
In-Reply-To: Oleg Nesterov's message of  Thursday, 17 September 2009 22:46:56 +0200 <20090917204656.GC29346@redhat.com>
References: <20090915161535.db0a6904.akpm@linux-foundation.org>
	<20090917204656.GC29346@redhat.com>
X-Zippy-Says: A KAISER ROLL?!  What good is a Kaiser Roll without a little COLE
    SLAW on the SIDE?
Message-Id: <20090917215635.73CE89A5@magilla.sf.frob.com>
Date: Thu, 17 Sep 2009 14:56:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 09/15, Andrew Morton wrote:
> >
> > #signals-tracehook_notify_jctl-change.patch: needs changelog folding too
> > signals-tracehook_notify_jctl-change.patch
> > signals-tracehook_notify_jctl-change-do_signal_stop-do-not-call-tracehook_notify_jctl-in-task_stopped-state.patch
> > #signals-introduce-tracehook_finish_jctl-helper.patch: fold into signals-tracehook_notify_jctl-change.patch
> > signals-introduce-tracehook_finish_jctl-helper.patch
> 
> I think these make sense anyway,

Agreed.

> > utrace-core.patch
> >
> >   utrace.  What's happening with this?
> 
> (since Roland didn't reply yet)
> 
> I guess this patch should be updated.

We do have a newer version now with various fixes and clean-ups.
But the current version does not play nice with ptrace (does not
even exclude ptrace any more).  Without at least the ptrace
exclusion, using both utrace modules and ptrace might lead to a
confused kernel or BUG_ON hits.

Past feedback tells us that we need some in-tree users of the
utrace API to get merged too.  Frank was working on such a thing,
and the IBM folks may have another such thing, but I don't know
the present status of those modules.

Oleg is working feverishly on revamping ptrace using utrace.
Other past feedback has suggested this is what people want to see
to justify utrace going in.  That ptrace work is still a bit away
from being ready even for -mm submission.  We're pretty sure that
we will do some more changes in the utrace core to make that work
well, so utrace merged first would be sure to get more changes
later (probably including some API differences).


Thanks,
Roland
