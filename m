Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200Ab0BCTJ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 14:09:58 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:56813 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756863Ab0BCTJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 14:09:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oknGWv2310orhJFm+kukev9cCN6amCIhJU0HsSUuHa3Qo37bCr00XOFwsxZi4LQ+DG
         /kdoQLU+9qXeMh426P1aw0h017ZxwyVdEbljiMM91/fwtm3+817cVdcK2viNawWU8eUS
         FxqfHjqelAzWufE+RMH8+RD6LnLZ2M50hGdp8=
Date: Wed, 3 Feb 2010 21:09:48 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Jon Masters <jonathan@jonmasters.org>
Cc: Patrick McHardy <kaber@trash.net>, Eric Dumazet <eric.dumazet@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>,
       netfilter-devel <netfilter-devel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] netfilter: per netns nf_conntrack_cachep
Message-ID: <20100203190948.GA5182@x200>
References: <1265108690.2861.118.camel@tonnant>
 <1265110504.2861.135.camel@tonnant>
 <1265129192.2861.141.camel@tonnant>
 <4B685756.8010107@trash.net>
 <1265130426.2861.158.camel@tonnant>
 <b6fcc0a1002020958u17315624u4d54d06a413be6bb@mail.gmail.com>
 <1265134598.2861.191.camel@tonnant>
 <4B6870AF.6060109@trash.net>
 <4B6967BC.600@trash.net>
 <1265222289.2861.290.camel@tonnant>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265222289.2861.290.camel@tonnant>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 03, 2010 at 01:38:09PM -0500, Jon Masters wrote:
> *). Per namespace cacheing allocation (the cachep bits). We know it's
> still possible for weirdness to happen in the SLAB cache here.

Tiny race, needs reproducer.

> *). Per namespace hashsize tracking. Existing code corrupts hashtables
> if the global size is changed when there is more than one netns

I think, no.
Changing hash size will change hashsize for all netns, current and future.

> *). Per namespace expectations. This is for similar reasons to the need
> for multiple hashtables, though I haven't poked at that.

Expectation cache is not SLAB_DESTROY_BY_RCU, so the logic doesn't
apply, I hope.

> I also think it is necessary to expose net namespace layout

Not necessary. Why?

> and configuration via sysfs

Which configuration?

> or some other interface, add a net->id parameter (and may even an optional name),

No name, please :-)
->id is more or less required for per-netns conntrack cache.

> etc. Where does netns discussion happen, on netdev I would presume?

Yep. And containters@, I think.
