Return-Path: <linux-kernel-owner+w=401wt.eu-S1757501AbZDXTmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501AbZDXTmT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 15:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752967AbZDXTmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 15:42:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37671 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272AbZDXTmG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 15:42:06 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>, James Morris <jmorris@namei.org>,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: ptrace && cred_exec_mutex (Was: [PATCH] ptrace:
	tracehook_unsafe_exec: remove the stale comment)
In-Reply-To: Oleg Nesterov's message of  Friday, 24 April 2009 18:39:49 +0200 <20090424163949.GA12035@redhat.com>
References: <20090423212250.GA22537@redhat.com>
	<20090423232717.975ABFC3C7@magilla.sf.frob.com>
	<20090424163949.GA12035@redhat.com>
X-Zippy-Says: I can't think about that.  It doesn't go with HEDGES in the shape
    of LITTLE LULU -- or ROBOTS making BRICKS...
Message-Id: <20090424193835.A765BFC3C7@magilla.sf.frob.com>
Date: Fri, 24 Apr 2009 12:38:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> (change subject, add more CCs)
> 
> On 04/23, Roland McGrath wrote:
> >
> > > tracehook_unsafe_exec() doesn't need task_lock(), remove the old comment.
> >
> > Please make it instead say that cred_exec_mutex is held by the caller
> > through the exec.
> 
> Yes. Except it looks like ->cred_exec_mutex is never used in fact.
> 
> ptrace_attach() takes current->cred_exec_mutex ? iow, ptrace and exec
> use different locks ?

Good point!  That sure looks broken to me.  David?

Either that should be task->cred_exec_mutex, or Oleg and I
are completely confused about what cred_exec_mutex is meant for.


Thanks,
Roland
