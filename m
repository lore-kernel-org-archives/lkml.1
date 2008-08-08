Return-Path: <linux-kernel-owner+w=401wt.eu-S1757152AbYHHMIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152AbYHHMIP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 08:08:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755445AbYHHMH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 08:07:59 -0400
Received: from relay1.sgi.com ([192.48.171.29]:51196 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753636AbYHHMH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 08:07:58 -0400
Date: Fri, 8 Aug 2008 07:08:13 -0500
From: Cliff Wickman <cpw@sgi.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, Keith Owens <kaos@ocs.com.au>,
       Jay Lan <jlan@sgi.com>, Christoph Lameter <cl@linux-foundation.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>, jmerkey@wolfmountaingroup.com,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
       Takenori Nagano <t-nagano@ah.jp.nec.com>,
       Bernhard Walle <bwalle@suse.de>
Subject: Re: [ANNOUNCE] Merkey's Kernel Debugger
Message-ID: <20080808120813.GA17364@sgi.com>
References: <20080807200659.GJ24801@one.firstfloor.org> <23175.1218148134@ocs10w> <20080808011500.GA531@redhat.com> <20080808022916.GM24801@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080808022916.GM24801@one.firstfloor.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2008 at 04:29:16AM +0200, Andi Kleen wrote:
> > panic() is the only place where kdump gets a chance to run first and
> > panic notifiers are not executed.
> 
> To be fully clear panic() that is called outside oops/exception context
> 
> s/panic/die notifiers/
> 
> > 
> > To me so far only in kernel debugger seems to be a reasonable candiate
> 
> Yes a kernel debugger should be able to hook into panic()
> 
> In fact it can do that already by just setting a break point,
> but clearly having a real notifier is preferable.
> 
> The use case would be then that the kernel debugger would
> have some command to trigger a dump.
> 
> > which needs to run before kdump after a panic event. If a debugger
> > is really getting merged into the kernel, then I think debugger can
> 
> kgdb is already merged. Also the x86 notifiers are general
> enough that there are a couple of debuggers floating around
> that are just using existing interfaces (as in need very little in terms
> of core patching) 
> 
> > put a hook in the panic() before kdump. Wouldn't this solve the problem?
> 
> Yes it would, but right now there is no such hook. Also if there 
> was such a hook kdump could use it like everyone else.  

Agree.
And here is another example of the need for such a hook:

In a partitioned system [I work for SGI, so I'm talking about an Altix],
there is memory sharing among multiple single-system images. And if
one of those partitions were to panic the other partitions need to
be informed that they cannot address the panic'd partition's memory.
(Once that partition is rebooted any such access will cause an MCA
in the accessor.)

So the cross-partition driver (xpc) needs to run a callback there, too.
It seems to me, as Keith has voiced, that it should be the user's choice
to run something there.

> There's a priority scheme in notifiers so you can still run usually last.
> 
> -Andi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Cliff Wickman
Silicon Graphics, Inc.
cpw@sgi.com
(651) 683-3824
