Return-Path: <linux-kernel-owner+w=401wt.eu-S1757368AbYJEQL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368AbYJEQL4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756516AbYJEQHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:07:34 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54874 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756512AbYJEQHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:07:32 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 21/76] audit: Handle embedded NUL in TTY input auditing
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:07:32 +0100
Message-ID: <20081005160726.1997.52057.stgit@localhost.localdomain>
In-Reply-To: <20081005160231.1997.10462.stgit@localhost.localdomain>
References: <20081005160231.1997.10462.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miloslav Trmac <mitr@redhat.com>

Data read from a TTY can contain an embedded NUL byte (e.g. after
pressing Ctrl-2, or sent to a PTY).  After the previous patch, the data
would be logged only up to the first NUL.

This patch modifies the AUDIT_TTY record to always use the hexadecimal
format, which does not terminate at the first NUL byte.  The vast
majority of recorded TTY input data will contain either ' ' or '\n', so
the hexadecimal format would have been used anyway.

Signed-off-by: Miloslav Trmac <mitr@redhat.com>
Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/char/tty_audit.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/tty_audit.c b/drivers/char/tty_audit.c
index 3582f43..5787249 100644
--- a/drivers/char/tty_audit.c
+++ b/drivers/char/tty_audit.c
@@ -93,7 +93,7 @@ static void tty_audit_buf_push(struct task_struct *tsk, uid_t loginuid,
 		get_task_comm(name, tsk);
 		audit_log_untrustedstring(ab, name);
 		audit_log_format(ab, " data=");
-		audit_log_n_untrustedstring(ab, buf->data, buf->valid);
+		audit_log_n_hex(ab, buf->data, buf->valid);
 		audit_log_end(ab);
 	}
 	buf->valid = 0;

