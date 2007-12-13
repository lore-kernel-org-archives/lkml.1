Return-Path: <linux-kernel-owner+w=401wt.eu-S1765467AbXLMRjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765467AbXLMRjq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 12:39:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765396AbXLMRjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 12:39:31 -0500
Received: from zombie.ncsc.mil ([144.51.88.131]:39427 "EHLO zombie.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765392AbXLMRj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 12:39:28 -0500
Subject: Re: [PATCH 08/28] SECURITY: Allow kernel services to override LSM
	settings for task actions [try #2]
From: Stephen Smalley <sds@tycho.nsa.gov>
To: David Howells <dhowells@redhat.com>
Cc: casey@schaufler-ca.com, Karl MacMillan <kmacmill@redhat.com>,
       viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
In-Reply-To: <22549.1197565271@redhat.com>
References: <1197563033.20226.110.camel@moss-spartans.epoch.ncsc.mil>
	 <1197557384.20226.21.camel@moss-spartans.epoch.ncsc.mil>
	 <1197488021.1125.138.camel@moss-spartans.epoch.ncsc.mil>
	 <1197473127.1125.50.camel@moss-spartans.epoch.ncsc.mil>
	 <81862.27432.qm@web36605.mail.mud.yahoo.com> <32168.1197484170@redhat.com>
	 <668.1197499783@redhat.com> <21666.1197560219@redhat.com>
	 <22549.1197565271@redhat.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Thu, 13 Dec 2007 12:27:57 -0500
Message-Id: <1197566877.20226.130.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-12-13 at 17:01 +0000, David Howells wrote:
> Stephen Smalley <sds@tycho.nsa.gov> wrote:
> 
> > They would correspond with the operations provided by the /dev/cachefiles
> > interface, at the granularity you want to support distinctions to be made.
> 
> Can this be made simpler by the fact that /dev/cachefiles has its own unique
> label (cachefiles_dev_t).

That lets you control who can use the interface at all, but not what
operations they can invoke on it.

> > Could just be a single 'setcontext' permission if that is all you want to
> > control distinctly, or could be a permission per operation.
> 
> There is only one operation that makes sense to have a permission: "set
> context and begin caching".
> 
> All the other operations on a file descriptor attached to /dev/cachfiles are
> necessary for there to be a managed cache at all, and given that you've
> managed to open /dev/cachefiles that's sufficient access for those, I think.

Do any of the interfaces allow a task to act on a cache other than one
it has created?  How does the task identify the desired cache?  What if
there is a conflict between multiple tasks asking for the same cache?

> > If the latter, you don't really need a label for the object, and can
> > just use the supplied context/secid as the object of the permission
> > check, ala:
> > 	rc = avc_has_perm(tsec->sid, secid, SECCLASS_CACHEFILES,
> > CACHEFILES__SETCONTEXT);
> 
> Ummm.   I was under the impression that the target SID had to be a member of
> target class.

Not necessarily.

secid is being applied as the acting context for the cachefiles kernel
module, so the above makes sense, even though there isn't really any
"object" in view here.  Abstractly, the question we are asking above is:

Can this task set the context of the cachefiles kernel module to this
value?

-- 
Stephen Smalley
National Security Agency

