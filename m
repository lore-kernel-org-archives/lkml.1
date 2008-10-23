Return-Path: <linux-kernel-owner+w=401wt.eu-S1755574AbYJWL1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574AbYJWL1r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 07:27:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbYJWL1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 07:27:38 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:62356 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331AbYJWL1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 07:27:38 -0400
To: apw@shadowen.org
Cc: rdunlap@xenotime.net, jschopp@austin.ibm.com, linux-kernel@vger.kernel.org
Subject: [checkpatch.pl] two bugs
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200810210057.m9L0vQ7i012829@www262.sakura.ne.jp>
	<20081022075617.GA22344@brain>
	<20081022083141.GB22344@brain>
	<200810222021.EEH69777.MOFOLSVtQJHFOF@I-love.SAKURA.ne.jp>
In-Reply-To: <200810222021.EEH69777.MOFOLSVtQJHFOF@I-love.SAKURA.ne.jp>
Message-Id: <200810232027.FDJ17114.tLQOOHVMFOJFSF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Thu, 23 Oct 2008 20:27:34 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I think these are bugs.

Regards.
-----

Bug 1:
  assignment in 'if' is not warned if '\n' is inserted before the assignment.

# cat /tmp/test1.c
void foo(void)
{
	int i = 0;
	if (0 ||
	    (i = 0) != 0)
		return;
}
# /usr/src/vanilla/linux-2.6.27.3/scripts/checkpatch.pl --file /tmp/test1.c
total: 0 errors, 0 warnings, 7 lines checked

/tmp/test1.c has no obvious style problems and is ready for submission.
# ./scripts/checkpatch.pl-testing --strict --file /tmp/test1.c
total: 0 errors, 0 warnings, 0 checks, 7 lines checked

/tmp/test1.c has no obvious style problems and is ready for submission.



Bug 2:
  'while' placed after 'if { }' block is not handled properly.

# cat /tmp/test2.c
int i;
void foo(void)
{
	if (!i) {
		i++;
		return;
	}
	while (i);
}
# /usr/src/vanilla/linux-2.6.27.3/scripts/checkpatch.pl --file /tmp/test2.c
ERROR: trailing statements should be on next line
#8: FILE: tmp/test2.c:8:
+       while (i);

ERROR: while should follow close brace '}'
#8: FILE: tmp/test2.c:8:
+       }
+       while (i);

total: 2 errors, 0 warnings, 9 lines checked

/tmp/test2.c has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.
# ./scripts/checkpatch.pl-testing --strict --file /tmp/test2.c
ERROR: trailing statements should be on next line
#8: FILE: tmp/test2.c:8:
+       while (i);
+       while (i);
ERROR: while should follow close brace '}'
#8: FILE: tmp/test2.c:8:
+       }
+       while (i);

total: 2 errors, 0 warnings, 0 checks, 9 lines checked

/tmp/test2.c has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.
