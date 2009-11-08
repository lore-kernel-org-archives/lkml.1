Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906AbZKHLHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbZKHLHy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 06:07:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753843AbZKHLHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 06:07:53 -0500
Received: from hera.kernel.org ([140.211.167.34]:42280 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753811AbZKHLHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 06:07:52 -0500
Date: Sun, 8 Nov 2009 11:07:12 GMT
From: tip-bot for Hannes Reinecke <hare@suse.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       sam@ravnborg.org, akpm@linux-foundation.org, hare@suse.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       hare@suse.de, akpm@linux-foundation.org, sam@ravnborg.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <200911041519.nA4FJWEW030164@imap1.linux-foundation.org>
References: <200911041519.nA4FJWEW030164@imap1.linux-foundation.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Add back _end symbol that is missing from Symbol.map
Message-ID: <tip-d1e4d37b79e944f6351ae38eb1ca7c9f7b506e76@git.kernel.org>
Git-Commit-ID: d1e4d37b79e944f6351ae38eb1ca7c9f7b506e76
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d1e4d37b79e944f6351ae38eb1ca7c9f7b506e76
Gitweb:     http://git.kernel.org/tip/d1e4d37b79e944f6351ae38eb1ca7c9f7b506e76
Author:     Hannes Reinecke <hare@suse.de>
AuthorDate: Wed, 4 Nov 2009 07:19:32 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 8 Nov 2009 12:05:03 +0100

x86: Add back _end symbol that is missing from Symbol.map

With 2.6.31 'crash' on x86_64 falls flat on its face as the
'_end' symbol is missing from the System.map file.

The culprit is commit 091e52c3551d3031343df24b573b770b4c6c72b6,
which moved the '_end' symbol into it's own section.  Apparently
this causes kallsyms to not reference it properly.

So do not include _end in it's own section.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: <stable@kernel.org> # .31.x
LKML-Reference: <200911041519.nA4FJWEW030164@imap1.linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/vmlinux.lds.S |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 3c68fe2..b2f811d 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -291,9 +291,7 @@ SECTIONS
 		__brk_limit = .;
 	}
 
-	.end : AT(ADDR(.end) - LOAD_OFFSET) {
-		_end = .;
-	}
+	_end = .;
 
         STABS_DEBUG
         DWARF_DEBUG
