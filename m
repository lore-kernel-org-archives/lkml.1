Return-Path: <linux-kernel-owner+w=401wt.eu-S1754808AbYIYNua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808AbYIYNua (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 09:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752908AbYIYNuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 09:50:22 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:31013 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbYIYNuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 09:50:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type;
        b=HYptWbTGAlY8KBhS0zYMaOyhGvvFb0BqS+ttwEex62xMbcE6TJaqgS1sAScEdTZqy2
         jTKPGuY3sgHJihyJF61KYSK3hRHUqmWDFf7gnsPLLk2VSaezgf4UFpdhrS1adNWGFIby
         A6nZ12Ge7ktt56cgzahmr9cEL90EBpUlk8NlM=
Message-ID: <48DBA683.8000708@gmail.com>
Date: Thu, 25 Sep 2008 15:56:03 +0100
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Pekka Paalanen <pq@iki.fi>
Subject: Re: [Patch -tip 1/3] Tracing/ftrace: Relay unhandled entry output
References: <48DB81BA.2050204@gmail.com> <20080925123802.GA6900@elte.hu>
In-Reply-To: <20080925123802.GA6900@elte.hu>
Content-Type: multipart/mixed;
 boundary="------------010605060109030800040606"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010605060109030800040606
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Ingo Molnar a écrit :
> ERROR: do not use assignment in if condition
> #43: FILE: kernel/trace/trace.c:1910:
> +		if ((ret = iter->trace->print_line(iter)))
> 
> ERROR: do not use assignment in if condition
> #48: FILE: kernel/trace/trace.c:1914:
> +		if ((ret = print_bin_fmt(iter)))
> 
> ERROR: do not use assignment in if condition
> #53: FILE: kernel/trace/trace.c:1918:
> +		if ((ret = print_hex_fmt(iter)))
> 
> ERROR: do not use assignment in if condition
> #58: FILE: kernel/trace/trace.c:1922:
> +		if ((ret = print_raw_fmt(iter)))
> 
> ERROR: do not use assignment in if condition
> #63: FILE: kernel/trace/trace.c:1926:
> +		if ((ret = print_lat_fmt(iter, iter->idx, iter->cpu)))
> 
> total: 5 errors, 0 warnings, 0 checks, 32 lines checked
> 
>

Oops sorry. Here it is:

Correct the coding style in the commit 
803294369973b740f4c346553850b56e4b0c3c8a
And remove the ret variable since print functions
only return 0 or 1.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---

 


--------------010605060109030800040606
Content-Type: text/plain;
 name="1.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="1.diff"

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 50ac334..e845664 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1904,27 +1904,25 @@ static int trace_empty(struct trace_iterator *iter)
 
 static int print_trace_line(struct trace_iterator *iter)
 {
-	int ret;
-
 	if (iter->trace && iter->trace->print_line)
-		if ((ret = iter->trace->print_line(iter)))
-			return ret;
+		if (iter->trace->print_line(iter))
+			return 1;
 
 	if (trace_flags & TRACE_ITER_BIN)
-		if ((ret = print_bin_fmt(iter)))
-			return ret;
+		if (print_bin_fmt(iter))
+			return 1;
 
 	if (trace_flags & TRACE_ITER_HEX)
-		if ((ret = print_hex_fmt(iter)))
-			return ret;
+		if (print_hex_fmt(iter))
+			return 1;
 
 	if (trace_flags & TRACE_ITER_RAW)
-		if ((ret = print_raw_fmt(iter)))
-			return ret;
+		if (print_raw_fmt(iter))
+			return 1;
 
 	if (iter->iter_flags & TRACE_FILE_LAT_FMT)
-		if ((ret = print_lat_fmt(iter, iter->idx, iter->cpu)))
-			return ret;
+		if (print_lat_fmt(iter, iter->idx, iter->cpu))
+			return 1;
 
 	return print_trace_fmt(iter);
 }

--------------010605060109030800040606--
