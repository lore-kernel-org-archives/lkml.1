Return-Path: <linux-kernel-owner+w=401wt.eu-S1756705AbZIKVFD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705AbZIKVFD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 17:05:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756696AbZIKVFC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 17:05:02 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:11060 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756695AbZIKVFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 17:05:00 -0400
Date: Fri, 11 Sep 2009 23:05:03 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Jesse Brandeburg <jesse.brandeburg@intel.com>
cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: bisect results of MSI-X related panic (help!)
In-Reply-To: <1252699744.3877.15.camel@jbrandeb-hc.jf.intel.com>
Message-ID: <alpine.LNX.2.00.0909112253180.31018@swampdragon.chaosbits.net>
References: <1252699744.3877.15.camel@jbrandeb-hc.jf.intel.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Sep 2009, Jesse Brandeburg wrote:

> I've been attempting to isolate a problem that we see on x86_64, when we
> have many (6 or more) MSI-X enabled LAN ports with 33 MSI-X vectors
> each.
>
> The system panics, but with almost random panic traces, usually
> somewhere around something to do with an interrupt. 2.6.29 is fine,
> 2.6.30-rc1 is not, and 2.6.31-rc8 fails as well.
>
> The test I am using to reproduce is
> rmmod ixgbe
> modprobe ixgbe
> ip l set ethX up (X = 1 8 9 10 11 12 13 14 15)
> run set_irq_affinity script (binds rx0/tx0 to cpu0, rx1/tx1 to cpu1, for
> each ethX)
> ping -f -c 5000 host
>
> I've bisected, here is my bisect log, problem is that the commit
> identified is a merge commit, and *I don't know what to revert to test*.
> It appears the parent of the merge:
> 6e15cf04860074ad032e88c306bea656bbdd0f22 is marked good, but looks to be
> in a possibly related area to the panic.
>
> Can someone please help me figure out what to do next?

I don't know if I can help, but I'll try. At least I can tell you what I'd 
do if I had no other input - perhaps it'll help you, perhaps not...

First thing I'd do would be to test with the final 2.6.31 and the latest 
git kernel. Who knows, if you're lucky it may already be fixed.

Second thing I'd do would be to try and cut down my .config to the bare 
minimum needed to boot and reproduce the bug on the box in question.
I'd do this for two reasons; 1) perhaps you'll discover that 
disabeling/enabeling a certain kernel option makes the problem go away. 
That would be useful info. 2) having a bare minimum .config makes it 
faster to re-build kernels when doing a bisect.

Third thing I'd do would be to re-do the bisect using the 2.6.31 (or 
latest git) kernel as the starting point. The new bisect will pick 
different patches as the test points and may lead to a better result (at 
least it sometimes has for me).

Fourth thing I'd do (assuming the above did not produce anything useful) 
would be to take my minimal config and enable every single debug option 
(no matter how irrelevant it seemed) I could on top of it, and hope that 
one of them would catch something that would help me identify the problem.

If all of the above failed to produce any clue I'd ask for help on the 
mailing lists :)   Sorry, but that's all I can think of.  Hope it helps.


-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

