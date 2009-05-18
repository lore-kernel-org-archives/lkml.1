Return-Path: <linux-kernel-owner+w=401wt.eu-S1755197AbZERU4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197AbZERU4k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 16:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbZERU4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 16:56:32 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:6849 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838AbZERU4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 16:56:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=CJ51y9ECb27ISLSY2/DBDLAgV8l2Nr9UfdFuUwrFX7S/6v7c92QNeOTKHy/pb/ksdp
         O/XBvwF09NmUNuLjUipiNrIQ3MkpDBJf/GfwI+6qz0zLHsOgVuDkNY0KPHxMnnlDha5Q
         7bGj9vodaPxueJEwLDb08wRxo/FJ4qqPYwSaA=
Message-ID: <4A11CB5C.8070800@gmail.com>
Date: Mon, 18 May 2009 22:55:56 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1b5pre) Gecko/20090511 SUSE/3.0b2-9.1 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: use strlcpy instead of strncpy
References: <4A11480F.3030000@cn.fujitsu.com>
In-Reply-To: <4A11480F.3030000@cn.fujitsu.com>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2009 01:35 PM, Lai Jiangshan wrote:
> strlcpy() will add '\0' for the copied string.
> 
> [Impact] cleanup
...
> --- a/kernel/trace/trace_branch.c
> +++ b/kernel/trace/trace_branch.c
> @@ -67,10 +67,8 @@ probe_likely_condition(struct ftrace_branch_data *f, int val, int expect)
>  		p--;
>  	p++;
>  
> -	strncpy(entry->func, f->func, TRACE_FUNC_SIZE);
> -	strncpy(entry->file, p, TRACE_FILE_SIZE);
> -	entry->func[TRACE_FUNC_SIZE] = 0;
> -	entry->file[TRACE_FILE_SIZE] = 0;
> +	strlcpy(entry->func, f->func, TRACE_FUNC_SIZE);
> +	strlcpy(entry->file, p, TRACE_FILE_SIZE);

Hmm, this is not the same. +1 is missing here.
