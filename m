Return-Path: <linux-kernel-owner+w=401wt.eu-S1758614AbYLFDB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758614AbYLFDB7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 22:01:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755122AbYLFDBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 22:01:50 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:9793 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755044AbYLFDBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 22:01:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=M2WlzWzDujja+zPHO1Q0G8m+Bb6PCycxZCDB8g2lKN6UlcLy2ta1J7uaJiW4KuMjG3
         iMMbq3Y/Ge66iIRqlgU+KbZHycEtEd9/bpfTGQnOAAC7r5QjC7Zsme7vcWBDjO6vY+LG
         o7DgkPLNWCMUKAn19my1O1e4b8KRx6u/6hJro=
Message-ID: <4939EB18.6090606@gmail.com>
Date: Sat, 06 Dec 2008 04:01:44 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] tracing/function-graph-tracer: introduce __notrace_funcgraph
 to filter special functions
References: <4939E600.804@gmail.com>
In-Reply-To: <4939E600.804@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> Impact: trace more functions
> 
> When the function graph tracer is configured, three more files are not traced to prevent
> only four functions to be traced. And this impacts the normal function tracer too.
> 
> arch/x86/kernel/process_64/32.c:
> 
> I had crashes when I let this file traced. After some debugging, I saw that 
> the "current" task point was changed inside__swtich_to(), ie: "write_pda(pcurrent, next_p);" 
> inside process_64.c 
> Since the tracer store the original return address of the function inside current, we had crashes.
> Only __switch_to() has to be traced.
> 
> kernel/module.c and kernel/extable.c:
> 
> Because of a function used internally by the function graph tracer: __kernel_text_address()
> 
> To let the other functions inside these files to be traced, this patch introduces the 
> __notrace_funcgraph function prefix which is __notrace if function graph tracer is 
> configured and nothing if not.
> 


And once again I...did not test under x86-32 :-s
