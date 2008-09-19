Return-Path: <linux-kernel-owner+w=401wt.eu-S1754753AbYISOwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753AbYISOwq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 10:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751503AbYISOwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 10:52:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42904 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333AbYISOwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 10:52:37 -0400
Date: Fri, 19 Sep 2008 16:51:46 +0200
From: Jiri Pirko <jpirko@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] audit: removed bogus newline
Message-ID: <20080919165146.0aa2ab80@psychotron.englab.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

PATH records, as output by the kernel, contain a newline after the
flags fields, which is in the middle of the record. EXECVE records
contain a newline after every argument. auditd seems to hide this,
but they're there nevertheless. If you're not using auditd, you
need to work round them.

What do you think about it?

Jirka


Signed-off-by: Jiri Pirko <jpirko@redhat.com>

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 59cedfb..bf10cb0 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1119,7 +1119,7 @@ static int audit_log_single_execve_arg(struct audit_context *context,
 			audit_log_n_hex(*ab, buf, to_send);
 		else
 			audit_log_format(*ab, "\"%s\"", buf);
-		audit_log_format(*ab, "\n");
+		audit_log_format(*ab, " ");
 
 		p += to_send;
 		len_left -= to_send;
