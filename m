Return-Path: <linux-kernel-owner+w=401wt.eu-S1763171AbZFLN0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763171AbZFLN0Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760956AbZFLNZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:25:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47963 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759069AbZFLNZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:25:41 -0400
From: Petr Tesarik <ptesarik@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Roland McGrath <roland@redhat.com>, Petr Tesarik <ptesarik@suse.cz>
Subject: [PATCH 8/8] x86: remove unneeded section from the vDSO
Date: Fri, 12 Jun 2009 15:25:42 +0200
Message-Id: <5e9e5ea6462821a4eaea334c357cdeafcfe13612.1244812577.git.ptesarik@suse.cz>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <cover.1244812577.git.ptesarik@suse.cz>
References: <cover.1244812577.git.ptesarik@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some standard sections are not useful in the resulting binary.

.gnu.warning.* is only interesting for the linker.

.note.* may be discarded, except:
  .note.Linux which contains the Linux version
  .note.gnu.build-id which may be useful for identifying
    the vDSO

Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
---
 arch/x86/vdso/vdso-layout.lds.S |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/arch/x86/vdso/vdso-layout.lds.S b/arch/x86/vdso/vdso-layout.lds.S
index ea9ef58..93e0b40 100644
--- a/arch/x86/vdso/vdso-layout.lds.S
+++ b/arch/x86/vdso/vdso-layout.lds.S
@@ -31,7 +31,8 @@ SECTIONS
 	}
 
 	.note : {
-		*(.note.*)
+		*(.note.Linux)
+		*(.note.gnu.build-id)
 	} :text :note
 
 	.eh_frame_hdr : {
@@ -98,6 +99,12 @@ SECTIONS
 		*(.altinstructions)
 		*(.altinstr_replacement)
 	}
+
+	/* These sections are not useful to user-space */
+	/DISCARD/ : {
+		*(.gnu.warning.*)
+		*(.note.*)
+	}
 }
 
 /* This assert is triggered if the linker finds a section in one of its
-- 
1.6.0.2

