Return-Path: <linux-kernel-owner+w=401wt.eu-S1751700AbXFCScT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700AbXFCScT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 14:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbXFCScL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 14:32:11 -0400
Received: from earth.simplelists.com ([81.3.86.41]:2507 "EHLO
	earth.simplelists.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbXFCScK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 14:32:10 -0400
Subject: Re: [PATCH 1/2] xt_connlimit (kernel) - connection limiting
From: Andrew Beverley <andy@andybev.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Netfilter Developer Mailing List 
	<netfilter-devel@lists.netfilter.org>,
       Netfilter Mailing List <netfilter@lists.netfilter.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0706031914120.10578@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0706031248290.10578@yvahk01.tjqt.qr>
	 <Pine.LNX.4.61.0706031312450.10578@yvahk01.tjqt.qr>
	 <1180890022.6601.6.camel@andybev>
	 <Pine.LNX.4.61.0706031914120.10578@yvahk01.tjqt.qr>
Content-Type: text/plain
Date: Sun, 03 Jun 2007 19:32:06 +0100
Message-Id: <1180895526.6601.44.camel@andybev>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-06-03 at 19:18 +0200, Jan Engelhardt wrote:
> On Jun 3 2007 18:00, Andrew Beverley wrote:
> >On Sun, 2007-06-03 at 13:12 +0200, Jan Engelhardt wrote:
> >> Adds the connlimit match that has been in POM-NG for a long time.
> >> 
> >>     *	works with 2.6.22, xtables'ified and all that
> >> 
> >>     *	will request nf_conntrack_ipv4 upon load
> >> 	(otherwise it hotdrops every packet - a glitch that goes back
> >> 	to at least 2.6.20.2)
> >
> >Excellent! This has been at the back of my mind for a while.
> >
> >Is there any chance of getting UDP flows added as well as TCP
> >connections?
> 
> I dare to say it's easy. The real problem is rather, that UDP is
> connectionless, so for one, connlimit can, by definition of the word
> 'connectionless', not apply to UDP, though it is technically
> possible.

Understood.

> Second, because UDP "connections" "fly" (timeout after 30
> seconds), just spewing one UDP packet out may kill another connection
> (e.g. if you use connlimit in conjunction with DROP or REJECT).

I see what you mean, although I personally would use this with an IPSET
target, and I would argue it is the responsibility of the administrator
to ensure it is used correctly.

> What's more, UDP packets can be easily forged, much more than TCP, so
> anyone on the same subtree (not subnet, because that's something
> different) can send a bogus UDP packet and stop your connections from
> working.

I didn't know that, but I doubt anyone where I would use it would be
able to do that :-)

> Let's see how to implement UDP counting...

The alternative, as I see it, is to adapt hashlimit to have an option to
limit by number of different concurrent streams to different port
numbers (but same source/destination IP address). However, I personally
think it would sit better in connlimit, even if UDP is not a connection
by strict definition.

Is it something you would consider, or shall I look at it myself?

With regards to Patrick's comment, IIRC this was one of the points he
originally raised.

Regards,

Andy Beverley


