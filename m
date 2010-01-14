Return-Path: <linux-kernel-owner+w=401wt.eu-S1754249Ab0ANEso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249Ab0ANEso (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 23:48:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752273Ab0ANEso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 23:48:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3446 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752115Ab0ANEsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 23:48:43 -0500
Message-ID: <4B4EA2BC.9000307@redhat.com>
Date: Wed, 13 Jan 2010 23:51:08 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf probe: Fix build failure
References: <4B4E8993.5080404@cn.fujitsu.com>
In-Reply-To: <4B4E8993.5080404@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thank you, the patch code looks good to me.

Li Zefan wrote:
> builtin-probe.c:121: error: 'opt_show_lines' defined but not used

Please add some comment for explanation, like:

This build error occurs when compiling perf-tools without dwarf
support (no libdwarf).

> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  tools/perf/builtin-probe.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
> index 1d3a99e..9be8063 100644
> --- a/tools/perf/builtin-probe.c
> +++ b/tools/perf/builtin-probe.c
> @@ -118,6 +118,7 @@ static int opt_del_probe_event(const struct option *opt __used,
>  	return 0;
>  }
>  
> +#ifndef NO_LIBDWARF
>  static int opt_show_lines(const struct option *opt __used,
>  			  const char *str, int unset __used)
>  {
> @@ -127,6 +128,8 @@ static int opt_show_lines(const struct option *opt __used,
>  	session.show_lines = true;
>  	return 0;
>  }
> +#endif
> +
>  /* Currently just checking function name from symbol map */
>  static void evaluate_probe_point(struct probe_point *pp)
>  {

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

