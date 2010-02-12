Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601Ab0BLABb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 19:01:31 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:53379
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757501Ab0BLAB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 19:01:28 -0500
X-SpamScore: -34
X-BigFish: VPS-34(zzab9bh1432R98dN936eM1521M9371Pzz1202hzzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
Message-ID: <4B749A42.2080703@am.sony.com>
Date: Thu, 11 Feb 2010 16:01:06 -0800
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Steven Rostedt <srostedt@redhat.com>
CC: linux kernel <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 1/1] ftrace - add support for tracing_thresh to function_graph
 tracer
References: <4B733721.3030503@am.sony.com>  <4B7338BF.1070505@am.sony.com> <1265929831.2737.340.camel@localhost.localdomain>
In-Reply-To: <1265929831.2737.340.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Reverse-DNS: mail7.fw-bc.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2010 03:10 PM, Steven Rostedt wrote:
> On Wed, 2010-02-10 at 14:52 -0800, Tim Bird wrote:
>>  static struct tracer_opt trace_opts[] = {
>>  	/* Display overruns? (for self-debug purpose) */
>> @@ -53,6 +54,8 @@ static struct tracer_opt trace_opts[] = {
>>  	{ TRACER_OPT(funcgraph-duration, TRACE_GRAPH_PRINT_DURATION) },
>>  	/* Display absolute time of an entry */
>>  	{ TRACER_OPT(funcgraph-abstime, TRACE_GRAPH_PRINT_ABS_TIME) },
>> +	/* Display function name on exit, instead of just closing brace */
>> +	{ TRACER_OPT(funcgraph-exit, TRACE_GRAPH_PRINT_FUNC_EXIT) },
>>  	{ } /* Empty entry */
> 
> I wonder if this should be enabled on start up of the function graph
> tracer if the threshold is set?
> 
> Otherwise people will wonder WTF?

Indeed.  I'm not sure exactly how to do this.

Would it be better to set the option when current_tracer
is set with 'function_graph', and tracing_thresh is non-zero?
Or should I set the option when tracing_thresh is set to
non-zero, and the current_trace is set to 'function_graph'?

Or both?

It wouldn't automatically reset to nofuncgraph-exit
unless I also put some magic in for that.  I'm
pretty sure that disabling it automatically would
lead to unobvious behaviour for the user.

I'll look into how to access the options
from those two points, and see what looks feasible.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

