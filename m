Return-Path: <linux-kernel-owner+w=401wt.eu-S1751847AbYAOO5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbYAOO5e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 09:57:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751051AbYAOO5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 09:57:24 -0500
Received: from zombie.ncsc.mil ([144.51.88.131]:64422 "EHLO zombie.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046AbYAOO5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 09:57:23 -0500
Subject: Re: [PATCH 08/28] SECURITY: Allow kernel services to override LSM
	settings for task actions [try #2]
From: Stephen Smalley <sds@tycho.nsa.gov>
To: David Howells <dhowells@redhat.com>
Cc: Daniel J Walsh <dwalsh@redhat.com>, casey@schaufler-ca.com,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
In-Reply-To: <3466.1200319279@redhat.com>
References: <1199902278.9393.283.camel@moss-spartans.epoch.ncsc.mil>
	 <1197307397.18120.72.camel@moss-spartans.epoch.ncsc.mil>
	 <1197305173.18120.60.camel@moss-spartans.epoch.ncsc.mil>
	 <20071205193818.24617.79771.stgit@warthog.procyon.org.uk>
	 <20071205193859.24617.36392.stgit@warthog.procyon.org.uk>
	 <25037.1197306473@redhat.com> <17868.1199897484@redhat.com>
	 <3466.1200319279@redhat.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Tue, 15 Jan 2008 09:56:42 -0500
Message-Id: <1200409002.9669.43.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-01-14 at 14:01 +0000, David Howells wrote:
> Stephen Smalley <sds@tycho.nsa.gov> wrote:
> 
> > > 	avc_has_perm(daemon_tsec->sid, nominated_sid,
> > > 		     SECCLASS_CACHE, CACHE__USE_AS_OVERRIDE, NULL);
> > > 
> > > And I assume this doesn't care if one, the other or both of the two SIDs
> > > mentioned are of SECCLASS_PROCESS rather than of SECCLASS_CACHE.
> > 
> > Right, the latter is reasonable.
> 
> Okay...  It looks like I want four security operations/hooks for cachefiles:
> 
>  (1) Check that a daemon can nominate a secid for use by the kernel to override
>      the process subjective secid.
> 
>  (2) Set the secid mentioned in (1).
> 
>  (3) Check that the kernel may create files as a particular secid (this could
>      be specified indirectly by specifying an inode, which would hide the secid
>      inside the LSM).

I don't think this check is on the kernel per se but rather the ability
of the daemon to nominate a secid for use on files created later by the
kernel module.

>  (4) Set the fscreate secid mentioned in (3).
> 
> Now, it's possible to condense (1) and (2) into a single op, and condense (3)
> and (4) into a single op.  That, however, might make the ops unusable by nfsd,
> which may well want to bypass the checks or do them elsewhere.
> 
> Any thoughts?

I think it is fine to combine them.

-- 
Stephen Smalley
National Security Agency

