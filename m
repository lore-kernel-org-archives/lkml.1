Return-Path: <linux-kernel-owner+w=401wt.eu-S932634AbYB1Vbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634AbYB1Vbs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 16:31:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932270AbYB1VbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 16:31:23 -0500
Received: from smtp116.sbc.mail.re3.yahoo.com ([66.196.96.89]:26321 "HELO
	smtp116.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932531AbYB1VbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 16:31:20 -0500
X-YMail-OSG: jnodukEVM1nAWv2mPSM1k3R03hJFkD899KgnNqGSw0R8X9AYrrFrpdUklOlWDAB9sG7MVf0n1o6kf0alwgASlDkyPk9J9KdZSVzoPFgFfeP3RcTiPrzmK4DTcrogIVpYfQOLUOhvI1ObBFM-
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 28 Feb 2008 15:28:35 -0600
From: serge@hallyn.com
To: Paul Menage <menage@google.com>
Cc: Linux Containers <containers@lists.osdl.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pavel Emelianov <xemul@openvz.org>, Paul Jackson <pj@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] Prefixing cgroup generic control filenames with "cgroup."
Message-ID: <20080228212835.GB1232@vino.hallyn.com>
References: <6599ad830802281314s25c033d6tc021725ae28aef8d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830802281314s25c033d6tc021725ae28aef8d@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Paul Menage (menage@google.com):
> All control files created by cgroup subsystems are given a prefix
> corresponding to their subsystem name. But control files provided by
> cgroups itself have no prefix. Currently that set of files is just
> "tasks", "notify_on_release" and "release_agent", but that set is
> likely to expand in the future. To reduce the risk of clashes, it
> would make sense to prefix these files and any future ones with the
> "cgroup." prefix.
> 
> The only reason that I can see *not* to do this would be for
> compatibility with 2.6.24. Do people think this is a strong enough
> reason to leave the existing names? If distros are planning to ship
> products based on 2.6.24, presumably they'd be adding their own
> patches anyway, so they could add a trivial prefix change patch too.
> (I realise this discussion would have been more useful *before* 2.6.24
> shipped, but I didn't quite get round to it ...)
> 
> A compromise might be to keep "tasks" unprefixed, and say that future
> names get the "cgroup." prefix; in this case I'd be inclined to add
> the prefix to notify_on_release and release_agent on the grounds that
> there's much less chance of breaking anyone with those files since (I
> suspect) they're much less used.
> 
> Note that if you mount a cgroup filesystem with the "noprefix" option,
> which is what the cpuset filesystem wrapper does, no subsystems have
> prefixes, and in this case the "cgroup." prefix wouldn't be used
> either. So this doesn't affect any users that explicitly mount cpusets
> rather than cgroups.
> 
> Thoughts?

To me it seems quite logical that files belonging to the cgroup
subsystem would have no prefix, and I don't see any good reason to
do so.

-serge
