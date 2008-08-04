Return-Path: <linux-kernel-owner+w=401wt.eu-S1757996AbYHDBvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757996AbYHDBvu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 21:51:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752817AbYHDBvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 21:51:42 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:14039 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030AbYHDBvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 21:51:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=iVFql+rLQeXcMaR7hDmMRSrKrtm8baojGe77B3iz51CH6tBdoXT1Ro5PE1ahh3PTxP
         rRhl8oFcM45Jy39oCkkfHiIGP2usUutDinZlGsDK8MOFAoIpUcO4KAUvW2tCNGGWP0zx
         nh8Xc6SfT2HimrVGqUXkfBHN3FEh+x2loMLEc=
Message-ID: <91b13c310808031851v2ca9923fuf543eb4fe9c92e2b@mail.gmail.com>
Date: Mon, 4 Aug 2008 09:51:40 +0800
From: "rae l" <crquan@gmail.com>
To: "lkml - Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: some problems with latest cscope-15.6, the better way to generate cscope database change
Cc: cscope-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denis ChengRq <crquan@gmail.com>

It's a problem about cscope target of kernel Makefile, and the cscope
plugin of emacs:
1. `make cscope` will generate cscope.files cscope.{in,po,}.out;
2. the cscope plugin expect a cscope.out.{in,po,};
3. the default `cscope -b` would generate cscope.{in,po,}.out;

There are three approach to solve it:
1. modify the cscope C code;
2. modify the cscope emacs plugin lisp code;
3. modify the Makefile;

I have tried to communicate with the cscope upstream, but later I
realize the third approach is most meaningful.
So here is the one line patch:

---

diff --git a/Makefile b/Makefile
index f156f40..9148c3f 100644
--- a/Makefile
+++ b/Makefile
@@ -1492,7 +1492,7 @@ quiet_cmd_cscope-file = FILELST cscope.files
       cmd_cscope-file = (echo \-k; echo \-q; $(all-sources)) > cscope.files

 quiet_cmd_cscope = MAKE    cscope.out
-      cmd_cscope = cscope -b
+      cmd_cscope = cscope -b -f cscope.out

 cscope: FORCE
 	$(call cmd,cscope-file)
