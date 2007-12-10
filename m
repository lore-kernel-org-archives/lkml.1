Return-Path: <linux-kernel-owner+w=401wt.eu-S1755077AbXLJRYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077AbXLJRYl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 12:24:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753172AbXLJRYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 12:24:33 -0500
Received: from zombie.ncsc.mil ([144.51.88.131]:40816 "EHLO zombie.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752631AbXLJRYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 12:24:32 -0500
Subject: Re: [PATCH 08/28] SECURITY: Allow kernel services to override LSM
	settings for task actions [try #2]
From: Stephen Smalley <sds@tycho.nsa.gov>
To: David Howells <dhowells@redhat.com>
Cc: viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       casey@schaufler-ca.com, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
In-Reply-To: <25037.1197306473@redhat.com>
References: <1197305173.18120.60.camel@moss-spartans.epoch.ncsc.mil>
	 <20071205193818.24617.79771.stgit@warthog.procyon.org.uk>
	 <20071205193859.24617.36392.stgit@warthog.procyon.org.uk>
	 <25037.1197306473@redhat.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Mon, 10 Dec 2007 12:23:17 -0500
Message-Id: <1197307397.18120.72.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-12-10 at 17:07 +0000, David Howells wrote:
> Stephen Smalley <sds@tycho.nsa.gov> wrote:
> 
> > > +	tsec->create_sid = SECINITSID_UNLABELED;
> > > +	tsec->keycreate_sid = SECINITSID_UNLABELED;
> > > +	tsec->sockcreate_sid = SECINITSID_UNLABELED;
> 
> Cleared means what?  Setting to 0?  Or is there some other constant I should
> use for that?

Yes, setting to 0.

Otherwise, only other issue I have with this interface is it won't
generalize to dealing with nfsd, where we want to set the acting context
to a context we obtain from or determine based upon the client.

Why can't cachefilesd just push a context into the kernel and pass that
into the hook as the acting context, and then nfsd can do likewise using
the context provided by the client or obtained locally from exports for
ordinary clients?  Avoids the transition SID computation altogether
within the kernel and makes this more generic.

-- 
Stephen Smalley
National Security Agency

