Return-Path: <linux-kernel-owner+w=401wt.eu-S1761072AbXGFLZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761072AbXGFLZT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 07:25:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755894AbXGFLZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 07:25:08 -0400
Received: from main.gmane.org ([80.91.229.2]:54409 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753783AbXGFLZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 07:25:07 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Brice Figureau <brice+lklm@daysofwonder.com>
Subject: Re: Understanding I/O behaviour
Date: Fri, 6 Jul 2007 10:15:52 +0000 (UTC)
Message-ID: <loom.20070706T120931-601@post.gmane.org>
References: <9a8748490707051653q6e1b6bf3g9a3d6edf213867d9@mail.gmail.com> <684951.37870.qm@web32606.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 213.41.185.138 (Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.3) Gecko/20070310 Iceweasel/2.0.0.3 (Debian-2.0.0.3-2))
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Knoblauch <spamtrap <at> knobisoft.de> writes:

> --- Jesper Juhl <jesper.juhl <at> gmail.com> wrote:
> 
> > On 06/07/07, Robert Hancock <hancockr <at> shaw.ca> wrote:
> > [snip]
> > >
> > > Try playing with reducing /proc/sys/vm/dirty_ratio and see how that
> > > helps. This workload will fill up memory with dirty data very
> > quickly,
> > > and it seems like system responsiveness often goes down the toilet
> > when
> > > this happens and the system is going crazy trying to write it all
> > out.
> > >
> > 
> > Perhaps trying out a different elevator would also be worthwhile.
> > 
> 
>  AS seems to be the best one (NOOP and DeadLine seem to be equally OK).
> CFQ gives less (about 10-15%) throughput except for the kernel with the
> cfs cpu scheduler, where CFQ is on par with the other IO schedulers.
> 

Please have a look to kernel bug #7372:
http://bugzilla.kernel.org/show_bug.cgi?id=7372

It seems I encountered the almost same issue.

The fix on my side, beside running 2.6.17 (which was working fine for me) was to:
 1) have /proc/sys/vm/vfs_cache_pressure=1
 2) have /proc/sys/vm/dirty_ratio=1 and /proc/sys/vm/dirty_background_ratio=1
 3) have /proc/sys/vm/swappiness=2
 4) run Peter Zijlstra: per dirty device throttling patch on the top of 2.6.21.5:
http://www.ussg.iu.edu/hypermail/linux/kernel/0706.1/2776.html

Hope that helps,
--
Brice Figureau

