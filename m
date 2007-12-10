Return-Path: <linux-kernel-owner+w=401wt.eu-S1758061AbXLJVJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758061AbXLJVJK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 16:09:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754199AbXLJVI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 16:08:56 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46478 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753781AbXLJVIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 16:08:55 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1197307397.18120.72.camel@moss-spartans.epoch.ncsc.mil>
References: <1197307397.18120.72.camel@moss-spartans.epoch.ncsc.mil> <1197305173.18120.60.camel@moss-spartans.epoch.ncsc.mil> <20071205193818.24617.79771.stgit@warthog.procyon.org.uk> <20071205193859.24617.36392.stgit@warthog.procyon.org.uk> <25037.1197306473@redhat.com>
To: Stephen Smalley <sds@tycho.nsa.gov>, Karl MacMillan <kmacmill@redhat.com>
Cc: dhowells@redhat.com, viro@ftp.linux.org.uk, hch@infradead.org,
       Trond.Myklebust@netapp.com, casey@schaufler-ca.com,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 08/28] SECURITY: Allow kernel services to override LSM settings for task actions [try #2]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Mon, 10 Dec 2007 21:08:07 +0000
Message-ID: <25572.1197320887@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Smalley <sds@tycho.nsa.gov> wrote:

> Otherwise, only other issue I have with this interface is it won't
> generalize to dealing with nfsd, where we want to set the acting context
> to a context we obtain from or determine based upon the client.

Are you speaking of security_kernel_act_as() and security_create_files_as()
specifically?  Or the task_struct::act_as override pointer in general?

I don't really know how nfsd wants to obtain and set its LSM context, so it's
a bit difficult for me to make something that works for nfsd as well as
cachefiles.

> Why can't cachefilesd just push a context into the kernel and pass that
> into the hook as the acting context,

How does cachefilesd come up with such a context?  Grab it from
/etc/cachefilesd.conf?

I use to do that, but someone objected...  Possibly Karl MacMillan.

> and then nfsd can do likewise using the context provided by the client or
> obtained locally from exports for ordinary clients?  Avoids the transition
> SID computation altogether within the kernel and makes this more generic.

I seem to remember that I was told that it should be done this way, possibly
by Karl MacMillan, but I don't remember exactly.

Now it's configured by cachefilesd.te:

	type_transition cachefilesd_t kernel_t : process cachefiles_kernel_t;

David
