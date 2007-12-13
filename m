Return-Path: <linux-kernel-owner+w=401wt.eu-S1764686AbXLMRCJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764686AbXLMRCJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 12:02:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760358AbXLMRBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 12:01:53 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760404AbXLMRBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 12:01:52 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1197563033.20226.110.camel@moss-spartans.epoch.ncsc.mil>
References: <1197563033.20226.110.camel@moss-spartans.epoch.ncsc.mil> <1197557384.20226.21.camel@moss-spartans.epoch.ncsc.mil> <1197488021.1125.138.camel@moss-spartans.epoch.ncsc.mil> <1197473127.1125.50.camel@moss-spartans.epoch.ncsc.mil> <81862.27432.qm@web36605.mail.mud.yahoo.com> <32168.1197484170@redhat.com> <668.1197499783@redhat.com> <21666.1197560219@redhat.com> 
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: dhowells@redhat.com, casey@schaufler-ca.com,
       Karl MacMillan <kmacmill@redhat.com>, viro@ftp.linux.org.uk,
       hch@infradead.org, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 08/28] SECURITY: Allow kernel services to override LSM settings for task actions [try #2]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Thu, 13 Dec 2007 17:01:11 +0000
Message-ID: <22549.1197565271@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Smalley <sds@tycho.nsa.gov> wrote:

> They would correspond with the operations provided by the /dev/cachefiles
> interface, at the granularity you want to support distinctions to be made.

Can this be made simpler by the fact that /dev/cachefiles has its own unique
label (cachefiles_dev_t).

> Could just be a single 'setcontext' permission if that is all you want to
> control distinctly, or could be a permission per operation.

There is only one operation that makes sense to have a permission: "set
context and begin caching".

All the other operations on a file descriptor attached to /dev/cachfiles are
necessary for there to be a managed cache at all, and given that you've
managed to open /dev/cachefiles that's sufficient access for those, I think.

> If the latter, you don't really need a label for the object, and can
> just use the supplied context/secid as the object of the permission
> check, ala:
> 	rc = avc_has_perm(tsec->sid, secid, SECCLASS_CACHEFILES,
> CACHEFILES__SETCONTEXT);

Ummm.   I was under the impression that the target SID had to be a member of
target class.

David
