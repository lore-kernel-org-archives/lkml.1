Return-Path: <linux-kernel-owner+w=401wt.eu-S1751903AbZAFLc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903AbZAFLc7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 06:32:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750849AbZAFLcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 06:32:50 -0500
Received: from fk-out-0910.google.com ([209.85.128.184]:30475 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbZAFLcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 06:32:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=hAgVe9hjZEP+2qSUsrR8ZjfkPVOuRgR+nTMaPgAJMH2NxIQ610V0Y1vxrZkcpQg2q2
         uQy8qpeH7/QESYHt8j42CxpyAKJc4qSlm5nRbzuR5q2SvucsSekV+tDT8g4lQDNuXUie
         zloU/m91jnoDmu9JcO6mMCsc+FT4nhkb2ZQc8=
Message-ID: <c62985530901060332q1bc92a6dk4cb1e4cd6febddba@mail.gmail.com>
Date: Tue, 6 Jan 2009 12:32:47 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Lai Jiangshan" <laijs@cn.fujitsu.com>
Subject: Re: [PATCH 2/5] ftrace: infrastructure for supporting binary record
Cc: "Arnaldo Carvalho de Melo" <acme@ghostprotocols.net>,
       "Ingo Molnar" <mingo@elte.hu>, "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <49616B0B.5000102@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <495ADF45.2030203@cn.fujitsu.com> <20081231045956.GC28472@nowhere>
	 <39e6f6c70901021424v28c1a7dbgbaaf67ac12ca9526@mail.gmail.com>
	 <49616B0B.5000102@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/5 Lai Jiangshan <laijs@cn.fujitsu.com>:
>
>>>
>>> Just for curiosity. Why do you need such a binary tracing?
>>> Do you need it because a string output is really too slow for your needs?
>
> Hi, Frederic Weisbecker,
>
> We have
> 1) lots of kinds events source(FUNCTION trace, TRACE_CTX, tracepoint, markers ...)
> 2) a generic and mature events log buffer - trace/ringbuffer.c
> 3) a generic and mature trace framework - trace/trace.c trace_ouput.c
>
> But we don't have a generic events log format, we record different
> events with different record formats: TRACE_FN, TRACE_CTX, TRACE_GRAPH_RET,
> TRACE_SPECIAL, ... We use different struct for recording different
> formats.


I understand better now. So it acts like an optimized ftrace_printk.
Instead of inserting formatted ftrace_printk entries on the ring buffer,
we insert the binary datas with the format and let the tracer decide
what to do with this,
providing a full generic entry transport....

That looks a good idea.
