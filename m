Return-Path: <linux-kernel-owner+w=401wt.eu-S1751704AbYANOBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704AbYANOBs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 09:01:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750824AbYANOBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 09:01:40 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49020 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750695AbYANOBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 09:01:39 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1199902278.9393.283.camel@moss-spartans.epoch.ncsc.mil>
References: <1199902278.9393.283.camel@moss-spartans.epoch.ncsc.mil> <1197307397.18120.72.camel@moss-spartans.epoch.ncsc.mil> <1197305173.18120.60.camel@moss-spartans.epoch.ncsc.mil> <20071205193818.24617.79771.stgit@warthog.procyon.org.uk> <20071205193859.24617.36392.stgit@warthog.procyon.org.uk> <25037.1197306473@redhat.com> <17868.1199897484@redhat.com> 
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: dhowells@redhat.com, Daniel J Walsh <dwalsh@redhat.com>,
       casey@schaufler-ca.com, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 08/28] SECURITY: Allow kernel services to override LSM settings for task actions [try #2]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Mon, 14 Jan 2008 14:01:19 +0000
Message-ID: <3466.1200319279@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Stephen Smalley <sds@tycho.nsa.gov> wrote:

> > 	avc_has_perm(daemon_tsec->sid, nominated_sid,
> > 		     SECCLASS_CACHE, CACHE__USE_AS_OVERRIDE, NULL);
> > 
> > And I assume this doesn't care if one, the other or both of the two SIDs
> > mentioned are of SECCLASS_PROCESS rather than of SECCLASS_CACHE.
> 
> Right, the latter is reasonable.

Okay...  It looks like I want four security operations/hooks for cachefiles:

 (1) Check that a daemon can nominate a secid for use by the kernel to override
     the process subjective secid.

 (2) Set the secid mentioned in (1).

 (3) Check that the kernel may create files as a particular secid (this could
     be specified indirectly by specifying an inode, which would hide the secid
     inside the LSM).

 (4) Set the fscreate secid mentioned in (3).

Now, it's possible to condense (1) and (2) into a single op, and condense (3)
and (4) into a single op.  That, however, might make the ops unusable by nfsd,
which may well want to bypass the checks or do them elsewhere.

Any thoughts?

David
