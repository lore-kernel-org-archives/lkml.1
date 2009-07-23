Return-Path: <linux-kernel-owner+w=401wt.eu-S1752027AbZGWAuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027AbZGWAuu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 20:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750943AbZGWAut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 20:50:49 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64236 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750865AbZGWAut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 20:50:49 -0400
Message-ID: <4A67B3DC.5080507@cn.fujitsu.com>
Date: Thu, 23 Jul 2009 08:50:36 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: prasad@linux.vnet.ibm.com
CC: Ingo Molnar <mingo@elte.hu>, Alan Stern <stern@rowland.harvard.edu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] tracing/ksym_tracer: support quick clear for	ksym_trace_filter
References: <4A6685BB.2090809@cn.fujitsu.com> <4A66869A.9000106@cn.fujitsu.com> <20090722050636.GA9039@in.ibm.com> <4A66E261.2090105@cn.fujitsu.com> <20090722151759.GA11367@in.ibm.com>
In-Reply-To: <20090722151759.GA11367@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



K.Prasad wrote:

> As I stated before, the ability to support
> echo "*:---" > ksym_trace_filter was Ingo Molnar's suggestion, so if
> he's not particular about having it now we may skip it.
> 

OK, I'll fix it.

> However, given that it requires just a few lines of code in addition,
> say
> 
> +	/* Clear all breakpoints if echo "*:---" > ksym_trace_filter */
> +	if ((strncmp(ksymname, "*", strlen("*")) == 0) && (op == 0)) {
> +		ksym_trace_reset(NULL);
> +		kfree(input_string);
> +		return count;
> +	}
> 

I think below way is simpler:

+	/*
+	/* Clear all breakpoints if:
+	/* 1: echo > ksym_trace_filter
+	/* 2: echo 0 > ksym_trace_filter
+	/* 3: echo "*:---" > ksym_trace_filter 
+	*/
+	strstrip(input_string);
+	if (!input_string[0] || !strcmp(input_string, "0") ||
+	   (!strcmp(input, "*:---")) {
+		__ksym_trace_reset();
+		kfree(input_string);
+		return count;
+	}
+

I'll sent a new patch after do some test for it.

Thanks,
Xiao

> in ksym_trace_filter_write(), and that the patch is already present it
> shouldn't be bothersome to add it.
> 
> Thanks,
> K.Prasad
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
