Return-Path: <linux-kernel-owner+w=401wt.eu-S1753997AbZGDISU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbZGDISU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 04:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753280AbZGDISJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 04:18:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39172 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121AbZGDISH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 04:18:07 -0400
Date: Sat, 4 Jul 2009 10:14:40 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org,
       James Morris <jmorris@namei.org>, David Howells <dhowells@redhat.com>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] selinux_bprm_committed_creds: use __wake_up_parent()
Message-ID: <20090704081440.GA3558@redhat.com>
References: <200906301951.n5UJpUSY013305@imap1.linux-foundation.org> <11314.1246585948@turing-police.cc.vt.edu> <20090702192047.10b81ada.akpm@linux-foundation.org> <20090703081821.GA4051@redhat.com> <20090703092311.GA3712@redhat.com> <20090703091100.a9667969.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090703091100.a9667969.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03, Andrew Morton wrote:
>
> On Fri, 3 Jul 2009 11:23:11 +0200 Oleg Nesterov <oleg@redhat.com> wrote:
>
> > (depends on ptrace-__ptrace_detach-do-__wake_up_parent-if-we-reap-the-tracee.patch
> >  which exports __wake_up_parent)
> >
> > Spotted by Valdis.Kletnieks@vt.edu.
> >
> > selinux_bprm_committed_creds() should not play with ->wait_chldexit, now
> > that __wake_up_parent() is exported change the code to use this helper.
>
> That's a bit vague.  Why shouldn't it play with wait_chldexit?  What
> changed to make that wrong?

The code was correct (btw, sorry if my message looked as if it is not).

But we should not play with "internal" structures outside of signal/exit
code. So this change is imho good regardless, __wake_up_parent() should
be used to notify threads sleeping in do_wait().

However, __wake_up_parent() was not exported, that is why _committed_creds()
does wake_up by hand.

> Is this a -mm fix?  If so, which -mm patch introduced the problem?

Yes, my fault.

	do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup.patch

assumes that __wake_up_parent() should be always used.

Oleg.

