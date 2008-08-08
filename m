Return-Path: <linux-kernel-owner+w=401wt.eu-S1754954AbYHHBkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954AbYHHBkK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 21:40:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbYHHBj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 21:39:58 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60495 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbYHHBj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 21:39:58 -0400
Subject: Re: [GIT PULL]: firmware patches for building firmware into kernel
From: Jaswinder Singh <jaswinder@infradead.org>
To: David Dillow <dave@thedillows.org>
Cc: David Woodhouse <dwmw2@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <1218133288.18118.20.camel@lap75545.ornl.gov>
References: <1218128219.14483.7.camel@jaswinder.satnam>
	 <1218130222.18118.7.camel@lap75545.ornl.gov>
	 <1218130475.14483.16.camel@jaswinder.satnam>
	 <1218133288.18118.20.camel@lap75545.ornl.gov>
Content-Type: text/plain; charset=utf8
Date: Fri, 08 Aug 2008 07:08:10 +0530
Message-Id: <1218159490.2553.13.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dave,

On Thu, 2008-08-07 at 14:21 -0400, David Dillow wrote:
> On Thu, 2008-08-07 at 23:04 +0530, Jaswinder Singh wrote:
> > Hello David Dillow,
> > 
> > On Thu, 2008-08-07 at 13:30 -0400, David Dillow wrote:
> > > On Thu, 2008-08-07 at 22:26 +0530, Jaswinder Singh wrote:
> > > >       firmware: avoiding multiple replication for same firmware file
> > > 
> > > If this is the last patch you sent to the list, I think there are still
> > > locking bugs in it. I was short on time, so I didn't give it a full
> > > review, but I remember seeing problems. I'll try to give it some time
> > > tonight, if Andrew doesn't beat me to it.
> > 
> > This is updated and revised patch.
> 
> I just looked at the tree; it still has locking issues, and needs
> further review. You must protect the list from modification while you
> iterate it looking for an match on the requested firmware. Also, was it
> legal to call release_firmware() from an atomic context? It can now
> sleep, which may be an issue...
> 

Ok, I will revise it thanks.


> > > >       typhoon: use request_firmware
> > > 
> > > This is untested -- again, no time over the weekend -- and I'd rather
> > > not have it go upstream until has been verified.
> >
> > ﻿This is also updated and revised patch.
> 
> Please drop that patch from the series for now; I'm not happy with it,
> as it reintroduces things I've asked be changed. 

You mean this :

﻿+       /*
+        * Need to check request_firmware should be called only once
+        * so you don't leak memory if there is more than one NIC.
+        * Need to check if PCI probing gets multi-threaded as
+        * mutex is used while loading the firmware.
+        */
+       if (typhoon_fw != NULL) {
+               err = typhoon_init_firmware(tp);

This is not required now, As I already fixed request_firmware.

﻿So it is replaced by :

﻿+       err = typhoon_init_firmware(tp);

Do you think we still need above comments ?

Thanks you,

Jaswinder Singh.

