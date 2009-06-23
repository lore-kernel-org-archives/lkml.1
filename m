Return-Path: <linux-kernel-owner+w=401wt.eu-S1756164AbZFWJHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164AbZFWJHd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 05:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752161AbZFWJH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 05:07:26 -0400
Received: from krynn.se.axis.com ([193.13.178.10]:50341 "EHLO
	krynn.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbZFWJHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 05:07:25 -0400
Date: Tue, 23 Jun 2009 11:07:08 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: sam@ravnborg.org, linux-kernel@vger.kernel.org,
       Tim Abbott <tabbott@mit.edu>
Subject: [PATCH] Make INIT_TASK_DATA use INIT_TASK macro with parameter
Message-ID: <20090623090708.GA12383@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The definition of INIT_TASK_DATA in include/asm-generic/vmlinux.lds.h
looks a bit dodgy, it uses the INIT_TASK macro but without any parameters.

The INIT_TASK macro takes a parameter for alignment,
but we already have aligned, so give it a zero as parameter.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 include/asm-generic/vmlinux.lds.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 92b73b6..648826b 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -437,7 +437,7 @@
 #define INIT_TASK_DATA(align)						\
 	. = ALIGN(align);						\
 	.data.init_task : {						\
-		INIT_TASK						\
+		INIT_TASK(0)						\
 	}
 
 #ifdef CONFIG_CONSTRUCTORS
-- 
1.6.1

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
