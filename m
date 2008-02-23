Return-Path: <linux-kernel-owner+w=401wt.eu-S1760975AbYBWSXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760975AbYBWSXA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 13:23:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754550AbYBWSWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 13:22:50 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:44862 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752709AbYBWSWs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 13:22:48 -0500
Date: Sat, 23 Feb 2008 10:21:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?B?IklscG8gSuRydmluZW4i?= <ilpo.jarvinen@helsinki.fi>
Cc: Netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [RFC PATCH 8/8] Jhash in too big for inlining, move under lib/
Message-Id: <20080223102159.74a465cb.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0802231006360.29504@kivilampi-30.cs.helsinki.fi>
References: <1203515238-22848-1-git-send-email-ilpo.jarvinen@helsinki.fi>
	<1203515238-22848-2-git-send-email-ilpo.jarvinen@helsinki.fi>
	<1203515238-22848-3-git-send-email-ilpo.jarvinen@helsinki.fi>
	<1203515238-22848-4-git-send-email-ilpo.jarvinen@helsinki.fi>
	<1203515238-22848-5-git-send-email-ilpo.jarvinen@helsinki.fi>
	<1203515238-22848-6-git-send-email-ilpo.jarvinen@helsinki.fi>
	<1203515238-22848-7-git-send-email-ilpo.jarvinen@helsinki.fi>
	<1203515238-22848-8-git-send-email-ilpo.jarvinen@helsinki.fi>
	<1203515238-22848-9-git-send-email-ilpo.jarvinen@helsinki.fi>
	<20080223000214.81b1390a.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0802231006360.29504@kivilampi-30.cs.helsinki.fi>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Feb 2008 12:05:36 +0200 (EET) "Ilpo Järvinen" <ilpo.jarvinen@helsinki.fi> wrote:

> On Sat, 23 Feb 2008, Andrew Morton wrote:
> 
> > On Wed, 20 Feb 2008 15:47:18 +0200 "Ilpo Järvinen" <ilpo.jarvinen@helsinki.fi> wrote:
> > 
> > > vmlinux.o:
> > >  62 functions changed, 66 bytes added, 10935 bytes removed, diff: -10869
> > > 
> > > ...+ these to lib/jhash.o:
> > >  jhash_3words: 112
> > >  jhash2: 276
> > >  jhash: 475
> > > 
> > > select for networking code might need a more fine-grained approach.
> > 
> > It should be possible to use a modular jhash.ko.  The things which you
> > have identified as clients of the jhash library are usually loaded as modules.
> > But in the case where someone does (say) NFSD=y we do need jhash.o linked into
> > vmlinux also. This is doable in Kconfig but I always forget how.
> 
> Ok, even though its not that likely that one lives without e.g.
> net/ipv4/inet_connection_sock.c or net/netlink/af_netlink.c?

Sure, the number of people who will want CONFIG_JHASH=n is very small.

> But maybe 
> some guys "really know what they are doing" and can come up with config 
> that would be able to build it as module (for other than proof-of-concept 
> uses I mean)... :-/
> 
> > Adrian, Sam and Randy are the repositories of knowledge here ;)
> 
> Thanks, I'll consult them in this. I've never needed to do any Kconfig 
> stuff so far so it's no surprise I have very little clue... :-)

Thanks.  If it gets messy I'd just put lib/jhash.o in obj-y.  I assume it's
pretty small.

> I've one question for you Andrew, how would you like this kind of 
> cross-subsys toucher to be merged, through you directly I suppose?

Sure, I can scrounge around for appropriate reviews and acks and can make
sure that nobody's pending work gets disrupted.

