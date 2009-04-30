Return-Path: <linux-kernel-owner+w=401wt.eu-S1763853AbZD3WxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763853AbZD3WxU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 18:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752054AbZD3WxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 18:53:10 -0400
Received: from tundra.namei.org ([65.99.196.166]:35814 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909AbZD3WxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 18:53:09 -0400
Date: Fri, 1 May 2009 08:51:50 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Oleg Nesterov <oleg@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>, Eric Paris <eparis@parisplace.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] do_wait: do take security_task_wait() into account
In-Reply-To: <20090429160123.GA4591@redhat.com>
Message-ID: <alpine.LRH.2.00.0905010851270.28491@tundra.namei.org>
References: <20090428223025.GA11997@redhat.com> <20090428233305.GA14221@redhat.com> <20090429160123.GA4591@redhat.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Apr 2009, Oleg Nesterov wrote:

> I was never able to understand what should we actually do when
> security_task_wait() fails, but the current code doesn't look right.
> 
> If ->task_wait() returns the error, we update *notask_error correctly.
> But then we either reap the child (despite the fact this was forbidden)
> or clear *notask_error (and hide the securiy policy problems).
> 
> This patch assumes that "stolen by ptrace" doesn't matter. If selinux
> denies the child we should ignore it but make sure we report -EACCESS
> instead of -ECHLD if there are no other eligible children.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Applied to: 
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next


-- 
James Morris
<jmorris@namei.org>
