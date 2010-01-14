Return-Path: <linux-kernel-owner+w=401wt.eu-S1755711Ab0ANGa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711Ab0ANGa4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 01:30:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755162Ab0ANGaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 01:30:55 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61589 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751506Ab0ANGay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 01:30:54 -0500
Message-ID: <4B4EBA20.1000800@cn.fujitsu.com>
Date: Thu, 14 Jan 2010 14:30:56 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Masami Hiramatsu <mhiramat@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf probe: Fix build failure
References: <4B4E8993.5080404@cn.fujitsu.com> <4B4EA2BC.9000307@redhat.com> <4B4EAA54.9000109@cn.fujitsu.com> <4B4EB7CB.2030807@redhat.com>
In-Reply-To: <4B4EB7CB.2030807@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>> builtin-probe.c:121: error: 'opt_show_lines' defined but not used
>>> Please add some comment for explanation, like:
>>>
>>> This build error occurs when compiling perf-tools without dwarf
>>> support (no libdwarf).
>>>
>> But as simple as this patch, the code itself has explained
>> the cause of this compile error.
> 
> If someone looks git-log afterwords, below message seems too
> short.
> ---
> perf probe: Fix build failure
> 
> builtin-probe.c:121: error: 'opt_show_lines' defined but not used
> ---
> Especially, if there is libdwarf, we will not see above error. So
> IMHO, at least we'd better add a comment about how the error occurs.
> 

Fair enough, here's the updated patch, and I guess I can
add you acked-by.

=============

From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH] perf probe: Fix build failure

When compiling perf-tools without dwarf support, I ran into this:

builtin-probe.c:121: error: 'opt_show_lines' defined but not used

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
---
 tools/perf/builtin-probe.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 1d3a99e..9be8063 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -118,6 +118,7 @@ static int opt_del_probe_event(const struct option *opt __used,
 	return 0;
 }
 
+#ifndef NO_LIBDWARF
 static int opt_show_lines(const struct option *opt __used,
 			  const char *str, int unset __used)
 {
@@ -127,6 +128,8 @@ static int opt_show_lines(const struct option *opt __used,
 	session.show_lines = true;
 	return 0;
 }
+#endif
+
 /* Currently just checking function name from symbol map */
 static void evaluate_probe_point(struct probe_point *pp)
 {
-- 
1.6.3

