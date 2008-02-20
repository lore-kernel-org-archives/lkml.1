Return-Path: <linux-kernel-owner+w=401wt.eu-S1763565AbYBTUWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763565AbYBTUWx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 15:22:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763909AbYBTUV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 15:21:59 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47906 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933178AbYBTUV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 15:21:57 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080220195811.GD16668@sergelap.austin.ibm.com>
References: <20080220195811.GD16668@sergelap.austin.ibm.com> <20080220160557.4715.66608.stgit@warthog.procyon.org.uk>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: dhowells@redhat.com, Trond.Myklebust@netapp.com, chuck.lever@oracle.com,
       casey@schaufler-ca.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 00/37] Permit filesystem local caching
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Wed, 20 Feb 2008 20:11:21 +0000
Message-ID: <12508.1203538281@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn <serue@us.ibm.com> wrote:

> Seems *really* weird that every time you send this, patch 6 doesn't seem
> to reach me in any of my mailboxes...  (did get it from the url
> you listed)

It's the largest of the patches, so that's not entirely surprising.  Hence why
I included the URL to the tarball also.

> I'm sorry if I miss where you explicitly state this, but is it safe to
> assume, as perusing the patches suggests, that
> 
> 	1. tsk->sec never changes other than in task_alloc_security()?  

Correct.

> 	2. tsk->act_as is only ever dereferenced from (a) current->

That ought to be correct.

> 	   except (b) in do_coredump?

Actually, do_coredump() only deals with current->act_as.

> (thereby carefully avoiding locking issues)

That's the idea.

> I'd still like to see some performance numbers.  Not to object to
> these patches, just to make sure there's no need to try and optimize
> more of the dereferences away when they're not needed.

I hope that the performance impact is minimal.  The kernel should spend very
little time looking at the security data.  I'll try and get some though.

> Oh, manually copied from patch 6, I see you have in the task_security
> struct definition:
> 
> 	kernel_cap_t    cap_bset;       /* ? */
> 
> That comment can be filled in with 'capability bounding set' (for this
> task and all its future descendents).

Thanks.

David
