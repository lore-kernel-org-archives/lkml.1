Return-Path: <linux-kernel-owner+w=401wt.eu-S1757781AbYBFSXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757781AbYBFSXm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 13:23:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754739AbYBFSXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 13:23:19 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:2830 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970AbYBFSXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 13:23:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:bcc:subject:reply-to:in-reply-to:message-id;
        b=eS0jbAFXHjdik90JSQDoWubYx72K9CJoL4e/+oY4i8Jxkd92DsG3T1Xe0zdGRHejTwitqHHqpTS2oSHCRNQoPkd2AiwdMoejd5hM5nQlby+oK4+Pdx2wcSkx584LljT8aT9tpgNPKT/hocgY8TWn7+Lwf617msDMgWFbIHlNBkw=
Date: Wed,  6 Feb 2008 10:30:24 -0800
From: Glenn Griffin <ggriffin.kernel@gmail.com>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Glenn Griffin <ggriffin.kernel@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Andi Kleen <andi@firstfloor.org>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add IPv6 support to TCP SYN cookies
In-Reply-To: <20080206091353.GA12927@2ka.mipt.ru>
Message-ID: <47a9fb13.01538c0a.3b80.ffff9328@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +static u32 cookie_hash(struct in6_addr *saddr, struct in6_addr *daddr,
> > +		       __be16 sport, __be16 dport, u32 count, int c)
> > +{
> > +	__u32 tmp[16 + 5 + SHA_WORKSPACE_WORDS];
> 
> This huge buffer should not be allocated on stack.

I can replace it will a kmalloc, but for my benefit what's the practical
size we try and limit the stack to?  It seemed at first glance to me
that 404 bytes plus the arguments, etc. was not such a large buffer for
a non-recursive function.  Plus the alternative with a kmalloc requires
propogating the possible error status back up to tcp_ipv6.c in the event
we are unable to allocate enough memory, so it can simply drop the
connection.  Not an impossible task by any means but it does
significantly complicate things and I would like to know it's worth the
effort.  Also would it be worth it to provide a supplemental patch for
the ipv4 implementation as it allocates the same buffer?

--Glenn
