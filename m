Return-Path: <linux-kernel-owner+w=401wt.eu-S1752241AbXCLXVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241AbXCLXVp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 19:21:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbXCLXVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 19:21:45 -0400
Received: from MAIL.13thfloor.at ([213.145.232.33]:39273 "EHLO
	MAIL.13thfloor.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbXCLXVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 19:21:44 -0400
Date: Tue, 13 Mar 2007 00:21:43 +0100
From: Herbert Poetzl <herbert@13thfloor.at>
To: Paul Menage <menage@google.com>
Cc: Paul Jackson <pj@sgi.com>, ebiederm@xmission.com, matthltc@us.ibm.com,
       ckrm-tech@lists.sourceforge.net, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       winget@google.com, xemul@sw.ru
Subject: Re: [ckrm-tech] [PATCH 0/2] resource control file system - aka containers on top of nsproxy!
Message-ID: <20070312232143.GC6832@MAIL.13thfloor.at>
Mail-Followup-To: Paul Menage <menage@google.com>,
	Paul Jackson <pj@sgi.com>, ebiederm@xmission.com,
	matthltc@us.ibm.com, ckrm-tech@lists.sourceforge.net,
	containers@lists.osdl.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, winget@google.com, xemul@sw.ru
References: <6599ad830703071658q60466dd8hd18a1eab9bc17535@mail.gmail.com> <45EF793C.1000700@vilain.net> <6599ad830703071857yf711921ja3440c4276bbe58e@mail.gmail.com> <45EF83CB.9080903@vilain.net> <1173334209.13172.61.camel@localhost.localdomain> <m11wk08c9h.fsf@ebiederm.dsl.xmission.com> <20070309010628.GE4506@MAIL.13thfloor.at> <45F27503.1020108@vilain.net> <20070311141555.9951b7ba.pj@sgi.com> <6599ad830703120300x63ca5732wfe865f76cb5125a9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830703120300x63ca5732wfe865f76cb5125a9@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2007 at 03:00:25AM -0700, Paul Menage wrote:
> On 3/11/07, Paul Jackson <pj@sgi.com> wrote:
> >
> > My current understanding of Paul Menage's container patch is that it is
> > a useful improvement for some of the metered classes - those that could
> > make good use of a file system like hierarchy for their interface.
> > It probably doesn't benefit all metered classes, as they won't all
> > benefit from a file system like hierarchy, or even have a formal name
> > space, and it doesn't seem to benefit the name space implementation,
> > which happily remains flat.
> 
> Well, what I was aiming at was a generic mechanism that can handle
> "namespaces", "metered classes" and other ways of providing
> per-task-group behaviour. So a system-call API doesn't necessarily
> have the right flexibility to implement the possible different kinds
> of subsystems I envisage.
> 
> For example, one way to easily tie groups of processes to different
> network queues is to have a tag associated with a container, allow
> that to propagate to the socket/skbuf priority field, and then use
> standard Linux traffic control to pick the appropriate outgoing queue
> based on the skbuf's tag.
> 
> This isn't really a namespace, and it isn't really a "metered class".
> It's just a way of associating a piece of data (the network tag) with
> a group of processes.
> 
> With a filesystem-based interface, it's easy to have a file as the
> method of reading/writing the tag; with a system call interface, then
> either the interface is sufficiently generic to allow this kind of
> data association (in which case you're sort of implementing a
> filesystem in the system call) or else you have to shoehorn into an
> unrelated API (e.g. if your system call talks about "resource limits"
> you might end up having to specify the network tag as a "maximum
> limit" since there's no other useful configuration data available).
> 
> As another example, I'd like to have a subsystem that shows me all the
> sockets that processes in the container have opened; again, easy to do
> in a filesystem interface, but hard to fit into a
> resource-meteting-centric or namespace-centric system call API.

why? you simply enter that specific space and
use the existing mechanisms (netlink, proc, whatever)
to retrieve the information with _existing_ tools,
no need to do anything unusual via the syscall API

and if you support a 'spectator' context or capability
(which allows to see the _whole_ truth) you can also
get this information for _all_ sockets with existing
tools like netstat or lsof ...

best,
Herbert

> Paul
> _______________________________________________
> Containers mailing list
> Containers@lists.osdl.org
> https://lists.osdl.org/mailman/listinfo/containers
