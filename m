Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789Ab0BBSgi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 13:36:38 -0500
Received: from stinky.trash.net ([213.144.137.162]:35939 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756716Ab0BBSge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 13:36:34 -0500
Message-ID: <4B6870AF.6060109@trash.net>
Date: Tue, 02 Feb 2010 19:36:31 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Jon Masters <jonathan@jonmasters.org>
CC: Alexey Dobriyan <adobriyan@gmail.com>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>,
       netfilter-devel <netfilter-devel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] netfilter: per netns nf_conntrack_cachep
References: <1264813832.2793.446.camel@tonnant>	 <1265023437.2848.30.camel@edumazet-laptop>	 <1265035970.2848.50.camel@edumazet-laptop>	 <b6fcc0a1002010658j4f52a9b8kf10e4bb07a2f1075@mail.gmail.com>	 <1265036548.2848.55.camel@edumazet-laptop>	 <1265108690.2861.118.camel@tonnant> <1265110504.2861.135.camel@tonnant>	 <1265129192.2861.141.camel@tonnant> <4B685756.8010107@trash.net>	 <1265130426.2861.158.camel@tonnant>	 <b6fcc0a1002020958u17315624u4d54d06a413be6bb@mail.gmail.com> <1265134598.2861.191.camel@tonnant>
In-Reply-To: <1265134598.2861.191.camel@tonnant>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jon Masters wrote:
> On Tue, 2010-02-02 at 19:58 +0200, Alexey Dobriyan wrote:
> 
>> Yes, moving to init_net-only function is fine.
> 
> So moving the "setup up fake conntrack" bits to init_init_net from
> init_net still results in the panic, which means that the use count
> really is dropping to zero and we really are trying to free it when
> using multiple namespaces. Per ns is probably an easier way to go.

Agreed, that will also avoid problems in the future with the
ct_net pointer pointing to &init_net. I'll take care of this
tommorrow.
