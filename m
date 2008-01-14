Return-Path: <linux-kernel-owner+w=401wt.eu-S1756094AbYANOGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094AbYANOGw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 09:06:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755784AbYANOGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 09:06:23 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57494 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755757AbYANOGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 09:06:21 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <3466.1200319279@redhat.com>
References: <3466.1200319279@redhat.com> <1199902278.9393.283.camel@moss-spartans.epoch.ncsc.mil> <1197307397.18120.72.camel@moss-spartans.epoch.ncsc.mil> <1197305173.18120.60.camel@moss-spartans.epoch.ncsc.mil> <20071205193818.24617.79771.stgit@warthog.procyon.org.uk> <20071205193859.24617.36392.stgit@warthog.procyon.org.uk> <25037.1197306473@redhat.com> <17868.1199897484@redhat.com> 
Cc: dhowells@redhat.com, Stephen Smalley <sds@tycho.nsa.gov>,
       Daniel J Walsh <dwalsh@redhat.com>, casey@schaufler-ca.com,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 08/28] SECURITY: Allow kernel services to override LSM settings for task actions [try #2]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Mon, 14 Jan 2008 14:06:17 +0000
Message-ID: <3524.1200319577@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> Okay...  It looks like I want four security operations/hooks for cachefiles:

FYI, I added the following vectors:

	# kernel services that need to override task security
	class kernel_service
	{
		use_as_override
		create_files_as
	}

The first allows:

	avc_has_perm(daemon_tsec->sid, nominated_sid,
		     SECCLASS_KERNEL_SERVICE,
		     KERNEL_SERVICE__USE_AS_OVERRIDE,
		     NULL);

And the second something like:

	avc_has_perm(tsec->sid, inode->sid,
		     SECCLASS_KERNEL_SERVICE,
		     KERNEL_SERVICE__CREATE_FILES_AS,
		     NULL);

Rather than specifically dedicating them to the cache, I made them general.

David
