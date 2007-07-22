Return-Path: <linux-kernel-owner+w=401wt.eu-S1762666AbXGVStA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762666AbXGVStA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 14:49:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759661AbXGVSsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 14:48:50 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:27380 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759401AbXGVSst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 14:48:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=RZDVu7l+vtBnU+aVepWjLaky0AOopQRgb44xqnnf4wotAd83G2tvgeSejFYDy4pMbbDwp1e2JldS8YRWwCMq3WYSTlVYSts33yuML21JtPZIbfJMoYfD8PPyHXEBHfohIhXOY+nAREcG8R4XwLLGCoa0M17nL8CIT9772EKuB7A=
Message-ID: <9e4733910707221148g69d7600bk632abb7452ce9c7c@mail.gmail.com>
Date: Sun, 22 Jul 2007 14:48:49 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Git Mailing List" <git@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Git help for kernel archeology, suppress diffs caused by CVS keyword expansion
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It would really be useful if git diff had an option for suppressing
diffs caused by CVS keyword expansion. I run into this problem over
and over when trying to recover stuff out of old kernel sources that
people checked into CVS and then posted CVS diffs to fulfill their GPL
obligations. I sometimes wonder if vendors are doing this on purpose
to make it more difficult to recover the changes they made to the
code.

To prevent this in the future, I'd love to see a patch removing all
CVS keywords from the kernel sources. Quick grep of kernel shows 1,535
$Id, 197 $Log, 441 $Revision, 144 $Date. I guestimate that this would
remove about 5,000 lines form the kernel source and touch 1,700 files.
Would this be accept or do those expansions contain useful info?

Example diff caused by $Log expansion:

diff --git a/arch/cris/kernel/ptrace.c b/arch/cris/kernel/ptrace.c
index b3d10fb..32e47ca 100644
--- a/arch/cris/kernel/ptrace.c
+++ b/arch/cris/kernel/ptrace.c
@@ -8,6 +8,9 @@
  * Authors:   Bjorn Wesen
  *
  * $Log: ptrace.c,v $
+ * Revision 1.2  2003/06/26 21:08:16  vangool
+ * Commit kernel changes.
+ *
  * Revision 1.8  2001/11/12 18:26:21  pkj
  * Fixed compiler warnings.
  *

Or in this case the person edited out all of the lines in the kernel
containing $Id

diff --git a/arch/i386/boot/tools/build.c b/arch/i386/boot/tools/build.c
index 2edd0a4..792aeb1 100644
--- a/arch/i386/boot/tools/build.c
+++ b/arch/i386/boot/tools/build.c
@@ -1,5 +1,4 @@
 /*
- *  $Id: build.c,v 1.5 1997/05/19 12:29:58 mj Exp $
  *
  *  Copyright (C) 1991, 1992  Linus Torvalds
  *  Copyright (C) 1997 Martin Mares

A variation on this where the Id was updated..
- *  $Id: build.c,v 1.5 1997/05/19 12:29:58 mj Exp $
+ *  $Id: build.c,v 1.5 2002/09/29 12:29:58 mj Exp $

There are a more CVS keywords that can cause expansion, probably around twenty.
When removing these with a simple grep it can get fooled and mess up.
CVS keyword expansion adds about 60,000 lines of noise to a typical
diff.

-- 
Jon Smirl
jonsmirl@gmail.com
