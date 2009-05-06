Return-Path: <linux-kernel-owner+w=401wt.eu-S1754292AbZEFX2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292AbZEFX2l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 19:28:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752196AbZEFX2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 19:28:33 -0400
Received: from sous-sol.org ([216.99.217.87]:59244 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751733AbZEFX2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 19:28:32 -0400
Date: Wed, 6 May 2009 16:27:03 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Chris Wright <chrisw@sous-sol.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       James Morris <jmorris@namei.org>
Subject: Re: [PATCH 3/3] ptrace: do not use task_lock() for attach
Message-ID: <20090506232703.GA3036@sequoia.sous-sol.org>
References: <20090505224729.GA965@redhat.com> <20090506224650.GZ3036@sequoia.sous-sol.org> <20090506231332.GA3756@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506231332.GA3756@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov (oleg@redhat.com) wrote:
> But this can happen without this change too?
> 
> - cpu2 takes task_lock(), tracehook_tracer_task() returns NULL because
>   we are not traced yet.
> 
> - cpu1 does ptrace_attach() and succeds, because cpu2 didn't update sid
>   yet
> 
> - cpu2 continues, it doesn't check avc_has_perm() (tracer == 0) and
>   updates sid.
> 
> No?

Yes.

> Shouldn't selinux_setprocattr() take ->cred_exec_mutex, like we do in
> selinux_bprm_set_creds() path?

I was looking at the same, seems like it to me.  James?

thanks,
-chris
> 
> Oleg.
