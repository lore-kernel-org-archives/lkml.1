Return-Path: <linux-kernel-owner+w=401wt.eu-S933121AbZHDRXM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933121AbZHDRXM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 13:23:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932896AbZHDRXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 13:23:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57046 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932892AbZHDRXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 13:23:11 -0400
Date: Tue, 4 Aug 2009 19:19:05 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>, eranian@gmail.com,
       mingo@elte.hu, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       robert.richter@amd.com, paulus@samba.org, andi@firstfloor.org,
       mpjohn@us.ibm.com, cel@us.ibm.com, cjashfor@us.ibm.com,
       mucci@eecs.utk.edu, terpstra@eecs.utk.edu,
       perfmon2-devel@lists.sourceforge.net, mtk.manpages@googlemail.com,
       roland@redhat.com
Subject: Re: [PATCH 3/2 -v3] fcntl: F_[SG]ETOWN_EX
Message-ID: <20090804171905.GA9080@redhat.com>
References: <20090801012736.GA30259@redhat.com> <1249314498.7924.133.camel@twins> <20090803171619.GA17876@redhat.com> <1249321637.7924.163.camel@twins> <20090803180602.GA19719@redhat.com> <1249324619.4842.1.camel@laptop> <20090803190231.GA22313@redhat.com> <1249385966.7924.204.camel@twins> <20090804162033.GB5211@redhat.com> <1249404763.4762.26.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249404763.4762.26.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04, Peter Zijlstra wrote:
>
> On Tue, 2009-08-04 at 18:20 +0200, Oleg Nesterov wrote:
>
> > > +	rcu_read_lock();
> > > +	pid = find_vpid(owner.pid);
> > > +	ret = __f_setown(filp, pid, type, 1);
> > > +	rcu_read_unlock();
> > > +
> > > +	return ret;
> >
> > Perhaps it makes sense to return -ESRCH if owner.pid && !pid, not
> > sure.
>
> We'd need that case to unset/clear the owner, so returning -ESRCH might
> confuse users I think.

Agreed. Perhaps we should do nothing but return -ESRCH if user passes
owner->pid != 0 and it is not valid.

But this is minor and can be tweaked later. (and to clarify again, not
that I really think we should do this, just a random thought).

> How about the below delta, it changes send_sigurg_to_task() to also use
> do_send_sig_info() which looses the check_kill_permission() check, but
> your previous changes lost that same thing from SIGIO -- so I'm hoping
> that's ok.

Yes, I think this is fine!

Oleg.

