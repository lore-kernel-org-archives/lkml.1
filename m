Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab0BBLFM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 06:05:12 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:60677 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827Ab0BBLFK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 06:05:10 -0500
Subject: Re: [PATCH] netfilter: per netns nf_conntrack_cachep
From: Jon Masters <jonathan@jonmasters.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Patrick McHardy <kaber@trash.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>,
       netfilter-devel <netfilter-devel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1265036548.2848.55.camel@edumazet-laptop>
References: <1264813832.2793.446.camel@tonnant>
	 <1264816634.2793.505.camel@tonnant> <1264816777.2793.510.camel@tonnant>
	 <1264834704.2919.3.camel@edumazet-laptop>
	 <1265016745.7499.144.camel@tonnant>
	 <b6fcc0a1002010136k7e78a998p31a9e7464c2e8d44@mail.gmail.com>
	 <1265019160.2848.14.camel@edumazet-laptop>
	 <b6fcc0a1002010225u4e74f9f0q633d73038234dc37@mail.gmail.com>
	 <1265023437.2848.30.camel@edumazet-laptop>
	 <1265035970.2848.50.camel@edumazet-laptop>
	 <b6fcc0a1002010658j4f52a9b8kf10e4bb07a2f1075@mail.gmail.com>
	 <1265036548.2848.55.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Organization: World Organi[sz]ation of Broken Dreams
Date: Tue, 02 Feb 2010 06:04:50 -0500
Message-Id: <1265108690.2861.118.camel@tonnant>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8BIT
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-01 at 16:02 +0100, Eric Dumazet wrote:
> Le lundi 01 février 2010 à 16:58 +0200, Alexey Dobriyan a écrit :
> > On Mon, Feb 1, 2010 at 4:52 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > > +       net->ct.nf_conntrack_cachep = kmem_cache_create("nf_conntrack",
> > > +                                                       sizeof(struct nf_conn), 0,
> > > +                                                       SLAB_DESTROY_BY_RCU, NULL);
> > 
> > Duplicate slab name detected.
> > 
> 
> OK, need to build an unique name I guess... "nf_conntrack-%d", net->id

I shoved in an kasprintf but of course there isn't a per-namespace "id".
We probably should have one (or, a nice "name"), but meanwhile I am
using the address of the net struct like "nf_ct-%p".

Jon.


