Return-Path: <linux-kernel-owner+w=401wt.eu-S1756986AbZECURi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756986AbZECURi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 16:17:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756184AbZECUR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 16:17:27 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38019 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752177AbZECUR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 16:17:26 -0400
Date: Sun, 3 May 2009 22:10:27 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Eric Paris <eparis@parisplace.org>,
       James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org
Subject: Re: ptrace: selinux_bprm_committed_creds: simplify
	__wake_up_parent() code and s/parent/real_parent/
Message-ID: <20090503201027.GB18889@redhat.com>
References: <20090428223025.GA11997@redhat.com> <1241011116.18249.193.camel@localhost.localdomain> <20090429140224.GA31948@redhat.com> <20090429140836.GB31948@redhat.com> <20090430224407.63B9DFC3BF@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090430224407.63B9DFC3BF@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30, Roland McGrath wrote:
>
> > Afaics, with this patch the only user of ->parent outside of ptrace.c & co
> > is arch/ia64/kernel/mca.c:format_mca_init_stack(). Hopefully ->parent will
> > die soon.
>
> You could clean it up today with:
> 	tracehook_finish_clone(p, 0, 0);

Yes... but we still need to initialize real_parent/group_leader. This code
is so special, perhaps it is better to just remove "p->parent = " later and
do not add "#include tracehook". We will see.

Oleg.

