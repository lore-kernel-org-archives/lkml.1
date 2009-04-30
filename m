Return-Path: <linux-kernel-owner+w=401wt.eu-S1762253AbZD3AjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762253AbZD3AjZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 20:39:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753257AbZD3AjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 20:39:15 -0400
Received: from tundra.namei.org ([65.99.196.166]:36442 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752631AbZD3AjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 20:39:14 -0400
Date: Thu, 30 Apr 2009 10:38:30 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Oleg Nesterov <oleg@redhat.com>
cc: Stephen Smalley <sds@tycho.nsa.gov>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Eric Paris <eparis@parisplace.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: ptrace: selinux_bprm_committed_creds: simplify __wake_up_parent()
 code and s/parent/real_parent/
In-Reply-To: <20090429140224.GA31948@redhat.com>
Message-ID: <alpine.LRH.2.00.0904301038150.17896@tundra.namei.org>
References: <20090428223025.GA11997@redhat.com> <1241011116.18249.193.camel@localhost.localdomain> <20090429140224.GA31948@redhat.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Apr 2009, Oleg Nesterov wrote:

> (on top of David's "[PATCH] SELinux: Don't flush inherited SIGKILL during execve()",
>  but can be applied independently).
> 
> selinux_bprm_committed_creds() should wake up ->real_parent, not ->parent.
> 
> We shouldn't worry about the tracer if current is ptraced, exec() must not
> succeed if the tracer has no rights to trace this task after cred changing.
> But we should notify ->real_parent which is, well, real parent.
> 
> Also, we don't need _irq to take tasklist, and we don't need parent's
> ->siglock to wake_up_interruptible(real_parent->signal->wait_chldexit).
> Since we hold tasklist, real_parent->signal must be stable. Otherwise
> spin_lock(siglock) is not safe too and can't help anyway.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Applied to 
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

-- 
James Morris
<jmorris@namei.org>
