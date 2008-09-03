Return-Path: <linux-kernel-owner+w=401wt.eu-S1755247AbYICG1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247AbYICG1P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 02:27:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754073AbYICG07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 02:26:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60154 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754019AbYICG07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 02:26:59 -0400
Date: Tue, 2 Sep 2008 23:26:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for September 1 (recordmcount.pl)
Message-Id: <20080902232639.255efb4f.akpm@linux-foundation.org>
In-Reply-To: <20080901112549.9849ab39.randy.dunlap@oracle.com>
References: <20080901191946.4c35ffc9.sfr@canb.auug.org.au>
	<20080901112549.9849ab39.randy.dunlap@oracle.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Sep 2008 11:25:49 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Mon, 1 Sep 2008 19:19:46 +1000 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Changes since next-20080829:
> 
> When using patch tarballs and applying that to kernel bases,
> scripts/recordmcount.pl fails because it is not executable.
> (Yes, I know, using the git would/should fix this.)
> 
> Is there any way to make (new) scripts executable when using
> tarballs?
> 
> I'll handle it on a case-by-case basis for now.
> 

I did this:

From: Andrew Morton <akpm@linux-foundation.org>

  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CC      scripts/mod/empty.o
/bin/sh: /usr/src/25/scripts/recordmcount.pl: Permission denied

We shouldn't assume that files have their `x' bits set.  There are various
ways in which file permissions get lost, including use of patch(1).

It might not be correct to assume that perl lives in $PATH?

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/Makefile.build |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN scripts/Makefile.build~kbuild-ftrace-dont-assume-that-scripts-recordmcountpl-is-executable scripts/Makefile.build
--- a/scripts/Makefile.build~kbuild-ftrace-dont-assume-that-scripts-recordmcountpl-is-executable
+++ a/scripts/Makefile.build
@@ -199,8 +199,9 @@ cmd_modversions =							\
 endif
 
 ifdef CONFIG_FTRACE_MCOUNT_RECORD
-cmd_record_mcount = $(srctree)/scripts/recordmcount.pl "$(ARCH)" \
-	"$(OBJDUMP)" "$(OBJCOPY)" "$(CC)" "$(LD)" "$(NM)" "$(RM)" "$(MV)" "$(@)";
+cmd_record_mcount = perl $(srctree)/scripts/recordmcount.pl \
+	"$(ARCH)" "$(OBJDUMP)" "$(OBJCOPY)" "$(CC)" "$(LD)" "$(NM)" "$(RM)" \
+	"$(MV)" "$(@)";
 endif
 
 define rule_cc_o_c
_


but I haven't been able to interest anyone in the patch yet.

