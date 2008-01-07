Return-Path: <linux-kernel-owner+w=401wt.eu-S1753822AbYAGBa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822AbYAGBa3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 20:30:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164AbYAGBaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 20:30:21 -0500
Received: from mga10.intel.com ([192.55.52.92]:23401 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752042AbYAGBaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 20:30:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,251,1196668800"; 
   d="scan'208";a="276178945"
Subject: Re: Improve hackbench
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Lee Revell <rlrevell@joe-job.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <75b66ecd0801040444y4d698d7fh9caf52955b2b6aad@mail.gmail.com>
References: <1199426786.3298.64.camel@ymzhang>
	 <20080104081043.GA23046@elte.hu>
	 <75b66ecd0801040444y4d698d7fh9caf52955b2b6aad@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Mon, 07 Jan 2008 09:27:39 +0800
Message-Id: <1199669259.3298.80.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-01-04 at 07:44 -0500, Lee Revell wrote:
> On Jan 4, 2008 3:10 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >   http://redhat.com/~mingo/cfs-scheduler/tools/hackbench.c
> >
> 
> Why not lose the #ifdef and just use PTHREAD_STACK_MIN?
That's a good idea.

Thanks,
-yanmin

---

--- hackbench.c.orig	2008-01-10 08:24:36.000000000 +0800
+++ hackbench.c	2008-01-10 08:25:12.000000000 +0800
@@ -151,10 +151,8 @@ pthread_t create_worker(void *ctx, void 
 	if (pthread_attr_init(&attr) != 0)
 		barf("pthread_attr_init:");
 
-#ifndef __ia64__
-	if (pthread_attr_setstacksize(&attr, (size_t)(16*1024)) != 0)
+	if (pthread_attr_setstacksize(&attr, PTHREAD_STACK_MIN) != 0)
 		barf("pthread_attr_setstacksize");
-#endif
 
 	if ((err=pthread_create(&childid, &attr, func, ctx)) != 0) {
 		fprintf(stderr, "pthread_create failed: %s (%d)\n", strerror(err), err);


