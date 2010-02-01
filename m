Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186Ab0BAO6w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 09:58:52 -0500
Received: from mail-iw0-f186.google.com ([209.85.223.186]:62448 "EHLO
	mail-iw0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755138Ab0BAO6u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 09:58:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ai6UWMAmAnTRsEJqNDmPbiEBdMmcTNUchgd4ObXj3LGy1Ae/emoqcwVG3QFDhZbIwc
         s4pkC7U0/wovzT4P/NBUnPb68gQ8EiKELY6cXKD6tLdnjgxAtH5ryOh+DH/M5WdhAfD9
         kY0wBIKatVN48OxKP/rOMCWWJO5H9k23kN4dM=
MIME-Version: 1.0
In-Reply-To: <1265035970.2848.50.camel@edumazet-laptop>
References: <1264813832.2793.446.camel@tonnant>
	 <1264816634.2793.505.camel@tonnant>
	 <1264816777.2793.510.camel@tonnant>
	 <1264834704.2919.3.camel@edumazet-laptop>
	 <1265016745.7499.144.camel@tonnant>
	 <b6fcc0a1002010136k7e78a998p31a9e7464c2e8d44@mail.gmail.com>
	 <1265019160.2848.14.camel@edumazet-laptop>
	 <b6fcc0a1002010225u4e74f9f0q633d73038234dc37@mail.gmail.com>
	 <1265023437.2848.30.camel@edumazet-laptop>
	 <1265035970.2848.50.camel@edumazet-laptop>
Date: Mon, 1 Feb 2010 16:58:49 +0200
Message-ID: <b6fcc0a1002010658j4f52a9b8kf10e4bb07a2f1075@mail.gmail.com>
Subject: Re: [PATCH] netfilter: per netns nf_conntrack_cachep
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Patrick McHardy <kaber@trash.net>, Jon Masters <jonathan@jonmasters.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>,
       netfilter-devel <netfilter-devel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 1, 2010 at 4:52 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> +       net->ct.nf_conntrack_cachep = kmem_cache_create("nf_conntrack",
> +                                                       sizeof(struct nf_conn), 0,
> +                                                       SLAB_DESTROY_BY_RCU, NULL);

Duplicate slab name detected.

Can we clarify this?

Is checking for ct->ct_net enough to avoid the bug
while maintaining per-netns/global status quo?
