Return-Path: <linux-kernel-owner+w=401wt.eu-S1755046AbZFDQ5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046AbZFDQ5k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 12:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbZFDQ5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 12:57:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:53427 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbZFDQ5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 12:57:32 -0400
Date: Thu, 4 Jun 2009 12:57:33 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Philipp Reh <sefi@s-e-f-i.de>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: When does Linux drop UDP packets?
In-Reply-To: <alpine.DEB.2.00.0906041228170.14994@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.0906041257000.14994@gandalf.stny.rr.com>
References: <20090604145347.GA27692@miyuki> <20090604155741.GA8999@goodmis.org> <20090604161015.GA17303@miyuki> <alpine.DEB.2.00.0906041222450.14994@gandalf.stny.rr.com> <alpine.DEB.2.00.0906041228170.14994@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 4 Jun 2009, Steven Rostedt wrote:

> 
> Oh, btw, you don't need to strip LKML from replys (or any Cc), unless it 
> is off topic.  LKML is a public forum, and as long as things are on topic, 
> it is nice to show others the solutions that are found.
> 
> > 
> > On Thu, 4 Jun 2009, Philipp Reh wrote:
> > 
> > > I'm not really sure it is dropped but tcpdump sees the packet and
> > > recvfrom doesn't see it, so I think that the kernel might drop it
> > > somewhere when processing the IP stack logic.
> > 
> > Looking at the udp stack, selinux plays a role, and looks like it will 
> > drop a packet if it is not in the routing table.
> > 
> > Try:
> > 
> > # setenforce 0
> > 
> > and see if you start seeing packets.
> 
> BTW, I used ftrace to look into this:
> 
> Enable:
> 
> 	CONFIG_FTRACE
> 	CONFIG_FUNCTION_TRACER
> 	CONFIG_FUNCITON_GRAPH_TRACER
> 	CONFIG_DYNAMIC_FTRACE
> 
> Compile and boot:
> 
> # mount -t debugfs nodev /sys/kernel/debug
> # cd /sys/kernel/debug
> # echo udp_rcv > set_graph_function
> # echo function_graph > current_tracer
> # cat trace
> 

Could you do the above and send me (off list) the output of the trace?

-- Steve

