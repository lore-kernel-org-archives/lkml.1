Return-Path: <linux-kernel-owner+w=401wt.eu-S1761248AbYDXQNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761248AbYDXQNt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 12:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754203AbYDXQNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 12:13:41 -0400
Received: from tomts22.bellnexxia.net ([209.226.175.184]:47429 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754013AbYDXQNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 12:13:40 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArEEAGtOEEhMROPA/2dsb2JhbACBUqte
Date: Thu, 24 Apr 2008 12:13:37 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [patch 37/37] LTTng instrumentation net
Message-ID: <20080424161337.GA22874@Krystal>
References: <20080424150324.802695381@polymtl.ca> <20080424151408.991424268@polymtl.ca> <4810ACB4.501@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <4810ACB4.501@openvz.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:09:42 up 55 days, 12:20,  6 users,  load average: 0.72, 1.04,
	1.24
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pavel Emelyanov (xemul@openvz.org) wrote:
> Mathieu Desnoyers wrote:
> > Network core events.
> > 
> > Added markers :
> > 
> > net_del_ifa_ipv4
> > net_dev_receive
> > net_dev_xmit
> > net_insert_ifa_ipv4
> > net_socket_call
> > net_socket_create
> > net_socket_recvmsg
> > net_socket_sendmsg
> 
> Network "core" events are not limited with the above calls.
> 

True. This is by no mean an exhaustive list of network events. It just
happens to be the ones which has been useful to LTT/LTTng users for the
past ~10 years.

> Besides, real "core" events already sent notifications about themselves.
> Why do we need additional hooks?
> 

I doubt the current notification hooks have a performance impact as
small as the proposed markers. Which notification mechanism do you refer
to ? It could be interesting to put markers in there instead.

The goal behind this is to feed information to a general purpose tracer
like lttng, a scripting mechanism like systemtap or a special-purpose
tracer like ftrace.

I think that the most important instrumentation in this patchset is the
xmit/recv of a packet at the device level. The net_socket_*
instrumentation could eventually be replaced by an architecture specfic
system call parameters instrumentation.

Mathieu

> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > CC: netdev@vger.kernel.org
> > ---
> >  net/core/dev.c     |    6 ++++++
> >  net/ipv4/devinet.c |    6 ++++++
> >  net/socket.c       |   19 +++++++++++++++++++
> >  3 files changed, 31 insertions(+)
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
