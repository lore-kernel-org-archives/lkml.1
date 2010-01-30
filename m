Return-Path: <linux-kernel-owner+w=401wt.eu-S1751070Ab0A3Uru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751070Ab0A3Uru (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 15:47:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754316Ab0A3Urq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 15:47:46 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:47370 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886Ab0A3Urm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 15:47:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sXn+b5ix6TE/3BTyRXykfDLUg03O9P/J79YjnUuCBalfH7KueI+wg8ZtVAK/Hzxasd
         wcJcypNzDjlaH/6qk/K+sWfJMPLV6mDlgzfUHOUSr6PtiZXm7aJj7mM486dIAj28r8UU
         38hayU8khkLXonc67b6AQ+wfhflfFNGP/8Krg=
Date: Sat, 30 Jan 2010 21:47:38 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [RFC PATCH 05/10] ftrace: Drop buffer check in function
	profiler callbacks
Message-ID: <20100130204737.GF5675@nowhere>
References: <1264122982-1553-1-git-send-regression-fweisbec@gmail.com> <1264122982-1553-6-git-send-regression-fweisbec@gmail.com> <4B5D3779.2040807@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B5D3779.2040807@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 25, 2010 at 02:17:29PM +0800, Lai Jiangshan wrote:
> Frederic Weisbecker wrote:
> > Drop the null check on hlist->hash. It is wasteful because
> > we don't register the tracer if the buffer allocation failed,
> > and the memory barrier in register_ftrace_graph() ensure it
> > is visible to the callbacks right away.
> > 
> 
> When it is on a cpu which is just came up, hlist->hash is not
> allocated either.
> 
> See ftrace_profile_init().
> 
> function_profile_call(), profile_graph_entry() and profile_graph_return()
> on a just online cpu are wasteful. I think we need call
> ftrace_profile_init_cpu()(if ftrace_profile_enabled=1) when CPU_UP_PREPARE.



May be yeah, or perhaps we should play with cpu_possible_mask()
instead of cpu_online. Whatever, the patch is also buggy for the reasons
given by Steve, I'm going to drop it until we have a sane implementation
of synchronize_preempted_tasks().

