Return-Path: <linux-kernel-owner+w=401wt.eu-S1756453AbZCESNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453AbZCESNw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 13:13:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754161AbZCESNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 13:13:41 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:50254 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055AbZCESNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 13:13:40 -0500
Date: Thu, 5 Mar 2009 12:13:25 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Oren Laadan <orenl@cs.columbia.edu>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC][PATCH 00/11] track files for checkpointability
Message-ID: <20090305181325.GA10666@us.ibm.com>
References: <20090305163857.0C18F3FD@kernel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090305163857.0C18F3FD@kernel>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I need the following to get fdinfo checkpointability output:

>From 4002821bf068c122867c3b1819817f0b1fdfc250 Mon Sep 17 00:00:00 2001
From: Serge E. Hallyn <serue@us.ibm.com>
Date: Thu, 5 Mar 2009 10:12:30 -0800
Subject: [PATCH 1/1] checkpointable: add missing trailing \n for fdinfo output

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 fs/proc/base.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index bde92c3..12543b6 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1657,7 +1657,7 @@ static void proc_fd_write_info(struct file *file, char *info)
 
 	if (file->f_op->checkpoint)
 		checkpointable = 1;
-	p += scnprintf(info+p, max-p, "checkpointable:\t%d", checkpointable);
+	p += scnprintf(info+p, max-p, "checkpointable:\t%d\n", checkpointable);
 	if (!checkpointable)
 		p += cr_explain_file(file, info+p, max-p);
 }
-- 
1.5.4.3

