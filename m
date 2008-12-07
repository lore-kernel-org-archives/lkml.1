Return-Path: <linux-kernel-owner+w=401wt.eu-S1756677AbYLGSdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677AbYLGSdc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 13:33:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754628AbYLGSbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 13:31:07 -0500
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:55713 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558AbYLGSbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 13:31:05 -0500
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 07/13] checkpatch: fix continuation detection when handling spacing on operators
Date: Sun,  7 Dec 2008 18:30:44 +0000
Message-Id: <1228674650-24392-8-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.4.911.gc990
In-Reply-To: <1228674650-24392-1-git-send-email-apw@shadowen.org>
References: <1228674650-24392-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Whitcroft <apw@canonical.com>

We are miss categorising a continuation fragment following an operator
which may lead to us thinking that there is a space after it when there
is not.  Fix this up.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index d80b55a..67b0c9f 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1793,7 +1793,7 @@ sub process {
 					$c = 'C' if ($elements[$n + 2] =~ /^$;/);
 					$c = 'B' if ($elements[$n + 2] =~ /^(\)|\]|;)/);
 					$c = 'O' if ($elements[$n + 2] eq '');
-					$c = 'E' if ($elements[$n + 2] =~ /\s*\\$/);
+					$c = 'E' if ($elements[$n + 2] =~ /^\s*\\$/);
 				} else {
 					$c = 'E';
 				}
-- 
1.6.0.4.911.gc990

