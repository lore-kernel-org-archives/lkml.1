Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979Ab0BAPCh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 10:02:37 -0500
Received: from mail-bw0-f223.google.com ([209.85.218.223]:54575 "EHLO
	mail-bw0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595Ab0BAPCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 10:02:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Zr3G/d95j98gz7/Yi4kIdE6sA1slWAnqPirmXguN31NkUABgADIrEfW64zm7+4W3+C
         w9A1rGDnDgug003/iOBoEhJ5AxnqFePTgabNw9Z1kp7NmJsqRiYT70GWB9NKCEJtcUHp
         v524R/MkA0TUNbFHNosI7DnE71jqErA5BZ4QU=
Subject: Re: [PATCH] netfilter: per netns nf_conntrack_cachep
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Patrick McHardy <kaber@trash.net>, Jon Masters <jonathan@jonmasters.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>,
       netfilter-devel <netfilter-devel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <b6fcc0a1002010658j4f52a9b8kf10e4bb07a2f1075@mail.gmail.com>
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
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Feb 2010 16:02:28 +0100
Message-ID: <1265036548.2848.55.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 01 février 2010 à 16:58 +0200, Alexey Dobriyan a écrit :
> On Mon, Feb 1, 2010 at 4:52 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > +       net->ct.nf_conntrack_cachep = kmem_cache_create("nf_conntrack",
> > +                                                       sizeof(struct nf_conn), 0,
> > +                                                       SLAB_DESTROY_BY_RCU, NULL);
> 
> Duplicate slab name detected.
> 

OK, need to build an unique name I guess... "nf_conntrack-%d", net->id

> Can we clarify this?
> 
> Is checking for ct->ct_net enough to avoid the bug
> while maintaining per-netns/global status quo?

No, I am afraid its not possible without adding big overhead in
fastpath.



