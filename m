Return-Path: <linux-kernel-owner+w=401wt.eu-S1755097AbZDBLXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097AbZDBLXa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 07:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbZDBLXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 07:23:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53224 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907AbZDBLXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 07:23:11 -0400
Date: Thu, 2 Apr 2009 13:22:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jean Delvare <khali@linux-fr.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: Re: [PATCH] Add to_delayed_work helper function
Message-ID: <20090402112229.GC10828@elte.hu>
References: <20090402131137.0b268f9a@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090402131137.0b268f9a@hyperion.delvare>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jean Delvare <khali@linux-fr.org> wrote:

> It is a fairly common operation to have a pointer to a work and to
> need a pointer to the delayed work it is contained in. In particular,
> all delayed works which want to rearm themselves will have to do that.
> So it would seem fair to offer a helper function for this operation.
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> Acked-by: Ingo Molnar <mingo@elte.hu>
> ---
> Patch updated to include new users. It would be nice to have this patch
> merged soon so that I no longer have to update it. Andrew?

Andrew, iff it's comprehensively build-tested then this should go 
into .30 from -mm, right?

Because this:

>  arch/powerpc/kernel/vio.c                               |    2 +-
>  drivers/crypto/hifn_795x.c                              |    2 +-
>  drivers/input/mouse/hgpk.c                              |    2 +-
>  drivers/net/dm9000.c                                    |    2 +-
>  drivers/net/mlx4/en_netdev.c                            |    2 +-
>  drivers/net/mlx4/en_rx.c                                |    2 +-
>  drivers/net/mlx4/sense.c                                |    2 +-
>  drivers/net/phy/phy.c                                   |    3 +--
>  drivers/s390/scsi/zfcp_fc.c                             |    2 +-
>  drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c |    8 ++++----
>  drivers/staging/rtl8187se/r8180_core.c                  |    8 ++++----
>  drivers/staging/rtl8187se/r8180_dm.c                    |    6 +++---
>  drivers/usb/wusbcore/devconnect.c                       |    2 +-
>  include/linux/workqueue.h                               |    5 +++++
>  mm/slab.c                                               |    3 +--
>  15 files changed, 27 insertions(+), 24 deletions(-)

... will be painful to port across another cycle.

( and it's pointless to delay as well, this is an obvious cleanup 
  well in line with how we use to_*() container constructs elsewhere 
  in the driver frameworks. )

	Ingo
