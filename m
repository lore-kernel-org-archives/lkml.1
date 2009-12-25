Return-Path: <linux-kernel-owner+w=401wt.eu-S1756564AbZLYRNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564AbZLYRNP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 12:13:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756526AbZLYRNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 12:13:14 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:37875 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756493AbZLYRNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 12:13:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ciHHjMpsu2Qw93XKXZwLkh9mQ4RgTqMkjYaBnfOKQugV+zhWhYRG9KvvfH8l4nAdeg
         ycghoe8KaI/zH+9Sh9Ozx+hDKWSzraleiCFKBVWOgRxp/jojmCEhePFW6IkuLhU+km3+
         js0AmhMtiXaOODJ0Wqv3vhiYg1eNO3s/S8lNE=
From: Sergei Trofimovich <slyich@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>, Sergei Trofimovich <slyfox@inbox.ru>
Subject: [PATCH] Kbuild: set LC_MESSAGES=C (as LC_CTYPE=C is)
Date: Fri, 25 Dec 2009 19:13:55 +0200
Message-Id: <1261761235-9431-1-git-send-email-slyfox@inbox.ru>
X-Mailer: git-send-email 1.6.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We restricted LC_CTYPE to ASCII recently but not messages from, say,
gcc. So instead of nice warnings I get '???? ??????? ???????'
(ru_RU.UTF-8 locale) as a gcc warning, which is not nice. So, set
LC_MESSAGES=C too.

Signed-off-by: Sergei Trofimovich <slyfox@inbox.ru>
---
 Makefile |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index c628a5c..67bc799 100644
--- a/Makefile
+++ b/Makefile
@@ -21,7 +21,8 @@ unexport LC_ALL
 LC_CTYPE=C
 LC_COLLATE=C
 LC_NUMERIC=C
-export LC_CTYPE LC_COLLATE LC_NUMERIC
+LC_MESSAGES=C
+export LC_CTYPE LC_COLLATE LC_NUMERIC LC_MESSAGES
 
 # We are using a recursive build, so we need to do a little thinking
 # to get the ordering right.
-- 
1.6.4.4

