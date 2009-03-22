Return-Path: <linux-kernel-owner+w=401wt.eu-S1755221AbZCVQeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221AbZCVQeW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 12:34:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754862AbZCVQdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 12:33:49 -0400
Received: from gw03.mail.saunalahti.fi ([195.197.172.111]:49952 "EHLO
	gw03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749AbZCVQdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 12:33:49 -0400
From: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
To: akpm@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
Subject: [PATCH 2/2] kexec: vmcoreinfo_data[] can become static
Date: Sun, 22 Mar 2009 18:33:32 +0200
Message-Id: <1237739612-18507-2-git-send-email-dmitri.vorobiev@movial.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1237739612-18507-1-git-send-email-dmitri.vorobiev@movial.com>
References: <1237739612-18507-1-git-send-email-dmitri.vorobiev@movial.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vmcoreinfo_data[] array is not used outside of kernel/kexec.c, and
can therefore become static. This patch adds the relevant keyword to the
definition of the array.

Noticed by sparse.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
---
 kernel/kexec.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/kexec.c b/kernel/kexec.c
index 4838995..c20a7cc 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -42,7 +42,7 @@
 note_buf_t* crash_notes;
 
 /* vmcoreinfo stuff */
-unsigned char vmcoreinfo_data[VMCOREINFO_BYTES];
+static unsigned char vmcoreinfo_data[VMCOREINFO_BYTES];
 u32 vmcoreinfo_note[VMCOREINFO_NOTE_SIZE/4];
 size_t vmcoreinfo_size;
 size_t vmcoreinfo_max_size = sizeof(vmcoreinfo_data);
-- 
1.5.6.3

