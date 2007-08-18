Return-Path: <linux-kernel-owner+w=401wt.eu-S1754134AbXHRFXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbXHRFXY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 01:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbXHRFXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 01:23:13 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:8301 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbXHRFXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 01:23:11 -0400
X-IronPort-AV: i="4.19,278,1183359600"; 
   d="scan'208"; a="202268040:sNHT47896587"
To: David Miller <davem@davemloft.net>
Cc: tom@opengridcomputing.com, jeff@garzik.org, swise@opengridcomputing.com,
       mshefty@ichips.intel.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: [ofa-general] Re: [PATCH RFC] RDMA/CMA: Allocate PS_TCP ports from the host TCP port space.
X-Message-Flag: Warning: May contain useful information
References: <adaodh6x7js.fsf@cisco.com>
	<20070817.142756.65194845.davem@davemloft.net>
	<adafy2hyc04.fsf@cisco.com>
	<20070817.170033.63993876.davem@davemloft.net>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 17 Aug 2007 22:23:01 -0700
In-Reply-To: <20070817.170033.63993876.davem@davemloft.net> (David Miller's message of "Fri, 17 Aug 2007 17:00:33 -0700 (PDT)")
Message-ID: <adatzqxwh56.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 18 Aug 2007 05:23:02.0054 (UTC) FILETIME=[D8E37C60:01C7E157]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > This is also a series of falsehoods.  All packet filtering,
 > queue management, and packet scheduling facilities work perfectly
 > fine and as designed with both LRO and TSO.

I'm not sure I follow.  Perhaps "broken" was too strong a word to use,
but if you pass a huge segment to a NIC with TSO, then you've given
the NIC control of scheduling the packets that end up getting put on
the wire.  If your software packet scheduling is operating at a bigger
scale, then things work fine, but I don't see how you can say that TSO
doesn't lead to head-of-line blocking etc at short time scales.  And
yes of course I agree you can make sure things work by using short
segments or not using TSO at all.

Similarly with LRO the packets that get passed to the stack are not
the packets that were actually on the wire.  Sure, most filtering will
work fine but eg are you sure your RTT estimates aren't going to get
screwed up and cause some subtle bug?  And I could trot out all the
same bugaboos that are brought up about RDMA and warn darkly about
security problems with bugs in NIC hardware that after all has to
parse and rewrite TCP and IP packets.

Also, looking at the complexity and bug-fixing effort that go into
making TSO work vs the really pretty small gain it gives also makes
part of me wonder whether the noble proclamations about
maintainability are always taken to heart.

Of course I know everything I just wrote is wrong because I forgot to
refer to the crucial axiom that stateless == good && RDMA == bad.
And sometimes it's unfortunate that in Linux when there's disagreement
about something, the default action is *not* to do something.

Sorry for prolonging this argument.  Dave, I should say that I
appreciate all the work you've done in helping build the most kick-ass
networking stack in history.  And as I said before, I have plenty of
interesting work to do however this turns out, so I'll try to leave
any further arguing to people who actually have a dog in this fight.

 - R.
