Return-Path: <linux-kernel-owner+w=401wt.eu-S932578AbXIOAvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932578AbXIOAvK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 20:51:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752961AbXIOAu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 20:50:56 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:40219 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647AbXIOAuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 20:50:55 -0400
Subject: [PATCH - Ketchup] update for new RT patch location
From: Steven Rostedt <rostedt@goodmis.org>
To: Matt Mackall <mpm@selenic.com>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Fri, 14 Sep 2007 20:49:53 -0400
Message-Id: <1189817393.24770.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

With the move of the RT patch to kernel.org, here's a patch to ketchup
to accommodate the change (/me puts on his snake suit).

I also updated it to try a non zipped patch if the zipped versions are
not there. This is because the main patches are zipped, but the archived
"older" versions are not zipped, but will probably be in the future.

Signed-off-by: Steven Rostedt

Index: x/ketchup
===================================================================
--- x.orig/ketchup	2007-09-14 20:01:06.000000000 -0400
+++ x/ketchup	2007-09-14 20:37:18.000000000 -0400
@@ -231,6 +231,12 @@ def latest_ck(url, pat):
     l.sort(compare_ver)
     return l[-1]
 
+def latest_rt(url, pat):
+    url = kernel_url + '/projects/rt/'
+    url += last(url)
+    part = last(url)
+    return part[:-1]
+
 def latest_dir(url, pat):
     """Find the latest link matching pat at url after sorting"""
     p = []
@@ -361,6 +367,11 @@ def trydownload(urls, f, sign):
             if download(url2, f2):
                 if not sign or verify(url2, f2, sign):
                     return f2
+	    f2 = f[:-4]
+	    url2 = url[:-4]
+	    if download(url2, f2):
+                if not sign or verify(url2, f2, sign):
+                    return f2
     return None
 
 def get_patch(ver):
@@ -592,11 +603,11 @@ version_info = {
                  kernel_url + "/people/mbligh/%(prebase)s/patch-%(full)s.bz2",
                  r'patch-(2.6.*?).bz2',
                  1, "Martin Bligh's random collection 'o crap"),
-    '2.6-rt': (latest_dir,
-               ["http://people.redhat.com/mingo/" +
-                "realtime-preempt/patch-%(full)s",
-                "http://people.redhat.com/mingo/" +
-                "realtime-preempt/older/patch-%(full)s"],
+    '2.6-rt': (latest_rt,
+               [kernel_url + "/projects/rt/" +
+	        "patch-%(full)s.bz2",
+	        kernel_url + "/projects/rt/older/" +
+	        "patch-%(full)s.bz2"],
                r'patch-(2.6.*?)',
                0, "Ingo Molnar's realtime-preempt kernel"),
     '2.6-ck': (latest_ck,


