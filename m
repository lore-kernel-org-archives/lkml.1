Return-Path: <linux-kernel-owner+w=401wt.eu-S1757935AbXKLTqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935AbXKLTqj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 14:46:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751437AbXKLTqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 14:46:32 -0500
Received: from nz-out-0506.google.com ([64.233.162.228]:60693 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbXKLTqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 14:46:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=LtRS5xIjnf77AXmcIJ23Zg002aGyLBwxkkwWALwXGSh1ElX4wEgTkqiqwLB1oBxwukPmHQwsVLAuGh7HvLbWlas799pwstWYH93MbyisBA6gev8a/YnQeht8eUtuE79/L8bYBAItNvIRaDe94B538HFODKI8B5uTyNpx+6/XVww=
Message-ID: <8bd0f97a0711121146w30b88cdcs8abf3f5b6bff2d14@mail.gmail.com>
Date: Mon, 12 Nov 2007 14:46:30 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Andy Whitcroft" <apw@shadowen.org>
Subject: checkpatch.pl and no newline handling
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

the current checkpatch.pl does not reject new files that lack a
newline, yet rejects patches that fix newlines in files ... quite the
opposite of what we actually want

$ echo -n moo > no-newline
$ diff -Nu /dev/null no-newline
--- /dev/null   2007-11-10 20:02:36.248000000 -0500
+++ no-newline  2007-11-12 14:44:19.000000000 -0500
@@ -0,0 +1 @@
+moo
\ No newline at end of file
$ (diff -Nu /dev/null no-newline; echo Signed-off-by:) |
./scripts/checkpatch.pl -
Your patch has no obvious style problems and is ready for submission.

lies!

$ echo moo > newline
$ diff -u no-newline newline
--- no-newline  2007-11-12 14:44:19.000000000 -0500
+++ newline     2007-11-12 14:44:27.000000000 -0500
@@ -1 +1 @@
-moo
\ No newline at end of file
+moo
$ (diff -u no-newline newline; echo Signed-off-by:) | ./scripts/checkpatch.pl -
ERROR: patch seems to be corrupt (line wrapped?)
#5: FILE: newline:0:
\ No newline at end of file

total: 1 errors, 0 warnings, 3 lines checked
Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.
-mike
