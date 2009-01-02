Return-Path: <linux-kernel-owner+w=401wt.eu-S1757895AbZABOt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895AbZABOt4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 09:49:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752797AbZABOtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 09:49:47 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:48278 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbZABOtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 09:49:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=EtF+o78RjEk3bsZfxoPjTPj/HQ3uvHEC6wGNbUUsLHlfAgFci6Hbx/psBaBdE8arUY
         U6AvMugjP/LkFKRyHjhPuVCdHumTfT+JlAg9YI7Dxs9yYyIrdls1ngxluOxZWlSsp0uE
         WuwAZcLBeEiS4LUghqeJqfG8HWdH/OCP22QVw=
Message-ID: <495E2987.3070501@gmail.com>
Date: Fri, 02 Jan 2009 15:49:43 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] ftrace: unsigned idx cannot be less than 0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

// vi kernel/trace/ftrace.c +787
struct ftrace_iterator {
...
        unsigned                idx;
...
};

idx is unsigned and cannot be less than 0.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 2f32969..a344add 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -842,7 +842,7 @@ static void *t_start(struct seq_file *m, loff_t *pos)
 	void *p = NULL;
 
 	if (*pos > 0) {
-		if (iter->idx < 0)
+		if (iter->idx == 0)
 			return p;
 		(*pos)--;
 		iter->idx--;
