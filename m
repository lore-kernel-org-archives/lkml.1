Return-Path: <linux-kernel-owner+w=401wt.eu-S1761896AbYDSLL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761896AbYDSLL3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 07:11:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754050AbYDSLLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 07:11:19 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53273
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753757AbYDSLLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 07:11:18 -0400
Date: Sat, 19 Apr 2008 04:11:19 -0700 (PDT)
Message-Id: <20080419.041119.143183732.davem@davemloft.net>
To: jengelh@computergmbh.de
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, kaber@trash.net,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [bug] build failure in net/netfilter/nf_conntrack_sip.c, on
 latest -git
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.1.10.0804191243170.26385@fbirervta.pbzchgretzou.qr>
References: <20080419100034.GA9475@elte.hu>
	<20080419.030736.168169087.davem@davemloft.net>
	<alpine.LNX.1.10.0804191243170.26385@fbirervta.pbzchgretzou.qr>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Engelhardt <jengelh@computergmbh.de>
Date: Sat, 19 Apr 2008 12:44:53 +0200 (CEST)

> 
> On Saturday 2008-04-19 12:07, David Miller wrote:
> >Patrick, is this how we should do it?
> >
> > config NF_CONNTRACK_SIP
> > 	tristate "SIP protocol support"
> >-	depends on NF_CONNTRACK
> >+	depends on NF_CONNTRACK && NF_NAT
> > 	default m if NETFILTER_ADVANCED=n
> 
> Not really. One may want to run a system without NAT,
> but still with connection tracking (for firewalling) -- think IPv6.

But SIP needs the NAT layer in order to get at those
expectation structure members.

What is your alternative fix suggestion then?
