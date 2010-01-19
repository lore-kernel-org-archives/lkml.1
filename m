Return-Path: <linux-kernel-owner+w=401wt.eu-S1755147Ab0ASS31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147Ab0ASS31 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 13:29:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751524Ab0ASS30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 13:29:26 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:43862 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab0ASS30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 13:29:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=frzinXis7Ik5S83Kl013XlSkH1g2dXOQxZz0H/qOnPJKFzxV7R9V1tAqISPR/w0yhL
         uBUHw/BsZU1mnOdJ6LjHVHo+rUESaFMr0/sepHkaJY27hOXjvXcDkJzo5LXmopIE5g00
         foCn5OdDdJC2X+kKpe+NZtS7efpnOV/1mA2B0=
MIME-Version: 1.0
Date: Tue, 19 Jan 2010 19:29:24 +0100
Message-ID: <d65b1b151001191029o66794c24t228177a8ca544e44@mail.gmail.com>
Subject: [PATCH] Use full path to dnsdomainname and domainname in 
	scripts/mkcompile_h
From: Glenn Sommer <glemsom@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With reference to: http://bugzilla.kernel.org/show_bug.cgi?id=14920
I'll post my suggestion here.

Currently scripts/mkcompile_h checks for "/bin/dnsdomainname" and
"/bin/domainname" when trying to find the DNS name.
Though, when running the executable - the full path isn't used!

IMO if we check for "/bin/dnsdomainname", we should also use
"/bin/dnsdomainname" - and not blindly trust /bin is the first directory in
$PATH  which contains a executable named "dnsdomainname"


I propose to use the full path, that we know is valid. Here's my proposed patch:


--- scripts/mkcompile_h.orig	2009-12-28 23:02:34.000000000 +0100
+++ scripts/mkcompile_h	2009-12-28 23:03:12.000000000 +0100
@@ -66,9 +66,9 @@
   echo \#define LINUX_COMPILE_HOST \"`hostname | $UTS_TRUNCATE`\"

   if [ -x /bin/dnsdomainname ]; then
-    echo \#define LINUX_COMPILE_DOMAIN \"`dnsdomainname | $UTS_TRUNCATE`\"
+    echo \#define LINUX_COMPILE_DOMAIN \"`/bin/dnsdomainname | $UTS_TRUNCATE`\"
   elif [ -x /bin/domainname ]; then
-    echo \#define LINUX_COMPILE_DOMAIN \"`domainname | $UTS_TRUNCATE`\"
+    echo \#define LINUX_COMPILE_DOMAIN \"`/bin/domainname | $UTS_TRUNCATE`\"
   else
     echo \#define LINUX_COMPILE_DOMAIN
   fi


Signed-off-by: Glenn Sommer <glemsom@gmail.com>
