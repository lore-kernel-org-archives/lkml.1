Return-Path: <linux-kernel-owner+w=401wt.eu-S1757944AbZLGNWG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757944AbZLGNWG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 08:22:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757593AbZLGNWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 08:22:05 -0500
Received: from mtagate5.de.ibm.com ([195.212.17.165]:57125 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757521AbZLGNWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 08:22:04 -0500
Date: Mon, 7 Dec 2009 14:22:13 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, wein@de.ibm.com
Subject: Re: [PATCH] dasd: PTR_ERR return of wrong pointer in
 dasd_alias_make_device_known_to_lcu()
Message-ID: <20091207142213.286a8824@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <4B1D00B0.5030209@gmail.com>
References: <4B1D00B0.5030209@gmail.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 Dec 2009 14:18:40 +0100
Roel Kluin <roel.kluin@gmail.com> wrote:

> Return the PTR_ERR of the correct pointer.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
>  drivers/s390/block/dasd_alias.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> Unless I am mistaken?
> 
> diff --git a/drivers/s390/block/dasd_alias.c b/drivers/s390/block/dasd_alias.c
> index 70a008c..fa37148 100644
> --- a/drivers/s390/block/dasd_alias.c
> +++ b/drivers/s390/block/dasd_alias.c
> @@ -217,7 +217,7 @@ int dasd_alias_make_device_known_to_lcu(struct dasd_device *device)
>  		spin_unlock_irqrestore(&aliastree.lock, flags);
>  		newlcu = _allocate_lcu(uid);
>  		if (IS_ERR(newlcu))
> -			return PTR_ERR(lcu);
> +			return PTR_ERR(newlcu);
>  		spin_lock_irqsave(&aliastree.lock, flags);
>  		lcu = _find_lcu(server, uid);
>  		if (!lcu) {

You are not mistaken. I'll add the patch to the queue. Thanks.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

