Return-Path: <linux-kernel-owner+w=401wt.eu-S1757819AbYAQWzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757819AbYAQWzE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 17:55:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762037AbYAQWto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 17:49:44 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38427 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762028AbYAQWtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 17:49:42 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080117204804.GC6416@fieldses.org>
References: <20080117204804.GC6416@fieldses.org> <20080115234724.22183.9603.stgit@warthog.procyon.org.uk> <20080115234652.22183.24850.stgit@warthog.procyon.org.uk> <20849.1200590240@redhat.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: dhowells@redhat.com, sds@tycho.nsa.gov, casey@schaufler-ca.com,
       Trond.Myklebust@netapp.com, neilb@suse.de, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org,
       nfs@lists.sourceforge.net
Subject: Re: [PATCH 06b/26] Security: Make NFSD work with detached security
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Thu, 17 Jan 2008 22:48:47 +0000
Message-ID: <28942.1200610127@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

J. Bruce Fields <bfields@fieldses.org> wrote:

> Just curious--why?  Are get_kernel_security(), etc., particularly
> expensive?

It involves a kmalloc().  That means an extra possibility for an error.  Plus
it may allow you to cache the result of checking whether, say, SELinux
security labels are allowed to be set when passed over NFS (if such is
possible).

David
