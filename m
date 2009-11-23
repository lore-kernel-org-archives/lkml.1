Return-Path: <linux-kernel-owner+w=401wt.eu-S1755770AbZKWQgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770AbZKWQgV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 11:36:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754527AbZKWQgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 11:36:20 -0500
Received: from smtp-out.google.com ([216.239.33.17]:16419 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944AbZKWQgU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 11:36:20 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=N8xct+TWd+UTc3aa0C+yJ1muQcvTLat8+VupmENiJYSGBg46VYsTtYapOyvpWRloL
	E0Yhp0a5WK1BesArsKuTQ==
MIME-Version: 1.0
In-Reply-To: <4b0ab8b1.1c07d00a.4859.5f71@mx.google.com>
References: <4b0ab8b1.1c07d00a.4859.5f71@mx.google.com>
Date: Mon, 23 Nov 2009 17:36:20 +0100
Message-ID: <bd4cb8900911230836na261658udd82f5c20630ffba@mail.gmail.com>
Subject: [PATCH] perf_events: fix bogus copy_to_user() in perf_event_read_group()
From: Stephane Eranian <eranian@google.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: eranian@gmail.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
       perfmon2-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

       When using an event group, the value and id for non leaders events were
       wrong due to invalid offset into the outgoing buffer.

       Signed-off-by: Stephane Eranian <eranian@google.com>

---
 perf_event.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 0b0d5f7..8306127 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1826,7 +1826,7 @@ static int perf_event_read_group(struct perf_event *event,

               size = n * sizeof(u64);

-               if (copy_to_user(buf + size, values, size)) {
+               if (copy_to_user(buf + ret, values, size)) {
                       ret = -EFAULT;
                       goto unlock;
               }
