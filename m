Return-Path: <linux-kernel-owner+w=401wt.eu-S1756741AbYAOVzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741AbYAOVzc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 16:55:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755125AbYAOVzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 16:55:20 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52268 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755689AbYAOVzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 16:55:18 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1200424508.9669.63.camel@moss-spartans.epoch.ncsc.mil>
References: <1200424508.9669.63.camel@moss-spartans.epoch.ncsc.mil> <286481.40953.qm@web36613.mail.mud.yahoo.com>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: dhowells@redhat.com, casey@schaufler-ca.com,
       Daniel J Walsh <dwalsh@redhat.com>, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 08/28] SECURITY: Allow kernel services to override LSM settings for task actions [try #2]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Tue, 15 Jan 2008 21:55:10 +0000
Message-ID: <6778.1200434110@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Smalley <sds@tycho.nsa.gov> wrote:

> The cache files are created by the cachefiles kernel module, not by the
> userspace daemon, and the userspace daemon doesn't need to directly
> read/write them at all

That is correct.

> (but I think it does need to be able to unlink them?).

Indeed.

> The userspace daemon merely identifies the directory where the cache should
> live as part of configuring the cache when enabling it.

That is the way it currently works, yes.
 
> Hence, it is fine to use a fixed label for the cache files (systemhigh
> in a MLS world), and to let the directory's label serve as the basis for
> it.

That is what I currently do.  SELinux rules are provided to grant the
appropriate file accesses to the override label used by the kernel module, so
that it can't go and stamp on files with the wrong label.

> Only the cachefiles kernel module directly reads and writes the files.

Correct.
