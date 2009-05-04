Return-Path: <linux-kernel-owner+w=401wt.eu-S1758345AbZEDRjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758345AbZEDRjn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 13:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754052AbZEDRjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 13:39:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50319 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751863AbZEDRjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 13:39:33 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Stephen Smalley <sds@tycho.nsa.gov>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Eric Paris <eparis@parisplace.org>,
       James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org
Subject: Re: ptrace: selinux_bprm_committed_creds: simplify
	__wake_up_parent() code and s/parent/real_parent/
In-Reply-To: Oleg Nesterov's message of  Sunday, 3 May 2009 22:10:27 +0200 <20090503201027.GB18889@redhat.com>
References: <20090428223025.GA11997@redhat.com>
	<1241011116.18249.193.camel@localhost.localdomain>
	<20090429140224.GA31948@redhat.com>
	<20090429140836.GB31948@redhat.com>
	<20090430224407.63B9DFC3BF@magilla.sf.frob.com>
	<20090503201027.GB18889@redhat.com>
Emacs: because you deserve a brk today.
Message-Id: <20090504173840.D08E9FC32F@magilla.sf.frob.com>
Date: Mon,  4 May 2009 10:38:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Afaics, with this patch the only user of ->parent outside of ptrace.c & co
> > > is arch/ia64/kernel/mca.c:format_mca_init_stack(). Hopefully ->parent will
> > > die soon.
> >
> > You could clean it up today with:
> > 	tracehook_finish_clone(p, 0, 0);
> 
> Yes... but we still need to initialize real_parent/group_leader. 

tracehook_finish_clone->ptrace_init_task does this.
That is the sole point of the call.

> This code is so special, perhaps it is better to just remove "p->parent =
> " later and do not add "#include tracehook". We will see.

Whatever you want there is fine by me.


Thanks,
Roland
