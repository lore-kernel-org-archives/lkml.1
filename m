Return-Path: <linux-kernel-owner+w=401wt.eu-S1754539AbZKIQyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbZKIQyK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 11:54:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754409AbZKIQyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 11:54:09 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:57711 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754249AbZKIQyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 11:54:08 -0500
Message-ID: <4AF848C0.7010807@monstr.eu>
Date: Mon, 09 Nov 2009 17:52:16 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: wuzhangjin@gmail.com, linux-kernel@vger.kernel.org,
       John Williams <john.williams@petalogix.com>
Subject: dynamic ftrace - graph
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve and others,

I have working dynamic ftrace function. :-)

I look at __ftrace_modify_code function and I have one question about.
Below are function which are called when I enable function_graph.

I personally think that make more sense to call 
ftrace_enable_ftrace_graph_caller before ftrace_update_ftrace_func.
The reason for it is that graph_caller enable calling graph tracing 
which should be setup before ftrace_update_ftrace_func which enable 
whole tracing function.



# cd ; mkdir /debug; mount -t debugfs none /debug; cat 
/debug/tracing/available_tracers; echo function_graph > 
/debug/tracing/current_tracer;echo 0 > /debug/tra
cing/tracing_enabled;cat /debug/tracing/trace | head -n 10
function_graph function sched_switch nop

ftrace_update_ftrace_func 0xc0009100 0xc00091c4, 0xb000c000, 0x32809100
ftrace_enable_ftrace_graph_caller
# tracer: function_graph


For disabling graph trace is sequence ok I think.

# echo function > /debug/tracing/current_tracer
ftrace_disable_ftrace_graph_caller
ftrace_update_ftrace_func 0xc006afe4 0xc00091c4, 0xb000c006, 0x3280afe4


What do you think?

Thanks,
Michal


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
