Return-Path: <linux-kernel-owner+w=401wt.eu-S1762951AbZD3WpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762951AbZD3WpS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 18:45:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756022AbZD3WpC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 18:45:02 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46177 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054AbZD3WpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 18:45:00 -0400
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
In-Reply-To: Oleg Nesterov's message of  Wednesday, 29 April 2009 16:08:36 +0200 <20090429140836.GB31948@redhat.com>
References: <20090428223025.GA11997@redhat.com>
	<1241011116.18249.193.camel@localhost.localdomain>
	<20090429140224.GA31948@redhat.com>
	<20090429140836.GB31948@redhat.com>
X-Shopping-List: (1) Fallacious contraception excitements
   (2) Ancient component ants
   (3) Abstinent briefs
   (4) Ambivalent incautious toothpicks
   (5) Expandable rendezvous
Message-Id: <20090430224407.63B9DFC3BF@magilla.sf.frob.com>
Date: Thu, 30 Apr 2009 15:44:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Afaics, with this patch the only user of ->parent outside of ptrace.c & co
> is arch/ia64/kernel/mca.c:format_mca_init_stack(). Hopefully ->parent will
> die soon.

Woo!  Nice work.  That oddball ia64 case is obviously trivial, it just
wants to avoid uninitialized stuff in its task_struct for a
not-really-a-process.  With your fixes, it seems certain that ->parent
should never be examined in those tasks.  Even so, the extra initialization
doesn't hurt.  You could clean it up today with:
	tracehook_finish_clone(p, 0, 0);
at the end (in place of touching ->parent).  
That will dtrt both now and later.


Thanks,
Roland
