Return-Path: <linux-kernel-owner+w=401wt.eu-S1758566AbZDPRwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758566AbZDPRwc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 13:52:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756778AbZDPRwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 13:52:22 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:35445 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756606AbZDPRwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 13:52:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=OQk4N1dxA1rnf3C3DXdCpSgyZlZPwr3teVxfz+JKRY05/h37iDauI2mxpD3SWL+osE
         Pipn2pYJsRBI8+ldlUKs71OFRuzTZ9bWww02hKPzKLBTAPv7FqO2kG+Q9MrGGUtJ8PeJ
         cSM7LCglo52wvN0HOcghTUbF06B+rnOwfMSZY=
MIME-Version: 1.0
Date: Thu, 16 Apr 2009 23:22:21 +0530
Message-ID: <a85e78f50904161052s71dabbe9p17ac68b35331eae@mail.gmail.com>
Subject: [PATCH] removes unused variable from kernel/sysctl.h
From: Sukanto Ghosh <sukanto.cse.iitb@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the unused variable 'val' from the
__do_proc_dointvec() function
in kernel/sysctl.h. The integer has been declared and used as 'val =
-val' and there is
no reference to it anywhere.
Although I am this doesn't affects the kernel binary because gcc
removes it, still it
might be confusing for people reading the code.


Signed-off-by: Sukanto Ghosh <sukanto.cse.iitb@gmail.com>

----

--- linux-2.6.29.1/kernel/sysctl.c.orig 2009-04-16 19:57:21.000000000 +0530
+++ linux-2.6.29.1/kernel/sysctl.c      2009-04-16 19:58:26.000000000 +0530
@@ -2198,7 +2198,7 @@ static int __do_proc_dointvec(void *tbl_
                  void *data)
 {
 #define TMPBUFLEN 21
-       int *i, vleft, first=1, neg, val;
+       int *i, vleft, first=1, neg;
        unsigned long lval;
        size_t left, len;

@@ -2251,8 +2251,6 @@ static int __do_proc_dointvec(void *tbl_
                        len = p-buf;
                        if ((len < left) && *p && !isspace(*p))
                                break;
-                       if (neg)
-                               val = -val;
                        s += len;
                        left -= len;
