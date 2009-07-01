Return-Path: <linux-kernel-owner+w=401wt.eu-S1754116AbZGANAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbZGANAj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 09:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751678AbZGANAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 09:00:30 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:54750 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbZGANA3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 09:00:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=Jdl3leI33Awu0CwIfqAhJAWkelWljSv9XMadcSPea/zDzJj5KfwfM8xH1nUbdGBhNI
         4611oA0GiF5+ty16R2HCY9l3e5WqLNSmcBxRE2IzBmDfYw+U7GjJBJW4ktCC4rC7+6dh
         7+H9maIW8GZ6tw706W/DHXnghOg9o4LrHEwvA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: Tree for July 1 (fix CONFIG_AUDIT_WATCH=n build)
Date: Wed, 1 Jul 2009 15:06:14 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.30-next-20090617-09943-g5d77a4c; KDE/4.2.4; i686; ; )
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Eric Paris <eparis@redhat.com>
References: <20090701183903.bd203c62.sfr@canb.auug.org.au>
In-Reply-To: <20090701183903.bd203c62.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200907011506.16145.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Wednesday 01 July 2009 10:39:03 Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20090630:

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] audit: fix CONFIG_AUDIT_WATCH=n build

Fix:

kernel/auditfilter.c: In function ‘audit_data_to_entry’:
kernel/auditfilter.c:501: error: expected expression before ‘{’ token
kernel/auditfilter.c: In function ‘audit_add_rule’:
kernel/auditfilter.c:891: error: expected expression before ‘{’ token
make[1]: *** [kernel/auditfilter.o] Error 1
make: *** [kernel/auditfilter.o] Error 2

introduced by commit de85e5bc3690c3063aea790279e898adb5bac0ba
("Audit: split audit watch Kconfig").

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
BTW defines are passé (using static inlines instead for CONFIG_AUDIT=n
and CONFIG_AUDIT_WATCH=n stuff would be an even better solution)..

 kernel/audit.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: b/kernel/audit.h
===================================================================
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -117,12 +117,11 @@ extern int audit_watch_compare(struct au
 #else
 #define audit_put_watch(w) {}
 #define audit_get_watch(w) {}
-#define audit_to_watch(k, p, l, o) { -EINVAL }
-#define audit_add_watch(k, l) { -EINVAL }
+#define audit_to_watch(k, p, l, o) (-EINVAL)
+#define audit_add_watch(k, l) (-EINVAL)
 #define audit_remove_watch_rule(k) BUG()
 #define audit_watch_path(w) ""
 #define audit_watch_compare(w, i, d) 0
-
 #endif /* CONFIG_AUDIT_WATCH */
 
 #ifdef CONFIG_AUDIT_TREE
