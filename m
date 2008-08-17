Return-Path: <linux-kernel-owner+w=401wt.eu-S1755231AbYHQBSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231AbYHQBSX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 21:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbYHQBSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 21:18:16 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:56541 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbYHQBSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 21:18:15 -0400
Date: Sat, 16 Aug 2008 20:17:11 -0500
From: David Fries <david@fries.net>
To: David Howells <dhowells@redhat.com>
Cc: sfr@canb.auug.org.au, jmorris@namei.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH] Fix setting of PF_SUPERPRIV by __capable() [BROKEN]
Message-ID: <20080817011711.GA17528@spacedout.fries.net>
References: <20080814103728.13651.1528.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080814103728.13651.1528.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Sat, 16 Aug 2008 20:17:17 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first two submissions this patch had parent for the argument, the third
one has child then parent and fails to compile with SECURITY disabled.
Please apply the following patch.

> +static inline int security_ptrace_traceme(struct task_struct *child)
>  {
> -	return cap_ptrace(parent, child, mode);
> +	return cap_ptrace_traceme(parent);
>  }

commit d8b5323c7c218d29da29eba35921d3b77fe403de
Author: David Fries <david@fries.net>
Date:   Sat Aug 16 19:55:11 2008 -0500

    security_ptrace_traceme error: 'parent' undeclared
    
    s/child/parent/
    
    Signed-off-by: David Fries <david@fries.net>

diff --git a/include/linux/security.h b/include/linux/security.h
index 2ee5ecf..80c4d00 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1755,7 +1755,7 @@ static inline int security_ptrace_may_access(struct task_struct *child,
 	return cap_ptrace_may_access(child, mode);
 }
 
-static inline int security_ptrace_traceme(struct task_struct *child)
+static inline int security_ptrace_traceme(struct task_struct *parent)
 {
 	return cap_ptrace_traceme(parent);
 }
