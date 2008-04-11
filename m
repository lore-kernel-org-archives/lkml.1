Return-Path: <linux-kernel-owner+w=401wt.eu-S1761321AbYDKQzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761321AbYDKQzU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 12:55:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760440AbYDKQzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 12:55:09 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36157 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760164AbYDKQzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 12:55:08 -0400
Subject: Re: 2.6.25-rc8-mm2 -- kernel/sched.c:8294: error: unknown field
	=?UTF-8?Q?=E2=80=98read=5Fuint=E2=80=99?= specified in initializer
From: Peter Zijlstra <peterz@infradead.org>
To: Miles Lane <miles.lane@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <a44ae5cd0804110648g3256805fob917f31eeff4f6db@mail.gmail.com>
References: <a44ae5cd0804110648g3256805fob917f31eeff4f6db@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 11 Apr 2008 18:55:02 +0200
Message-Id: <1207932902.7157.4.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-04-11 at 09:48 -0400, Miles Lane wrote:
> CC      kernel/sched.o
> kernel/sched.c:8294: error: unknown field 'read_uint' specified in initializer
> kernel/sched.c:8294: warning: initialization makes integer from
> pointer without a cast
> kernel/sched.c:8295: error: unknown field 'write_uint' specified in initializer
> kernel/sched.c:8295: warning: initialization from incompatible pointer type

someone mucked around with the cgroup api; this should fix it:

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
diff --git a/kernel/sched.c b/kernel/sched.c
index 7119895..8b4e0b6 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8291,8 +8291,8 @@ static struct cftype cpu_files[] = {
 	},
 	{
 		.name = "rt_period_us",
-		.read_uint = cpu_rt_period_read_uint,
-		.write_uint = cpu_rt_period_write_uint,
+		.read_u64 = cpu_rt_period_read_uint,
+		.write_u64 = cpu_rt_period_write_uint,
 	},
 #endif
 };


