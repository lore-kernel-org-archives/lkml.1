Return-Path: <linux-kernel-owner+w=401wt.eu-S1752427AbYAOO7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427AbYAOO7i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 09:59:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750981AbYAOO73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 09:59:29 -0500
Received: from zombie.ncsc.mil ([144.51.88.131]:65256 "EHLO zombie.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841AbYAOO72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 09:59:28 -0500
Subject: Re: [PATCH 08/28] SECURITY: Allow kernel services to override LSM
	settings for task actions [try #2]
From: Stephen Smalley <sds@tycho.nsa.gov>
To: David Howells <dhowells@redhat.com>
Cc: Daniel J Walsh <dwalsh@redhat.com>, casey@schaufler-ca.com,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
In-Reply-To: <3524.1200319577@redhat.com>
References: <3466.1200319279@redhat.com>
	 <1199902278.9393.283.camel@moss-spartans.epoch.ncsc.mil>
	 <1197307397.18120.72.camel@moss-spartans.epoch.ncsc.mil>
	 <1197305173.18120.60.camel@moss-spartans.epoch.ncsc.mil>
	 <20071205193818.24617.79771.stgit@warthog.procyon.org.uk>
	 <20071205193859.24617.36392.stgit@warthog.procyon.org.uk>
	 <25037.1197306473@redhat.com> <17868.1199897484@redhat.com>
	 <3524.1200319577@redhat.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Tue, 15 Jan 2008 09:58:48 -0500
Message-Id: <1200409128.9669.46.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-01-14 at 14:06 +0000, David Howells wrote:
> David Howells <dhowells@redhat.com> wrote:
> 
> > Okay...  It looks like I want four security operations/hooks for cachefiles:
> 
> FYI, I added the following vectors:
> 
> 	# kernel services that need to override task security
> 	class kernel_service
> 	{
> 		use_as_override
> 		create_files_as
> 	}
> 
> The first allows:
> 
> 	avc_has_perm(daemon_tsec->sid, nominated_sid,
> 		     SECCLASS_KERNEL_SERVICE,
> 		     KERNEL_SERVICE__USE_AS_OVERRIDE,
> 		     NULL);
> 
> And the second something like:
> 
> 	avc_has_perm(tsec->sid, inode->sid,
> 		     SECCLASS_KERNEL_SERVICE,
> 		     KERNEL_SERVICE__CREATE_FILES_AS,
> 		     NULL);
> 
> Rather than specifically dedicating them to the cache, I made them general.

Make sure that you or Dan submits a policy patch to register these
classes and permissions in the policy when the kernel patch is queued
for merge.

-- 
Stephen Smalley
National Security Agency

