Return-Path: <linux-kernel-owner+w=401wt.eu-S1758097AbYHHW6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097AbYHHW6x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 18:58:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758303AbYHHW6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 18:58:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37460 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754032AbYHHW6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 18:58:41 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LRH.1.10.0808090825060.29741@tundra.namei.org>
References: <alpine.LRH.1.10.0808090825060.29741@tundra.namei.org> <20080808171624.24ae1e10.sfr@canb.auug.org.au> <20080808172527.GB4742@blackpad>
To: James Morris <jmorris@namei.org>
Cc: dhowells@redhat.com, Eduardo Habkost <ehabkost@redhat.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: next-20080808 fs/nfsctl.c build error
X-Mailer: MH-E 8.0.3+cvs; nmh 1.3; GNU Emacs 23.0.50
Date: Fri, 08 Aug 2008 23:58:26 +0100
Message-ID: <30847.1218236306@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris <jmorris@namei.org> wrote:

> In any case, it seems that linux/cred.h should include linux/sched.h to 
> provide a full definition of 'struct task_struct', so that 'current' can 
> be dereferenced (e.g. in current_cred()).

Not good.  That makes sched.h and cred.h recursively dependent.  sched.h
really needs splitting up, and the include dependencies need sorting.

However, for the moment I recommend the attached patch.

David
---
From: David Howells <dhowells@redhat.com>

CRED: Fix inclusion problems

Under certain configurations, some .c files obtain linux/sched.h and/or
linux/cred.h through other include files, but not under all configurations.

A couple of places (one in Coda, one in nfsd) need extra includes.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/coda/file.c |    1 +
 fs/nfsctl.c    |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)


diff --git a/fs/coda/file.c b/fs/coda/file.c
index 5a87699..9d0d703 100644
--- a/fs/coda/file.c
+++ b/fs/coda/file.c
@@ -16,6 +16,7 @@
 #include <linux/errno.h>
 #include <linux/smp_lock.h>
 #include <linux/string.h>
+#include <linux/cred.h>
 #include <asm/uaccess.h>
 
 #include <linux/coda.h>
diff --git a/fs/nfsctl.c b/fs/nfsctl.c
index cc4ef26..358e469 100644
--- a/fs/nfsctl.c
+++ b/fs/nfsctl.c
@@ -14,6 +14,7 @@
 #include <linux/namei.h>
 #include <linux/mount.h>
 #include <linux/syscalls.h>
+#include <linux/sched.h>
 #include <asm/uaccess.h>
 
 /*

