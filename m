Return-Path: <linux-kernel-owner+w=401wt.eu-S1755620AbYK0Pea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620AbYK0Pea (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 10:34:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbYK0PeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 10:34:21 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:40438 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbYK0PeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 10:34:21 -0500
Date: Thu, 27 Nov 2008 10:34:19 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: walimis <walimisdev@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: about use wild cards for set_ftrace_filter and so on
In-Reply-To: <20081127152124.GA24616@ubuntu.mshome.net>
Message-ID: <alpine.DEB.1.10.0811271032360.18691@gandalf.stny.rr.com>
References: <20081127152124.GA24616@ubuntu.mshome.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 27 Nov 2008, walimis wrote:

> 
> I encountered an issue when using ftrace.
> We know that we can use wild cards to set set_ftrace_filter, but there's 
> problem when using such as "echo h* > /debug/tracing/set_ftrace_filter".
> If there are files named with "h" prefix in current directory, echo "h*" 
> will echo these files' name to set_ftrace_filter, not "h*".
> For example:
> 
> #cat /debug/tracing/available_filter_functions |grep ^hr |wc -l
> 23
> #ls
> #touch hraa hrdd
> #ls 
> hraa  hrdd
> #echo hr* > /debug/tracing/set_ftrace_filter
> #cat /debug/tracing/set_ftrace_filter
> 
> No output in /debug/tracing/set_ftrace_filter!
> If we use "" to enclose wild cards, it works:
> 
> #ls 
> hraa  hrdd
> #echo "hr*" > /debug/tracing/set_ftrace_filter
> #cat /debug/tracing/set_ftrace_filter |wc -l 
> 23
> 
> This problem can lead to unexpected result if current directory has a 
> lot of files.
> I suppose that we can add some notes to document, so a patch attached.

Using TB? It's best to inline the patch, that way I can comment on it 
better.

Anyway, you should fix the example. I also recommend a single quote over 
double, to prevent any other translation that bash might do.

The example in ftrace.txt should be:

 # echo 'hrtimer_*' > /debug/tracing/set_ftrace_filter


Thanks,

-- Steve

/me goes back to eating turkeys.
