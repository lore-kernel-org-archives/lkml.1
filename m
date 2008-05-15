Return-Path: <linux-kernel-owner+w=401wt.eu-S1755992AbYEONNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992AbYEONNT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 09:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751629AbYEONNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 09:13:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54348 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751563AbYEONNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 09:13:08 -0400
Date: Thu, 15 May 2008 09:12:30 -0400
From: Rik van Riel <riel@redhat.com>
To: "MinChan Kim" <minchan.kim@gmail.com>
Cc: linux-kernel@vger.kernel.org, lee.schermerhorn@hp.com,
       akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com
Subject: Re: [PATCH -mm 09/15] add some sanity checks to get_scan_ratio
Message-ID: <20080515091230.6718cdb8@bree.surriel.com>
In-Reply-To: <28c262360805142334y4740530co36ecd5c44752f1@mail.gmail.com>
References: <20080428181835.502876582@redhat.com>
	<20080428181852.961869151@redhat.com>
	<28c262360805142334y4740530co36ecd5c44752f1@mail.gmail.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2008 15:34:51 +0900
"MinChan Kim" <minchan.kim@gmail.com> wrote:

> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1375,8 +1375,7 @@ static unsigned long shrink_zone(int priority, struct zon
>          * rebalance the anon lru active/inactive ratio.
>          */
>         if (scan_global_lru(sc) && inactive_anon_low(zone))
> -               shrink_list(NR_ACTIVE_ANON, SWAP_CLUSTER_MAX, zone, sc,
> -                                                               priority);
> +               shrink_inactive_list(SWAP_CLUSTER_MAX, zone, sc, priority, 0);
> 
>         throttle_vm_writeout(sc->gfp_mask);
>         return nr_reclaimed;

shrink_active_list, but yes, that is the idea.

-- 
All rights reversed.
