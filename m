Return-Path: <linux-kernel-owner+w=401wt.eu-S1758428AbYHFPdM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758428AbYHFPdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 11:33:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754933AbYHFPc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 11:32:58 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:26100 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754716AbYHFPc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 11:32:57 -0400
Date: Wed, 6 Aug 2008 08:30:44 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Karsten Keil <kkeil@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, isdn4linux@listserv.isdn4linux.de
Subject: Re: [PATCH 3/3] Fix lockdep warning
Message-Id: <20080806083044.e1668531.randy.dunlap@oracle.com>
In-Reply-To: <20080806133031.D6BB7BC11C@pingi.kke.suse.de>
References: <20080806133031.D6BB7BC11C@pingi.kke.suse.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  6 Aug 2008 15:30:31 +0200 (CEST) Karsten Keil wrote:

> use correct dynamic spinlock init function.
> 
> Signed-off-by: Karsten Keil <kkeil@suse.de>

Hi,

It would be a Really Good Thing if we could look at the subject line
and see that this is for an ISDN driver instead of something else,
like even the general lockdep framework.

The Perfect Patch (http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt)
section 2.b. discusses this, but it isn't quite strong enough.  ;)


Thanks.

> ---
>  drivers/isdn/mISDN/tei.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/isdn/mISDN/tei.c b/drivers/isdn/mISDN/tei.c
> index 6fbae42..d8af45c 100644
> --- a/drivers/isdn/mISDN/tei.c
> +++ b/drivers/isdn/mISDN/tei.c
> @@ -1287,7 +1287,7 @@ create_teimanager(struct mISDNdevice *dev)
>  	if (!mgr)
>  		return -ENOMEM;
>  	INIT_LIST_HEAD(&mgr->layer2);
> -	mgr->lock = __RW_LOCK_UNLOCKED(mgr->lock);
> +	rwlock_init(&mgr->lock);
>  	skb_queue_head_init(&mgr->sendq);
>  	mgr->nextid = 1;
>  	mgr->lastid = MISDN_ID_NONE;
> -- 

---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
