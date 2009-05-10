Return-Path: <linux-kernel-owner+w=401wt.eu-S1757071AbZEJWjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757071AbZEJWjy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 18:39:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756117AbZEJWjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 18:39:33 -0400
Received: from tundra.namei.org ([65.99.196.166]:56390 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756747AbZEJWjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 18:39:31 -0400
Date: Mon, 11 May 2009 08:37:40 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: roland@redhat.com, chrisw@sous-sol.org, oleg@redhat.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, eparis@redhat.com,
       sds@tycho.nsa.gov
Subject: Re: [PATCH 2/2] CRED: Guard the setprocattr security hook against
 ptrace
In-Reply-To: <20090508125527.8488.82217.stgit@warthog.procyon.org.uk>
Message-ID: <alpine.LRH.2.00.0905110837270.24749@tundra.namei.org>
References: <20090508125522.8488.13637.stgit@warthog.procyon.org.uk> <20090508125527.8488.82217.stgit@warthog.procyon.org.uk>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 May 2009, David Howells wrote:

> Guard the setprocattr security hook against ptrace by taking the target task's
> cred_guard_mutex around it.  The problem is that setprocattr() may otherwise
> note the lack of a debugger, and then perform an action on that basis whilst
> letting a debugger attach between the two points.  Holding cred_guard_mutex
> across the test and the action prevents ptrace_attach() from doing that.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Applied to 
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

-- 
James Morris
<jmorris@namei.org>
