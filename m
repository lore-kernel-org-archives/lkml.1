Return-Path: <linux-kernel-owner+w=401wt.eu-S1758695AbZDWHnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758695AbZDWHnd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:43:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756389AbZDWHax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:30:53 -0400
Received: from sous-sol.org ([216.99.217.87]:50518 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756256AbZDWHaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:30:52 -0400
Message-Id: <20090423072645.830562637@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:21:15 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "Serge E. Hallyn" <serue@us.ibm.com>,
       David Howells <dhowells@redhat.com>, James Morris <jmorris@namei.org>
Subject: [patch 055/100] cap_prctl: dont set error to 0 at no_change
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=cap_prctl-don-t-set-error-to-0-at-no_change.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Serge E. Hallyn <serue@us.ibm.com>

upstream commit: 5bf37ec3e0f5eb79f23e024a7fbc8f3557c087f0

One-liner: capsh --print is broken without this patch.

In certain cases, cap_prctl returns error > 0 for success.  However,
the 'no_change' label was always setting error to 0.  As a result,
for example, 'prctl(CAP_BSET_READ, N)' would always return 0.
It should return 1 if a process has N in its bounding set (as
by default it does).

I'm keeping the no_change label even though it's now functionally
the same as 'error'.

Signed-off-by: Serge Hallyn <serue@us.ibm.com>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 security/commoncap.c |    1 -
 1 file changed, 1 deletion(-)

--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -916,7 +916,6 @@ changed:
 	return commit_creds(new);
 
 no_change:
-	error = 0;
 error:
 	abort_creds(new);
 	return error;

