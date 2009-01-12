Return-Path: <linux-kernel-owner+w=401wt.eu-S1755047AbZALVmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047AbZALVmk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 16:42:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbZALVmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 16:42:32 -0500
Received: from tservice.net.ru ([195.178.208.66]:43419 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016AbZALVmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 16:42:31 -0500
Date: Tue, 13 Jan 2009 00:42:29 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Chris Snook <csnook@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Dave Jones <davej@redhat.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux killed Kenny, bastard!
Message-ID: <20090112214229.GB20485@ioremap.net>
References: <20090112153304.GA19995@ioremap.net> <20090112154456.GA27269@redhat.com> <20090112154827.GB20743@ioremap.net> <20090112155108.2646b3ae@lxorguk.ukuu.org.uk> <20090112155211.GA21161@ioremap.net> <496BB626.9090208@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496BB626.9090208@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 04:29:10PM -0500, Chris Snook (csnook@redhat.com) wrote:
> >Modulo the fact that it does not work for the quickly created processes
> >which do not have their oom scores adjusted before the oom.
> 
> cgroups solve this problem much more cleanly.

When they are configured and enabled :)
And actually not, since having two separate groups still may result in
the wrong oom-killing, the same group should contain all potentially
'bad' processes, so that it could be triggered first and not the whole
scan.

Having a name to kill is way too simpler than anything else, and while
this may be not the finest grain solution, it is what is the most
obvious and the simplest to work with.

I do agree, that there are ways to solve the same problem, and likely
they provide better control, but setup/control cost is uncomparable with
simple name-based scheme to select 'victim' processes by their scores.

Effectively it is similar to oom_kill_allocating_task trick, which also
can be solved by adjusting oom-score for every other process in the
system or by putting it into the separate group, or anything else.
But still it is much simpler to have a single flag which solves the
problem maybe not optimally, but close to it in the most cases.

The same does my patch, which allows to select a set of processes by the
given string in the executable name, and then get a victim among them
based on the existing scores. This is the simplest and thus it could be
the most useful case.

-- 
	Evgeniy Polyakov
