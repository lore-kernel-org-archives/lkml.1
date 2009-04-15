Return-Path: <linux-kernel-owner+w=401wt.eu-S1756000AbZDOAKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000AbZDOAKf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 20:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752428AbZDOAK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 20:10:26 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4877 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbZDOAK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 20:10:26 -0400
Subject: Re: [PATCH] vsprintf: introduce %pf
From: Joe Perches <joe@perches.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1239753659-11790-1-git-send-email-fweisbec@gmail.com>
References: <1239753659-11790-1-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain
Date: Tue, 14 Apr 2009 17:09:56 -0700
Message-Id: <1239754196.28331.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2-1.2mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-15 at 02:00 +0200, Frederic Weisbecker wrote:
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index b56f6d0..15c9094 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -575,12 +575,15 @@ static char *string(char *buf, char *end, char *s, struct printf_spec spec)
>  }
>  
>  static char *symbol_string(char *buf, char *end, void *ptr,
> -				struct printf_spec spec)
> +				struct printf_spec spec, char ext)
>  {
>  	unsigned long value = (unsigned long) ptr;
>  #ifdef CONFIG_KALLSYMS
>  	char sym[KSYM_SYMBOL_LEN];
> -	sprint_symbol(sym, value);
> +	if (ext != 'f')
> +		sprint_symbol(sym, value);
> +	else
> +		kallsyms_lookup(value, NULL, NULL, NULL, sym);

buffer overflow waiting to happen yes?


