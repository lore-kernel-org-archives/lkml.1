Return-Path: <linux-kernel-owner+w=401wt.eu-S1753223AbXLJXhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223AbXLJXhF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 18:37:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751198AbXLJXgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 18:36:54 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35022 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342AbXLJXgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 18:36:53 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1197322068.18120.176.camel@moss-spartans.epoch.ncsc.mil>
References: <1197322068.18120.176.camel@moss-spartans.epoch.ncsc.mil> <1197307397.18120.72.camel@moss-spartans.epoch.ncsc.mil> <1197305173.18120.60.camel@moss-spartans.epoch.ncsc.mil> <20071205193818.24617.79771.stgit@warthog.procyon.org.uk> <20071205193859.24617.36392.stgit@warthog.procyon.org.uk> <25037.1197306473@redhat.com> <25572.1197320887@redhat.com> 
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: dhowells@redhat.com, Karl MacMillan <kmacmill@redhat.com>,
       viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       casey@schaufler-ca.com, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 08/28] SECURITY: Allow kernel services to override LSM settings for task actions [try #2]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Mon, 10 Dec 2007 23:36:09 +0000
Message-ID: <25965.1197329769@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Smalley <sds@tycho.nsa.gov> wrote:

> From a config file whose pathname would be provided by libselinux (ala
> the way in which dbusd imports contexts), or directly as a context
> returned by a libselinux function.

That sounds too SELinux specific.  How do I do it so that it works for any
LSM?

Is linking against libselinux is a viable option if it's not available under
all LSM models?  Is it available under all LSM models?  Perhaps Casey can
answer this one.

> > I use to do that, but someone objected...  Possibly Karl MacMillan.
> 
> Yes, but I think I disagreed then too.

So, who's right?

> It doesn't fit with how other users of security_kernel_act_as() will
> likely want to work (they will want to just set the context to a
> specified value, whether one obtained from the client or from some local
> source), nor with how type transitions normally work (exec, with the
> program type as the second type field).  I think it will just cause
> confusion and subtle breakage.

It's causing me lots of confusion as it is.  I have been / am being told by
different people to do different things just in dealing with SELinux, and
various people are raising extra requirements or restrictions beyond that.
There doesn't seem to be a consensus.

It sounds like the best option is just to have the kernel nick the userspace
daemon's security context and use that as is, and junk all the restrictions on
what the daemon can do so that the kernel isn't too restricted.

David
