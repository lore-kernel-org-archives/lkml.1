Return-Path: <linux-kernel-owner+w=401wt.eu-S1753818AbZIUBqK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818AbZIUBqK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 21:46:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751577AbZIUBqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 21:46:09 -0400
Received: from mail.vyatta.com ([76.74.103.46]:50075 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002AbZIUBqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 21:46:08 -0400
Date: Sun, 20 Sep 2009 18:46:06 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Mike McCormack <mikem@ring3k.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Grozdan <neutrino8@gmail.com>,
       linux-kernel@vger.kernel.org,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       netdev@vger.kernel.org
Subject: Re: sky2 rx length errors
Message-ID: <20090920184606.5a75aba6@nehalam>
In-Reply-To: <392fb48f0909201511h34c71e0au838b52c413d517e0@mail.gmail.com>
References: <c5bd819b0909180641n7c353b80tc15b9c9fe02d5c95@mail.gmail.com>
	<20090919233536.f5fb700c.akpm@linux-foundation.org>
	<20090920110527.39fd7af5@s6510>
	<392fb48f0909201511h34c71e0au838b52c413d517e0@mail.gmail.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Sep 2009 07:11:21 +0900
Mike McCormack <mikem@ring3k.org> wrote:

> 2009/9/21 Stephen Hemminger <shemminger@vyatta.com>
> 
> > On Sat, 19 Sep 2009 23:35:36 -0700
> > Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > > (added cc's from the MAINTAINERS file)
> > >
> > > On Fri, 18 Sep 2009 15:41:45 +0200 Grozdan <neutrino8@gmail.com> wrote:
> >
> 
> <snip>
> 
> > > martian destination 0.0.0.0 from 172.23.204.1, dev eth0
> > > > sky2 eth0: rx length error: status 0x4420100 length 598
> > > > sky2 eth0: rx length error: status 0x5ea0100 length 598
> >
> > This error status occurs if the length reported by the PHY does not
> > match the len reported by the DMA engine.  The error status is:
> >   0x4420100 = length 1090 + broadcast packet...
> >
> > No idea what is on your network, but perhaps there is some MTU confusion?
> > Since martian destination seems related, knowing more about that packet
> > might help.
> >
> >
> This appears to be the same problem reported at:
> 
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/292445
> 
> Mike

This really looks like multiple packets are getting smashed
together into one DMA, i.e a hardware timing related issue.
it might be possible to work around the problem
by separating them.

-- 
