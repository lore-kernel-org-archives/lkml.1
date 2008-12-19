Return-Path: <linux-kernel-owner+w=401wt.eu-S1752232AbYLSQh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbYLSQh3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 11:37:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751361AbYLSQhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 11:37:20 -0500
Received: from wf-out-1314.google.com ([209.85.200.168]:27842 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbYLSQhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 11:37:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=IFMTjiaLHgCUBLxLg+H6CyPri6BSjLBMBkhnpeVXh3tyf4zz/wgydGqdim82I6dCRN
         O5F5ZWBaK3wVt0fZG5Gos7K45b7ckgsD+W7l1wUzxqDsZk50BH6NOQbplljqTgYaaD9q
         GJ15oRb0Cx0nvI5mFSm/onreUqMn5ZWjyOIMo=
Subject: Re: [PATCH-2.6.28 final] byteorder: fix new headers for userspace
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       David Woodhouse <dwmw2@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, bluebird@gentoo.org,
       sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>
In-Reply-To: <20081219090856.48666b14@infradead.org>
References: <4943DAD6.7070402@gentoo.org>
	 <20081216.011334.124918024.davem@davemloft.net>
	 <1229564779.6481.26.camel@brick>
	 <alpine.LFD.2.00.0812181208070.14014@localhost.localdomain>
	 <alpine.LFD.2.00.0812181246420.14014@localhost.localdomain>
	 <20081219090856.48666b14@infradead.org>
Content-Type: text/plain
Date: Fri, 19 Dec 2008 08:37:15 -0800
Message-Id: <1229704635.32291.5.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-12-19 at 09:08 +0100, Arjan van de Ven wrote:
> On Thu, 18 Dec 2008 12:47:28 -0800 (PST)
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > 
> > 
> > On Thu, 18 Dec 2008, Linus Torvalds wrote:
> > > 
> > > I think it would be better to just make it a config option, call it 
> > > CONFIG_[LITTLE|BIG]_ENDIAN and set it up in the architecture
> > > Kconfig file. I think some of the people who can set it dynamically
> > > (or where it depends on the target machine) already effectively do
> > > that.
> > 
> > Never mind, since we end up having to export it to user space (do
> > we?) we can't depend on the config.h file, nor can we pollute the
> > name space.
> > 
> 
> why are we exposing byte order functions to userspace in the first
> place ????
> 

Hysterical raisons.  When I originally consolidated the byteorder stuff
I removed the userspace export.  HPA (CC'd) made the point that this
API (rightly or wrongly) was currently exported and used by userspace
and we shouldn't pull the rug out from under them.

I would have liked to un-export it, then we could also make linux/byteorder.h
the preferred include instead of asm/ ... but we appear to be stuck with
historical baggage here.

Crazy idea: could a byteorder-user.h be added that make headers-export
will pick up instead of byteorder.h that the kernel _actually_ uses?

Then we could keep exporting _something_ to avoid breaking userspace
and allow the version the kernel actually uses to be evolved a bit
more easily?

Harvey

