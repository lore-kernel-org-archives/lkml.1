Return-Path: <linux-kernel-owner+w=401wt.eu-S1758029AbZCCMMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029AbZCCMMQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 07:12:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753152AbZCCMMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 07:12:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35836 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbZCCML7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 07:11:59 -0500
Date: Tue, 3 Mar 2009 13:11:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jean Delvare <khali@linux-fr.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] Add to_delayed_work helper function
Message-ID: <20090303121138.GB5740@elte.hu>
References: <20090303083440.57df68c3@hyperion.delvare> <20090303002952.80f1afc8.akpm@linux-foundation.org> <20090303130601.2c8f4bb0@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090303130601.2c8f4bb0@hyperion.delvare>
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
> ---
> Andrew, does this variant please you better?
> 
>  arch/powerpc/kernel/vio.c                               |    2 +-
>  drivers/crypto/hifn_795x.c                              |    2 +-
>  drivers/input/mouse/hgpk.c                              |    2 +-
>  drivers/net/dm9000.c                                    |    2 +-
>  drivers/net/mlx4/en_netdev.c                            |    2 +-
>  drivers/net/mlx4/en_rx.c                                |    2 +-
>  drivers/s390/scsi/zfcp_fc.c                             |    2 +-
>  drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c |    8 ++++----
>  drivers/staging/rtl8187se/r8180_core.c                  |    8 ++++----
>  drivers/staging/rtl8187se/r8180_dm.c                    |    6 +++---
>  drivers/usb/wusbcore/devconnect.c                       |    2 +-
>  include/linux/workqueue.h                               |    5 +++++
>  mm/slab.c                                               |    3 +--
>  13 files changed, 25 insertions(+), 21 deletions(-)

looks good,

Acked-by: Ingo Molnar <mingo@elte.hu>

one small detail:

> --- linux-2.6.29-rc6.orig/include/linux/workqueue.h	2009-01-29 08:27:20.000000000 +0100
> +++ linux-2.6.29-rc6/include/linux/workqueue.h	2009-03-03 10:36:53.000000000 +0100
> @@ -41,6 +41,11 @@ struct delayed_work {
>  	struct timer_list timer;
>  };
>  
> +static inline struct delayed_work *to_delayed_work(struct work_struct *_work)
> +{
> +	return container_of(_work, struct delayed_work, work);
> +}
> +

there's no need to name it _work i think and '*work' should be 
just fine - this isnt a macro so there's no danger of namespace 
interactions.

	Ingo
