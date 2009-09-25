Return-Path: <linux-kernel-owner+w=401wt.eu-S1751554AbZIYTBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554AbZIYTBk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 15:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750936AbZIYTBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 15:01:38 -0400
Received: from mail-px0-f194.google.com ([209.85.216.194]:49266 "EHLO
	mail-px0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbZIYTBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 15:01:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=nxULWZ6s69vWYrlP6cFPUCwbon4GfM2qAX/3NLNlIHB3UWyhme4OtM9A2zCAUo+WdY
         KRC81qxuj/AOpCGIXEe7wp4kZpETlXECh42aGqKVMl8sp8im0dzqzToZcnPnjteV4Ro3
         3sdafMLMaOs+NACxW/qNT06s6A1qbICHRD+3M=
MIME-Version: 1.0
Date: Sat, 26 Sep 2009 02:01:41 +0700
Message-ID: <f284c33d0909251201w422e9687x8cd3a784e85adf7d@mail.gmail.com>
Subject: [PATCH] generate-cmdlist.sh should be either executable or run as 
	parameter of "."
From: Mulyadi Santosa <mulyadi.santosa@gmail.com>
To: mingo@redhat.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I believe this is just a small glitch. generate-cmdlist.sh by default
should be made as executable. But since one might forgot to do it, we
could simply call it as an argument "." or "source" or even "sh -c". I
pick "."

Tested in 2.6.31

Signed-off-by: Mulyadi Santosa <mulyadi.santosa@gmail.com>

--- linux-2.6.31/tools/perf/Makefile.bak	2009-09-12 22:28:37.000000000 +0700
+++ linux-2.6.31/tools/perf/Makefile	2009-09-26 01:51:04.000000000 +0700
@@ -682,7 +682,7 @@
 common-cmds.h: util/generate-cmdlist.sh command-list.txt

 common-cmds.h: $(wildcard Documentation/perf-*.txt)
-	$(QUIET_GEN)util/generate-cmdlist.sh > $@+ && mv $@+ $@
+	$(QUIET_GEN). util/generate-cmdlist.sh > $@+ && mv $@+ $@

 $(patsubst %.sh,%,$(SCRIPT_SH)) : % : %.sh
 	$(QUIET_GEN)$(RM) $@ $@+ && \
