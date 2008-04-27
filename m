Return-Path: <linux-kernel-owner+w=401wt.eu-S1761489AbYD0Aox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761489AbYD0Aox (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 20:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753741AbYD0Aoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 20:44:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53090 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752800AbYD0Aop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 20:44:45 -0400
Date: Sat, 26 Apr 2008 17:36:45 -0700
From: Greg KH <gregkh@suse.de>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: ftrace and debugfs weird interaction
Message-ID: <20080427003645.GA19827@suse.de>
References: <20080426185403.GA22522@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080426185403.GA22522@Krystal>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2008 at 02:54:03PM -0400, Mathieu Desnoyers wrote:
> Hi,
> 
> When trying to figure out what was going on with the sched tracer
> "tracing_enabled" file (sched-devel.git tree), I fell on this strange
> behavior :
> 
> echo 1>tracing_enabled seems _not_ to send 1 to the tracing_ctrl_write
> callback. However, sending garbage, e.g. echo s> tracing_enabled,
> correctly sends the 's' character down the chain. echo 0>tracing_enabled
> sometimes results in the callback not even being called.
> 
> The debugfs file has been created with
> 
>         entry = debugfs_create_file("tracing_enabled", 0644, d_tracer,
>                                     &global_trace, &tracing_ctrl_fops);
>         if (!entry)
>                 pr_warning("Could not create debugfs 'tracing_enabled' entry\n");
> 
> I wonder what kind of weird debugfs interaction we might have here ?

I don't know.  Are you sure your _fops is not getting called at all?

How about using a "default" operation for such a simple file, like
debugfs_create_bool() as that is all you care about for this kind of
value?

That should save you some code at the very least :)

thanks,

greg k-h
