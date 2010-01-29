Return-Path: <linux-kernel-owner+w=401wt.eu-S1754432Ab0A2TuI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432Ab0A2TuI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 14:50:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523Ab0A2TuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 14:50:07 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:61402 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217Ab0A2TuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 14:50:06 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 3/3] net: macvtap driver
Date: Fri, 29 Jan 2010 20:49:52 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc5; KDE/4.3.2; x86_64; ; )
Cc: David Miller <davem@davemloft.net>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Patrick McHardy <kaber@trash.net>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Or Gerlitz <ogerlitz@voltaire.com>, netdev@vger.kernel.org,
       bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <201001271104.20607.arnd@arndb.de> <201001282118.09164.arnd@arndb.de> <20100129112141.GA6548@redhat.com>
In-Reply-To: <20100129112141.GA6548@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001292049.52308.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18YNVinf38FFo5HMN4KFKlaohEMkRfcMJlo5VP
 HayuI1YEIQiTju/g2RMv/zFBWpjiLHYWtQGwJ+M0KjXlpjQxIz
 VxNSk87omZldjk/KEF6OQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 January 2010, Michael S. Tsirkin wrote:
> > That may well be, I haven't tried vlan. What do you think it should do
> > then?
> 
> Look at eth_type for a more complete packet parsing.

ok. I initially called that but it crashed because the skb was not initialized
properly at that point. I'll have a look.

> > > > +/*
> > > > + * provide compatibility with generic tun/tap interface
> > > > + */
> > > > +static long macvtap_ioctl(struct file *file, unsigned int cmd,
> > > > +                   unsigned long arg)
> > > > +{
> > > 
> > > All of these seem to be stubs, and tun has many more that you didn't
> > > stub out. So, why do you bother to support any ioctls at all?
> > 
> > Again, minimum features to get things going. qemu fails to open
> > the device if these ioctls are not implemented, but any of the
> > more advanced features are left out.
> 
> This is strange, could be application bug.  E.g. send buf size is
> relatively new and apps should handle failure gracefully.  IMO,
> returning success and ignoring the value is not a good idea.  How about
> we just fix qemu?  What about other apps?

Ok, I'll go through the ioctls again and make sure they behave correctly
they way you said. I haven't tried against against anything but qemu and
cat.

	Arnd
