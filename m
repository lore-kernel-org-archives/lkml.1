Return-Path: <linux-kernel-owner+w=401wt.eu-S1752934AbYKQSio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934AbYKQSio (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 13:38:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750922AbYKQSig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 13:38:36 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:35869 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbYKQSif convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 13:38:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=uH2RUzE8+r100TFiHq9iI132ks1KBsO2UtIaxq8yYu0XhN9c3nllNgGlqxJFspamPE
         Vz18wBteNvw8PdxYg88ruyEK1JU17pEhbKjNStU+eb5U6ZWfhcWBL3VUo2Z7RNUe2+W5
         ljqvfKhPvbV6zbZYy6RGkk8kPk+o3kEdh1dew=
Message-ID: <4921BA25.3090704@gmail.com>
Date: Mon, 17 Nov 2008 19:38:29 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] tracing/function-return-tracer: add the overrun field
References: <4920D571.4050007@gmail.com> <20081117084923.GD28786@elte.hu>
In-Reply-To: <20081117084923.GD28786@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar a écrit :
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
>> Impact: help to find the better depth of trace
>>
>> We decided to arbitrary define the depth of function return trace as 
>> "20". Perhaps this is not enough. To help finding an optimal depth, 
>> we measure now the overrun: the number of functions that have been 
>> missed for the current thread. By default this is not displayed, we 
>> have to do set a particular flag on the return tracer: echo overrun 
>>> /debug/tracing/trace_options And the overrun will be printed on 
>> the right.
>>
>> As the trace shows below, the current 20 depth is not enough.
>>
>> update_wall_time+0x37f/0x8c0 -> update_xtime_cache (345 ns) (Overruns: 2838)
>> update_wall_time+0x384/0x8c0 -> clocksource_get_next (1141 ns) (Overruns: 2838)
>> do_timer+0x23/0x100 -> update_wall_time (3882 ns) (Overruns: 2838)
> 
> hm, interesting. Have you tried to figure out what a practical depth 
> limit would be?
> 
> With lockdep we made the experience that function call stacks can be 
> very deep - if we count IRQ contexts too it can be up to 100 in the 
> extreme cases. (but at that stage kernel stack limits start hitting 
> us)
> 
> I'd say 50 would be needed.
> 
> 	Ingo


Ok I will try with 50. If there are still a lot and often missing traces with this depth, perhaps
should we consider a hybrid solution between ret stack and trampolines?
We could use the normal ret stack on struct info for most common cases and the trampoline when we are exceeding the depth....

