Return-Path: <linux-kernel-owner+w=401wt.eu-S1754034AbZFFRMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034AbZFFRMS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 13:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752758AbZFFRMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 13:12:07 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:62935 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbZFFRMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 13:12:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=qKEbbq6BPKxAwekdCg/F1vKGvcEqc7N7ECyc05NiEh/9kYG2ukb8XmFFKrtTDdSG6Q
         EXxfymOBaPxW8/gnZMTK+ggTWWXvrk1E+Bkudp6igLABWLgAF/yaeL8YWsg0EGxQBzQd
         IMqhxY0nmOxfJHZojgFsD1yyfKDvKwdVgUuTw=
Date: Sat, 6 Jun 2009 21:12:07 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH] proc: vmcore - use kzalloc in get_new_element
Message-ID: <20090606171207.GC20807@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of kmalloc+memset better use straight kzalloc

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 fs/proc/vmcore.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

Index: linux-2.6.git/fs/proc/vmcore.c
=====================================================================
--- linux-2.6.git.orig/fs/proc/vmcore.c
+++ linux-2.6.git/fs/proc/vmcore.c
@@ -166,12 +166,7 @@ static const struct file_operations proc
 
 static struct vmcore* __init get_new_element(void)
 {
-	struct vmcore *p;
-
-	p = kmalloc(sizeof(*p), GFP_KERNEL);
-	if (p)
-		memset(p, 0, sizeof(*p));
-	return p;
+	return kzalloc(sizeof(struct vmcore), GFP_KERNEL);
 }
 
 static u64 __init get_vmcore_size_elf64(char *elfptr)
