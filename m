Return-Path: <linux-kernel-owner+w=401wt.eu-S1752633AbZDHV4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633AbZDHV4l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 17:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752345AbZDHV4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 17:56:11 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:42217 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbZDHV4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 17:56:09 -0400
Date: Wed, 8 Apr 2009 16:55:58 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Andrew Morgan <morgan@kernel.org>, stable@kernel.org
Subject: [PATCH 1/1] cap_prctl: don't set error to 0 at 'no_change'
Message-ID: <20090408215558.GA15250@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 security/commoncap.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/security/commoncap.c b/security/commoncap.c
index 7cd61a5..beac025 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -916,7 +916,6 @@ changed:
 	return commit_creds(new);
 
 no_change:
-	error = 0;
 error:
 	abort_creds(new);
 	return error;
-- 
1.5.6.3

