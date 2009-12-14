Return-Path: <linux-kernel-owner+w=401wt.eu-S1756868AbZLNPk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868AbZLNPk5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 10:40:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755921AbZLNPk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 10:40:56 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:60054 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700AbZLNPkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 10:40:55 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC] macvlan: add tap device backend
Date: Mon, 14 Dec 2009 16:40:13 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       "" <davem@davemloft.net>, "Michael S. Tsirkin" <mst@redhat.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Or Gerlitz <ogerlitz@voltaire.com>,
       "Fischer, Anna" <anna.fischer@hp.com>,
       Anthony Liguori <anthony@codemonkey.ws>,
       virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
       bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Edge Virtual Bridging <evb@yahoogroups.com>
References: <1259862720-28432-1-git-send-email-arnd@arndb.de> <1259862720-28432-3-git-send-email-arnd@arndb.de> <4B26353A.9020005@trash.net>
In-Reply-To: <4B26353A.9020005@trash.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200912141640.13562.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+g9CkeM6nUcpkFQAwWIdpmp4p39Pdl+0duemX
 CTzxMkjhywEoGXo8cgLRtRLWtEbcM7gpBOph37ds9Pmv6GhEEu
 1aPwbFVL2msMmPlyHTaBA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 December 2009, Patrick McHardy wrote:
> > +     classdev = device_create(macvtap_class, &dev->dev, devt,
> > +                              dev, "tap%d", dev->ifindex);
> > +     if (IS_ERR(classdev)) {
> > +             err = PTR_ERR(classdev);
> > +             macvtap_del_queues(dev);
> > +             macvlan_dellink(dev, NULL);
> 
> I think this may cause a double free since macvlan_dellink() will
> free the device and rtnl_newlink() will free it again on error.

Ah, right. I've changed this part a few times now, but I think introduced
the same bug again in the current version. I'll send out what I have now
if you want to take another look.

	Arnd
