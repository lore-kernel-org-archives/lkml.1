Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759586Ab0COClP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 22:41:15 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40115 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755142Ab0COClO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 22:41:14 -0400
Date: Mon, 15 Mar 2010 13:41:10 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Eric Paris <eparis@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dave Young <hidave.darkstar@gmail.com>
Subject: linux-next: manual merge of the fsnotify tree with Linus' tree
Message-Id: <20100315134110.8982a0f2.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

Today's linux-next merge of the fsnotify tree got a conflict in
kernel/sysctl.c between commits 5ed109103d73b0bafc92e860cead56725231384d
("sysctl extern cleanup: module") and
15485a4682d1d3bfee2aa78b4b1a5d36f5746b64 ("sysctl extern cleanup: sg")
from Linus' tree and commit 00e4382acdbe8337cd00d3ed74a6150f0a647d1f
("sysctl extern cleanup: inotify") from the fsnotify tree.

Just context changes.  I fixed it up (see below) and can carry the fix
for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/sysctl.c
index 8686b0f,a7a3634..0000000
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@@ -128,6 -120,17 +129,10 @@@ static int min_percpu_pagelist_fract = 
  
  static int ngroups_max = NGROUPS_MAX;
  
 -#ifdef CONFIG_MODULES
 -extern char modprobe_path[];
 -extern int modules_disabled;
 -#endif
+ #ifdef CONFIG_INOTIFY_USER
+ #include <linux/inotify.h>
+ #endif
 -#ifdef CONFIG_CHR_DEV_SG
 -extern int sg_big_buff;
 -#endif
+ 
  #ifdef CONFIG_SPARC
  #include <asm/system.h>
  #endif
