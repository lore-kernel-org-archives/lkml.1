Return-Path: <linux-kernel-owner+w=401wt.eu-S1756603AbZCVXGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603AbZCVXGd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 19:06:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753531AbZCVXGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 19:06:21 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:51693 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976AbZCVXGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 19:06:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wjMnmDcNXkIc4LC48T/R+vvnBbz1e6euBFn3FixU21OTeAgTsHdc7ZnJ+0q6CJVOse
         ewvPYsrVPCpuLqog4Ua1c3VuCTRGjG9gCeRdGhkDbhtmyjxklMCSEz9B8cpCtngf3Mpz
         pxKDc6kE1wx1FobaG+aMFHD5s7BuFJGxYbRi4=
Date: Mon, 23 Mar 2009 00:06:16 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 0/4] tracing: event filtering v2
Message-ID: <20090322230615.GI6002@nowhere>
References: <1237710626.7703.45.camel@charm-linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237710626.7703.45.camel@charm-linux>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 22, 2009 at 03:30:26AM -0500, Tom Zanussi wrote:
> Hi,
> 
> This is version 2 of my patchset adding filtering to the event-tracing
> infrastructure.
> 
> Changes from the previous version:
> 
> - added common_ prefix to the 5 common event fields
> - ring_buffer_event_discard() fixes from Steven Rostedt
> - changed 'and' and 'or' for compound filters to '&&' and '||'
> - fixed a bug in the matching logic 
> 
> Everything seems to work ok for me, but I haven't yet gotten around to
> changing the awkward UI.  I plan to fix that as soon as I can i.e. allow
> complete compound expressions to be specified all at once, add <, >, <=,
> >= and parens, etc.  Until then, it should hopefully be usable for basic
> filtering. 
> 
> Thanks,
> 
> Tom
> 


Very nice work!

My events/1 task is pid 4, and swapper (idle) is 0,

cd /debug/tracing/events/sched/sched_switch
echo prev_pid == 4 > filter
echo "&& next_pid == 0" > filter
echo 1 > enable


cat /debug/tracing/trace

# tracer: nop
#
#           TASK-PID    CPU#    TIMESTAMP  FUNCTION
#              | |       |          |         |
           <...>-4     [000]  1136.993069: sched_switch: task events/0:4 [115] ==> swapper:0 [140]
           <...>-4     [000]  1136.993081: sched_switch: task events/0:4 [115] ==> swapper:0 [140]
           <...>-4     [000]  1137.218492: sched_switch: task events/0:4 [115] ==> swapper:0 [140]
           <...>-4     [000]  1137.283787: sched_switch: task events/0:4 [115] ==> swapper:0 [140]
           <...>-4     [000]  1137.458733: sched_switch: task events/0:4 [115] ==> swapper:0 [140]
           <...>-4     [000]  1137.560932: sched_switch: task events/0:4 [115] ==> swapper:0 [140]
           <...>-4     [000]  1137.560941: sched_switch: task events/0:4 [115] ==> swapper:0 [140]
           <...>-4     [000]  1137.741107: sched_switch: task events/0:4 [115] ==> swapper:0 [140]
           <...>-4     [000]  1138.159083: sched_switch: task events/0:4 [115] ==> swapper:0 [140]
           <...>-4     [000]  1138.338673: sched_switch: task events/0:4 [115] ==> swapper:0 [140]
           <...>-4     [000]  1138.338681: sched_switch: task events/0:4 [115] ==> swapper:0 [140]
           <...>-4     [000]  1138.517769: sched_switch: task events/0:4 [115] ==> swapper:0 [140]
           <...>-4     [000]  1138.517833: sched_switch: task events/0:4 [115] ==> swapper:0 [140]
           <...>-4     [000]  1138.517845: sched_switch: task events/0:4 [115] ==> swapper:0 [140]
[...]


:-)

