Return-Path: <linux-kernel-owner+w=401wt.eu-S1754512AbYIYLXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512AbYIYLXX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 07:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753297AbYIYLXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 07:23:16 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:35617 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286AbYIYLXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 07:23:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type;
        b=mMfNmjxEJB3osXsTMYCGO7EPmbr8yDSoks260Pl8BLjVY+0O0NpIZnjBxTIFlD+icW
         OclpRlMxxdZtWvx06nt+EZYwujSUJcqBD6MWZgMkhPp6ILKoIuKuHcfQnRWubBqAOX6w
         vYPRzYPH7jgQHonmLnboQWIGBwdjkkNy+QlRM=
Message-ID: <48DB8408.7080408@gmail.com>
Date: Thu, 25 Sep 2008 13:28:56 +0100
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Pekka Paalanen <pq@iki.fi>
Subject: [Patch -tip 3/3] Tracing/ftrace: Don't consume entries unhandled
 by mmiotrace
Content-Type: multipart/mixed;
 boundary="------------040708090506070909060608"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040708090506070909060608
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

When mmiotrace can't handle an entry output, it returns 1.
It should return 0 to relay on other output functions.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---

--------------040708090506070909060608
Content-Type: text/plain;
 name="3.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="3.diff"

diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
index a108c32..6fe1315 100644
--- a/kernel/trace/trace_mmiotrace.c
+++ b/kernel/trace/trace_mmiotrace.c
@@ -277,7 +277,8 @@ static int mmio_print_line(struct trace_iterator *iter)
 	case TRACE_PRINT:
 		return mmio_print_mark(iter);
 	default:
-		return 1; /* ignore unknown entries */
+		return 0; /* ignore unknown entries whithout consuming */
 	}
 }
 

--------------040708090506070909060608--
