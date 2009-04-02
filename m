Return-Path: <linux-kernel-owner+w=401wt.eu-S1764780AbZDBQWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764780AbZDBQWY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 12:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759660AbZDBQWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 12:22:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43788 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758619AbZDBQWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 12:22:14 -0400
Date: Thu, 2 Apr 2009 09:17:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jean Delvare <khali@linux-fr.org>, LKML <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: Re: [PATCH] Add to_delayed_work helper function
Message-Id: <20090402091735.cb54c330.akpm@linux-foundation.org>
In-Reply-To: <20090402112229.GC10828@elte.hu>
References: <20090402131137.0b268f9a@hyperion.delvare>
	<20090402112229.GC10828@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Apr 2009 13:22:29 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Jean Delvare <khali@linux-fr.org> wrote:
> 
> > It is a fairly common operation to have a pointer to a work and to
> > need a pointer to the delayed work it is contained in. In particular,
> > all delayed works which want to rearm themselves will have to do that.
> > So it would seem fair to offer a helper function for this operation.
> > 
> > Signed-off-by: Jean Delvare <khali@linux-fr.org>
> > Acked-by: Ingo Molnar <mingo@elte.hu>
> > ---
> > Patch updated to include new users. It would be nice to have this patch
> > merged soon so that I no longer have to update it. Andrew?
> 
> Andrew, iff it's comprehensively build-tested then this should go 
> into .30 from -mm, right?

yup, probably in batch #2, probably today.

> Because this:
> 
> >  arch/powerpc/kernel/vio.c                               |    2 +-
> >  drivers/crypto/hifn_795x.c                              |    2 +-
> >  drivers/input/mouse/hgpk.c                              |    2 +-
> >  drivers/net/dm9000.c                                    |    2 +-
> >  drivers/net/mlx4/en_netdev.c                            |    2 +-
> >  drivers/net/mlx4/en_rx.c                                |    2 +-
> >  drivers/net/mlx4/sense.c                                |    2 +-
> >  drivers/net/phy/phy.c                                   |    3 +--
> >  drivers/s390/scsi/zfcp_fc.c                             |    2 +-
> >  drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c |    8 ++++----
> >  drivers/staging/rtl8187se/r8180_core.c                  |    8 ++++----
> >  drivers/staging/rtl8187se/r8180_dm.c                    |    6 +++---
> >  drivers/usb/wusbcore/devconnect.c                       |    2 +-
> >  include/linux/workqueue.h                               |    5 +++++
> >  mm/slab.c                                               |    3 +--
> >  15 files changed, 27 insertions(+), 24 deletions(-)
> 
> ... will be painful to port across another cycle.

Not too bad - I've been sitting on #1 for a month.

