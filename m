Return-Path: <linux-kernel-owner+w=401wt.eu-S1765876AbXJORM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765876AbXJORM1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 13:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932417AbXJORL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 13:11:29 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54252 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758674AbXJORL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 13:11:27 -0400
Date: Mon, 15 Oct 2007 10:08:58 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Boaz Harrosh <bharrosh@panasas.com>,
       James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch] scsi: fix crash in gdth_timeout()
In-Reply-To: <20071015165534.GA17833@elte.hu>
Message-ID: <alpine.LFD.0.999.0710151006400.6887@woody.linux-foundation.org>
References: <20071015165534.GA17833@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 15 Oct 2007, Ingo Molnar wrote:
> 
> A further problem is probably that the GDTH timer is not stopped by a
> failed GDTH probe?

Indeed. Maybe this is a better fix?

That driver is pretty messy, and this should have been found ealier. 
James? Boaz?

		Linus

---
 drivers/scsi/gdth.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index e8010a7..3ac080e 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -5213,6 +5213,10 @@ static int __init gdth_init(void)
 #endif /* CONFIG_PCI */
 
 	TRACE2(("gdth_detect() %d controller detected\n", gdth_ctr_count));
+
+	if (list_empty(&gdth_instances))
+		return -ENODEV;
+
 #ifdef GDTH_STATISTICS
 	TRACE2(("gdth_detect(): Initializing timer !\n"));
 	init_timer(&gdth_timer);
