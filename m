Return-Path: <linux-kernel-owner+w=401wt.eu-S1754574AbZGUBvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574AbZGUBvr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 21:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754543AbZGUBvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 21:51:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:56598 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754369AbZGUBvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 21:51:46 -0400
Date: Mon, 20 Jul 2009 21:51:46 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Johannes Berg <johannes@sipsolutions.net>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: binary ftrace buffer format
In-Reply-To: <1247520189.4071.4.camel@johannes.local>
Message-ID: <alpine.DEB.2.00.0907202148140.11494@gandalf.stny.rr.com>
References: <1247520189.4071.4.camel@johannes.local>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 13 Jul 2009, Johannes Berg wrote:

> Hi!
> 
> For the past hour or so I've been trying to make Steven's rb-read.pl
> script [1] work, but not only is it endian-challenged, working only on
> LE, but also does it seems to have a different idea of the ring buffer
> format, so even with fixes I can't get it to print proper data.
> 
> I'm convinced that it would be trivial to write a program to parse the
> binary trace buffer, but I can't find a format description. Can somebody
> point me to one please?

I have a tool called trace-cmd (I'm looking into porting it to the perf 
tool) but it currently does what you want. I've tested it on both 32 bit 
and 64 bit systems as well as big and little endians. The files can be 
created on one system and read on another. It contains data in the files 
to let other systems know how to read it.

You can get the tool here:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git

> 
> Oh and a tangential question -- that thing seems to work on pages, does
> that mean I can't trace something larger than a page?

Currently, we have not the need to trace more than a page. But this is 
something that can be changed in the future, but currently we have not had 
the need, and when it was developed, Linus suggested pages would be fine.

-- Steve


> 
> johannes
> 
> [1] http://lwn.net/Articles/321777/
> 
