Return-Path: <linux-kernel-owner+w=401wt.eu-S1755782AbYDTAyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782AbYDTAyU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 20:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754474AbYDTAyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 20:54:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60985
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753966AbYDTAyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 20:54:04 -0400
Date: Sat, 19 Apr 2008 17:54:05 -0700 (PDT)
Message-Id: <20080419.175405.91059921.davem@davemloft.net>
To: kaber@trash.net
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, netdev@vger.kernel.org,
       netfilter-devel@vger.kernel.org
Subject: Re: [bug] build failure in net/netfilter/nf_conntrack_sip.c, on
 latest -git
From: David Miller <davem@davemloft.net>
In-Reply-To: <480A2011.3080507@trash.net>
References: <20080419100034.GA9475@elte.hu>
	<20080419.030736.168169087.davem@davemloft.net>
	<480A2011.3080507@trash.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrick McHardy <kaber@trash.net>
Date: Sat, 19 Apr 2008 18:38:41 +0200

> David Miller wrote:
> > From: Ingo Molnar <mingo@elte.hu>
> > Date: Sat, 19 Apr 2008 12:00:35 +0200
> >
> > [ netfilter-devel and netdev added to CC: ]
> >
> >   
> >> randconfig testing found a netfilter build failure in latest -git:
> >>
> >>   net/netfilter/nf_conntrack_sip.c: In function 'set_expected_rtp_rtcp':
> >>   net/netfilter/nf_conntrack_sip.c:786: error: 'struct nf_conntrack_expect' has no member named 'saved_ip'
> >>
> >>   http://redhat.com/~mingo/misc/config-Sat_Apr_19_11_37_02_CEST_2008.bad
> >>
> >> disabling CONFIG_NF_CONNTRACK_SIP works it around.
> >>     
> >
> > I think this will fix it.
> >
> > Patrick, is this how we should do it?
> 
> No, the SIP helper is also useful without NAT. This patch adds
> an ifdef around the RTP call optimization for NATed clients.
> 
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Fair enough, applied, thanks Patrick.
