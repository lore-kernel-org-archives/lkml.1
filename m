Return-Path: <linux-kernel-owner+w=401wt.eu-S1753738AbZLQX62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738AbZLQX62 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 18:58:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753029AbZLQX6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 18:58:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:52550 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752684AbZLQX6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 18:58:20 -0500
Date: Thu, 17 Dec 2009 23:58:07 GMT
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       sam@ravnborg.org, rdreier@cisco.com, tglx@linutronix.de, mmarek@sues.cz,
       mhiramat@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rdreier@cisco.com, sam@ravnborg.org, mmarek@sues.cz, tglx@linutronix.de,
       mhiramat@redhat.com
In-Reply-To: <4B2AC394.4030108@redhat.com>
References: <4B2AC394.4030108@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] Makefile: Unexport LC_ALL instead of clearing it
Message-ID: <tip-06b5dc646b9479b786d77749936f25910cd82a37@git.kernel.org>
Git-Commit-ID: 06b5dc646b9479b786d77749936f25910cd82a37
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  06b5dc646b9479b786d77749936f25910cd82a37
Gitweb:     http://git.kernel.org/tip/06b5dc646b9479b786d77749936f25910cd82a37
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Thu, 17 Dec 2009 15:51:37 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 17 Dec 2009 15:51:37 -0800

Makefile: Unexport LC_ALL instead of clearing it

Apparently not all versions of glibc and utilities treat an empty
LC_ALL as nonexistent, causing error messages to be garbled.  Instead,
explicitly unexport it from the environment.

Reported-and-tested-by: Masami Hiramatsu <mhiramat@redhat.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
LKML-Reference: <4B2AC394.4030108@redhat.com>
Cc: Michal Marek <mmarek@sues.cz>
Cc: Roland Dreier <rdreier@cisco.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
---
 Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 6e39af1..5e92ca5 100644
--- a/Makefile
+++ b/Makefile
@@ -17,11 +17,11 @@ NAME = Man-Eating Seals of Antiquity
 MAKEFLAGS += -rR --no-print-directory
 
 # Avoid funny character set dependencies
-LC_ALL=
+unexport LC_ALL
 LC_CTYPE=C
 LC_COLLATE=C
 LC_NUMERIC=C
-export LC_ALL LC_CTYPE LC_COLLATE LC_NUMERIC
+export LC_CTYPE LC_COLLATE LC_NUMERIC
 
 # We are using a recursive build, so we need to do a little thinking
 # to get the ordering right.
