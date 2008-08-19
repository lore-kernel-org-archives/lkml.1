Return-Path: <linux-kernel-owner+w=401wt.eu-S1757357AbYHSXac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357AbYHSXac (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 19:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753646AbYHSXaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 19:30:22 -0400
Received: from tundra.namei.org ([65.99.196.166]:45817 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752785AbYHSXaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 19:30:21 -0400
Date: Wed, 20 Aug 2008 09:29:50 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: a.beregalov@gmail.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] CRED: Take cred_exec_mutex in compat_do_execve() and
 fix error handling in do_execve()
In-Reply-To: <20080819151829.24589.30461.stgit@warthog.procyon.org.uk>
Message-ID: <alpine.LRH.1.10.0808200910020.317@tundra.namei.org>
References: <20080819151829.24589.30461.stgit@warthog.procyon.org.uk>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Aug 2008, David Howells wrote:

> Take cred_exec_mutex in compat_do_execve().  This reflects what do_execve()
> does.  The mutex protects credentials calculation against PTRACE_ATTACH needing
> to alter it mid-exec.
> 
> Also fix the error handling in do_execve().  The mutex needs to be unlocked if
> an error occurs after it is taken, but before the install_exec_creds()
> released it.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next-creds

Hopefully this will be in the next linux-next tree for testing.

Alexander, please let us know if it fixes the problem you saw.


- James
-- 
James Morris
<jmorris@namei.org>
