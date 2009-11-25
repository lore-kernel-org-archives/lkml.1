Return-Path: <linux-kernel-owner+w=401wt.eu-S933425AbZKYAO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933425AbZKYAO7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 19:14:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933191AbZKYAO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 19:14:59 -0500
Received: from ozlabs.org ([203.10.76.45]:36735 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932572AbZKYAO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 19:14:58 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: [PATCH 1/1] Defer skb allocation for both mergeable buffers and big packets in virtio_net
Date: Wed, 25 Nov 2009 10:45:02 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; i686; ; )
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Shirley Ma <mashirle@us.ibm.com>,
       Eric Dumazet <eric.dumazet@gmail.com>, Avi Kivity <avi@redhat.com>,
       netdev@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Hollis Blanchard <hollisb@us.ibm.com>
References: <1258697745.7416.20.camel@localhost.localdomain> <20091124113754.GB2405@redhat.com> <4B0BEF70.5070104@codemonkey.ws>
In-Reply-To: <4B0BEF70.5070104@codemonkey.ws>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911251045.02736.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Nov 2009 01:06:32 am Anthony Liguori wrote:
> So does lguest.  It's been that way since the beginning.  Fixing this 
> would result in breaking older guests.

Agreed, we can't "fix" it in the guests, but it's a wart.  That's why I
haven't bothered fixing it, but if someone else wants to I'll cheer all the
way.

lguest did it because I knew I could fix lguest any time; it was a bad mistake
and I will now fix lguest :)

> We really need to introduce a feature bit if we want to change this.

I don't think it's worth it.  But the spec does say that the implementation
should not rely on the framing (I think there's a note that current
implementations are buggy tho, so you should frame it separately anyway).

That way future devices can get it right, at least.

Thanks,
Rusty.
