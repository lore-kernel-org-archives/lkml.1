Return-Path: <linux-kernel-owner+w=401wt.eu-S1764858AbZLQQTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764858AbZLQQTZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 11:19:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763002AbZLQQTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 11:19:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:54904 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761695AbZLQQTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 11:19:20 -0500
Date: Thu, 17 Dec 2009 16:18:35 GMT
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       sam@ravnborg.org, rdreier@cisco.com, tglx@linutronix.de, mmarek@sues.cz,
       mhiramat@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rdreier@cisco.com, sam@ravnborg.org, mmarek@sues.cz, tglx@linutronix.de,
       mhiramat@redhat.com
In-Reply-To: <4B2A1761.4070904@suse.cz>
References: <4B2A1761.4070904@suse.cz>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] Makefile: set LC_CTYPE, LC_COLLATE, LC_NUMERIC to C
Message-ID: <tip-c051346b7db27aaf674b8f3b4955240580b2a58a@git.kernel.org>
Git-Commit-ID: c051346b7db27aaf674b8f3b4955240580b2a58a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c051346b7db27aaf674b8f3b4955240580b2a58a
Gitweb:     http://git.kernel.org/tip/c051346b7db27aaf674b8f3b4955240580b2a58a
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Thu, 17 Dec 2009 06:56:11 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 17 Dec 2009 07:03:21 -0800

Makefile: set LC_CTYPE, LC_COLLATE, LC_NUMERIC to C

There are a number of common Unix constructs like character ranges in
grep/sed/awk which don't work as expected with LC_COLLATE set to other
than C.  Similarly, set LC_CTYPE and LC_NUMERIC to C to avoid other
nasty surprises.

In order to make sure these actually take effect we also have to
clear LC_ALL.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Acked-by: Michal Marek <mmarek@sues.cz>
Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Roland Dreier <rdreier@cisco.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
LKML-Reference: <4B2A1761.4070904@suse.cz>
---
 Makefile |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/Makefile b/Makefile
index 33d4732..6e39af1 100644
--- a/Makefile
+++ b/Makefile
@@ -16,6 +16,13 @@ NAME = Man-Eating Seals of Antiquity
 # o  print "Entering directory ...";
 MAKEFLAGS += -rR --no-print-directory
 
+# Avoid funny character set dependencies
+LC_ALL=
+LC_CTYPE=C
+LC_COLLATE=C
+LC_NUMERIC=C
+export LC_ALL LC_CTYPE LC_COLLATE LC_NUMERIC
+
 # We are using a recursive build, so we need to do a little thinking
 # to get the ordering right.
 #
