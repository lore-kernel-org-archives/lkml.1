Return-Path: <linux-kernel-owner+w=401wt.eu-S1754532AbYAANeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532AbYAANeW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 08:34:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753904AbYAANeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 08:34:12 -0500
Received: from po-out-1718.google.com ([72.14.252.158]:54098 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828AbYAANeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 08:34:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=YLdNnTMVugaxcB3LU3gy0DYX7fBz5A4I2lBwmjBXQBewh0HsPteFy5VW824F14y5tUQVvlJ8kUYv03V7X2gd2iuRzAzoIaRi/D4kA+dWtOb26t2VRnD97tXDt4LEvBD20H5jGnM5jMAs3EiovaX56j0qlZGsO3d6ozEH+Jpsei8=
Date: Tue, 1 Jan 2008 21:34:21 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, Mikael Starvik <starvik@axis.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, dev-etrax@axis.com
Subject: (Try #2) [Patch 4/8] CRIS: Remove 'TOPDIR' from Makefiles
Message-ID: <20080101133421.GD2499@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20080101071311.GA2496@hacking> <20080101072922.GE2496@hacking> <20080101102010.GD28913@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080101102010.GD28913@uranus.ravnborg.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> -CC = gcc-cris -mlinux -march=v32 -I $(TOPDIR)/include
>> +CC = gcc-cris -mlinux -march=v32 -I $(objtree)/include
>
>As in the mips case the right fix is to use:
>> +CC = gcc-cris -mlinux -march=v32 -Iinclude -Iinclude2
>
>In this way we pick up the includes also in the O=..
>case.

Thanks, Sam!

Resend it. ;)

--------->

This patch removes TOPDIR from Cris Makefiles.

Cc: Mikael Starvik <starvik@axis.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---

diff --git a/arch/cris/arch-v32/boot/compressed/Makefile b/arch/cris/arch-v32/boot/compressed/Makefile
index 9f77eda..27e9f15 100644
--- a/arch/cris/arch-v32/boot/compressed/Makefile
+++ b/arch/cris/arch-v32/boot/compressed/Makefile
@@ -7,7 +7,7 @@
 target = $(target_compressed_dir)
 src    = $(src_compressed_dir)
 
-CC = gcc-cris -mlinux -march=v32 -I $(TOPDIR)/include
+CC = gcc-cris -mlinux -march=v32 -Iinclude -Iinclude2
 CFLAGS = -O2
 LD = gcc-cris -mlinux -march=v32 -nostdlib
 OBJCOPY = objcopy-cris
