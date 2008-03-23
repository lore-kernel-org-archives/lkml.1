Return-Path: <linux-kernel-owner+w=401wt.eu-S1761664AbYCWMlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761664AbYCWMlh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 08:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759559AbYCWMl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 08:41:26 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51412 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758980AbYCWMlY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 08:41:24 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <25920.1206249437@turing-police.cc.vt.edu>
References: <25920.1206249437@turing-police.cc.vt.edu> <20080229004405.4142.32147.stgit@warthog.procyon.org.uk> <20080229004332.4142.51771.stgit@warthog.procyon.org.uk> <17688.1205946728@redhat.com>
To: Valdis.Kletnieks@vt.edu
Cc: dhowells@redhat.com, akpm@linux-foundation.org, torvalds@osdl.org,
       Trond.Myklebust@netapp.com, chuck.lever@oracle.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
Subject: Re: Performance degradation measurement [was Re: [PATCH 06/37] Security: Separate task security context from task_struct [ver #34]]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Sun, 23 Mar 2008 12:40:48 +0000
Message-ID: <17671.1206276048@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:

> What's up with *that*?  The *fastest* run with it disabled is 1.118, and
> the *slowest* with it enabled is 1.119.  At that point, I have to wonder
> what we're really measuring here....

That's a good point.  I missed that, probably because I *knew* it would be
slower with SELinux enabled, and so just assumed that it was.

That's really odd. There should be no disk accesses happening (the
pagecache/buffer cache is preloaded and noatime is turned on), the CPUs are
running at top speed at all times, and there's lots of free RAM available.
Network activity should also be minimal, so I'm not sure why there's so much
variance.

I'll re-run my tests from a kernel running a single bash and nothing else, see
if I can get more consistent data.

David
