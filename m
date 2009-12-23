Return-Path: <linux-kernel-owner+w=401wt.eu-S1753438AbZLWTIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438AbZLWTIn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 14:08:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752735AbZLWTIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 14:08:42 -0500
Received: from mail.atheros.com ([12.36.123.2]:22111 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752623AbZLWTIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 14:08:41 -0500
Date: Wed, 23 Dec 2009 11:08:40 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: mac80211 suspend corner case (was: Asus eeepc 1008HA suspend
 issue and mac80211 suspend corner) case
Message-ID: <20091223190840.GI2609@tux>
References: <20091222022355.GA32508@bombadil.infradead.org>
 <20091222193010.GB30201@bombadil.infradead.org>
 <1261570081.25008.1.camel@johannes.local>
 <20091223162813.GB2609@tux>
 <1261586828.7304.13.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1261586828.7304.13.camel@johannes.local>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 23, 2009 at 08:47:08AM -0800, Johannes Berg wrote:
> On Wed, 2009-12-23 at 08:28 -0800, Luis R. Rodriguez wrote:
> 
> > > Well it seems to me that if the driver determines that the hardware
> > is
> > > unreachable or not responding, it would unregister it from mac80211,
> > > which would clean up all user-visible state, obviously.
> > 
> > The drivers would not know this until it fails on the first call
> > from mac80211 which would be start().
> 
> Which is why this patch may be a good way to solve that particular
> problem.

Sure but as you and I noted this is not the only thing required.

> > > The patch above seems ok to me, but basically papers over the
> > problem.
> > > If the start there fails, the driver will have to unregister the hw
> > > since any subsequent start will fail as well.
> > 
> > How about just having mac80211 do that for drivers where the start()
> > fails and we are resuming? I can give that a shot.
> 
> No way, the driver will invariably assume things are still going and
> might later unregister etc. Too much magic.

So you want drivers to handle start() failures (even if its not for resume)
with an unregistration to mac80211?

  Luis
