Return-Path: <linux-kernel-owner+w=401wt.eu-S1755608AbXLLSez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608AbXLLSez (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 13:34:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752772AbXLLSer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 13:34:47 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55173 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752997AbXLLSeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 13:34:46 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <336290.70309.qm@web36603.mail.mud.yahoo.com>
References: <336290.70309.qm@web36603.mail.mud.yahoo.com>
To: casey@schaufler-ca.com
Cc: dhowells@redhat.com, Stephen Smalley <sds@tycho.nsa.gov>,
       Karl MacMillan <kmacmill@redhat.com>, viro@ftp.linux.org.uk,
       hch@infradead.org, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 08/28] SECURITY: Allow kernel services to override LSM settings for task actions [try #2]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Wed, 12 Dec 2007 18:34:26 +0000
Message-ID: <32187.1197484466@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler <casey@schaufler-ca.com> wrote:

> What sort of authorization are you thinking of? I would expect
> that to have been done by cachefileselinuxcontext (or
> cachefilesspiffylsmcontext) up in userspace. If you're going to
> rely on userspace applications for policy enforcement they need
> to be good enough to count on after all.

It can't be done in userspace, otherwise someone using the cachefilesd
interface can pass an arbitrary context up.  The security context has to be
passed across the file descriptor attached to /dev/cachefiles along with the
other configuration parameters as a text string.  This fd selects the
particular cache context that a particular instance of a running daemon is
using.

David
