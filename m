Return-Path: <linux-kernel-owner+w=401wt.eu-S1753917AbYAAHlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917AbYAAHlA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 02:41:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751800AbYAAHkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 02:40:53 -0500
Received: from po-out-1718.google.com ([72.14.252.154]:60352 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbYAAHkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 02:40:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=TbijHAE4/QoKCoP7aNp7twD0acUyZLO18Oxh3V4toPpR0hW6Jp7gtTJ8DU7qaaZlu1xTU81myU3yzF5tuimFDlreSAfUxIzNk91SszpFdp65ErNG2cbSiXg9Jq+6mrDTv2QiO5O14CbCDnlQmpKjEpyVKeFbkU2yB4seT8XrA0o=
Date: Tue, 1 Jan 2008 15:41:05 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Tim Shimmin <xfs-masters@oss.sgi.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kbuild@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       viro@zeniv.linux.org.uk
Subject: [Patch 7/8] FS: Remove 'TOPDIR' from Makefiles
Message-ID: <20080101074105.GH2496@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20080101071311.GA2496@hacking>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080101071311.GA2496@hacking>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


TOPDIR is obsolete, use objtree instead.
This patch removes TOPDIR from all fs/ Makefiles.

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Tim Shimmin <xfs-masters@oss.sgi.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---

diff --git a/fs/smbfs/Makefile b/fs/smbfs/Makefile
index 6673ee8..9b5e92b 100644
--- a/fs/smbfs/Makefile
+++ b/fs/smbfs/Makefile
@@ -34,5 +34,5 @@ proto:
 	@echo >> proto2.h "struct sock;"
 	@echo >> proto2.h "struct statfs;"
 	@echo >> proto2.h ""
-	cproto -E "gcc -E" -e -v -I $(TOPDIR)/include -DMAKING_PROTO -D__KERNEL__ $(SRC) >> proto2.h
+	cproto -E "gcc -E" -e -v -I $(objtree)/include -DMAKING_PROTO -D__KERNEL__ $(SRC) >> proto2.h
 	mv proto2.h proto.h
diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 49e3e7e..d1d3d49 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -1 +1 @@
-include $(TOPDIR)/fs/xfs/Makefile-linux-$(VERSION).$(PATCHLEVEL)
+include $(objtree)/fs/xfs/Makefile-linux-$(VERSION).$(PATCHLEVEL)
