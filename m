Return-Path: <linux-kernel-owner+w=401wt.eu-S1752806AbYAPQzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806AbYAPQzv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 11:55:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbYAPQzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 11:55:41 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37960 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949AbYAPQzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 11:55:40 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <AEF7FD5A-F622-46A1-8034-2FAF10CEBA46@mac.com>
References: <AEF7FD5A-F622-46A1-8034-2FAF10CEBA46@mac.com> <20080115234652.22183.24850.stgit@warthog.procyon.org.uk>
To: Kyle Moffett <mrlinuxman@mac.com>
Cc: dhowells@redhat.com, sds@tycho.nsa.gov, casey@schaufler-ca.com,
       Trond.Myklebust@netapp.com, npiggin@suse.de,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 00/26] Permit filesystem local caching
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Wed, 16 Jan 2008 16:55:31 +0000
Message-ID: <30682.1200502531@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle Moffett <mrlinuxman@mac.com> wrote:

> One vaguely related question:  Is there presently any way to adjust the
> per-user max-key-data limit?

There's no reason there can't be.  It just needs a policy deciding.  Do we
have:

 (1) One control for all.

 (2) One control for all non-root users; no quotas on root.

 (3) One control for root, one control for all non-root users.

 (3) Separate controls for all users.

Should this be a ulimit?  Should a non-root user be able to adjust their own
quotas within limits set by root?

How should the quota be accessed?  The obvious way is to have /proc or /sys
controls.

Non-root quotas tend to be transitory.  When the user_struct pinning them goes
out of scope, they tend to disappear.  How do we recover the settings, if at
all?

David
