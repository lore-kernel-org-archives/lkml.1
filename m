Return-Path: <linux-kernel-owner+w=401wt.eu-S1756911AbZAYMDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911AbZAYMDb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 07:03:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752912AbZAYMDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 07:03:22 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:38827 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753006AbZAYMDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 07:03:21 -0500
Date: Sun, 25 Jan 2009 23:03:19 +1100
From: Bron Gondwana <brong@fastmail.fm>
To: Greg KH <gregkh@suse.de>
Cc: Bron Gondwana <brong@fastmail.fm>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>
Subject: Re: [patch 016/104] epoll: introduce resource usage limits
Message-ID: <20090125120319.GA13869@brong.net>
References: <20081203193901.715896543@mini.kroah.org> <20081203194849.GQ8950@kroah.com> <1232686261.9977.1296303473@webmail.messagingengine.com> <20090123051620.GA8122@suse.de> <1232704065.25510.1296328851@webmail.messagingengine.com> <20090123170631.GB11566@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090123170631.GB11566@suse.de>
Organization: brong.net
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2009 at 09:06:31AM -0800, Greg KH wrote:
> On Fri, Jan 23, 2009 at 08:47:45PM +1100, Bron Gondwana wrote:
> > 1) is this value ever supposed to be hit in practice by non-malicious
> >    software?  If not, it appears 128 is too low.
> 
> It does appear a bit low.  What looks to you like a good value to use as
> a default?

I've upgraded one production mx to 2.6.28.2 plus my latest patch (the
rest are still running 2.6.27.6, which is prior to this limit)

Here's some figures with my latest patch after about 10 minutes running
to stabilise the startup figures:

kvm virtual mx:
0	39	0	230	4096	271872
production mx:
0	207	107	1811	4096	266555

The interesting figure in each case is the second one,
num_user_instances.  Interesting that the UID is listed as 0 though,
that's root!  107 is postfix, which makes sense.

As you can see, the production mx would have start choking epolls almost
immediately.  These machines are about 5 years old now.  4Gb of memory,
dual hyperthreading 32 bit Xeons.  They're the least powerful machines
we still keep running!

Bron ( most of our costs are power and rack space, after all )
