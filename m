Return-Path: <linux-kernel-owner+w=401wt.eu-S1759578AbXIXPxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759578AbXIXPxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 11:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755102AbXIXPxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 11:53:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:32992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754293AbXIXPxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 11:53:09 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070924153541.GB26258@vino.hallyn.com>
References: <20070924153541.GB26258@vino.hallyn.com> <20070919161749.8334.26064.stgit@warthog.procyon.org.uk> <20070919161759.8334.11581.stgit@warthog.procyon.org.uk> <20070924140003.GA25689@vino.hallyn.com> <1190643719.487.41.camel@moss-spartans.epoch.ncsc.mil>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: dhowells@redhat.com, Stephen Smalley <sds@tycho.nsa.gov>,
       viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       casey@schaufler-ca.com, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 2/3] CRED: Split the task security data and move part of it into struct cred
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Mon, 24 Sep 2007 16:52:55 +0100
Message-ID: <11732.1190649175@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn <serge@hallyn.com> wrote:

> Ah, ok, so the daemon would use this to act under the user's
> credentials.  I was thinking the user would be using this to act
> under the daemon's or kernel's sid.

Think kernel service rather than daemon.  NFSd provides its own daemons to
override the security of, whereas cachefiles runs in the process context of
whoever called NFS.

> Between that and David's response, that this is only for the duration of
> one syscall (IIUC),

That's more or less correct.  You have to add the pagefault handler to that
list.

> My worry arose from the fact that I don't see
> security_cred_kernel_act_as() being called anywhere in this patchset...

Look in:

[PATCH 04/22] CRED: Request a credential record for a kernel service

Which was part of a patchset I sent on the 21st Sept.  get_kernel_cred() is in
turn used by:

[PATCH 13/22] CacheFiles: A cache that backs onto a mounted filesystem

David
