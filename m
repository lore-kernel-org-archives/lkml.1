Return-Path: <linux-kernel-owner+w=401wt.eu-S1753252AbYKQRci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252AbYKQRci (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 12:32:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbYKQRc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 12:32:29 -0500
Received: from wf-out-1314.google.com ([209.85.200.168]:57011 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbYKQRc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 12:32:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=I6al6/BDnfEptV+pDTOqdWg3LcX75R98nYiruYno1O+sn8Gk7No+Z1PMDTx7GL0DUO
         u4HHIuL/K1KQzDc0mAbGcYxccc1Ih0MhTRV+mO5nfCoDfbLQZXn/7yGFQAj2AIalMySz
         uGq34wjVwjuvAHbz3OPqLe5Oq/AfUHhC/lJgU=
Message-ID: <2f11576a0811170932g7f70ab3ai57d03958514124e@mail.gmail.com>
Date: Tue, 18 Nov 2008 02:32:26 +0900
From: "KOSAKI Motohiro" <m-kosaki@ceres.dti.ne.jp>
To: "Rik van Riel" <riel@redhat.com>
Subject: Re: [PATCH] vmscan: fix get_scan_ratio comment
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       "Gene Heskett" <gene.heskett@gmail.com>
In-Reply-To: <4921A706.9030501@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081115181748.3410.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20081116204720.1b8cbe18.akpm@linux-foundation.org>
	 <20081117153012.51ece88f.kamezawa.hiroyu@jp.fujitsu.com>
	 <2f11576a0811162239w58555c6dq8a61ec184b22bd52@mail.gmail.com>
	 <20081117155417.5cc63907.kamezawa.hiroyu@jp.fujitsu.com>
	 <alpine.LFD.2.00.0811170802010.3468@nehalem.linux-foundation.org>
	 <alpine.LFD.2.00.0811170830320.3468@nehalem.linux-foundation.org>
	 <4921A1AF.1070909@redhat.com>
	 <alpine.LFD.2.00.0811170904160.3468@nehalem.linux-foundation.org>
	 <4921A706.9030501@redhat.com>
X-Google-Sender-Auth: 1a21d05ac9e075b4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/18 Rik van Riel <riel@redhat.com>:
>
> Fix the old comment on the scan ratio calculations.
>
> Signed-off-by: Rik van Riel <riel@redhat.com>
> ---
>  mm/vmscan.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> Index: linux-2.6.28-rc5/mm/vmscan.c
> ===================================================================
> --- linux-2.6.28-rc5.orig/mm/vmscan.c   2008-11-16 17:47:13.000000000 -0500
> +++ linux-2.6.28-rc5/mm/vmscan.c        2008-11-17 12:05:03.000000000 -0500
> @@ -1386,9 +1386,9 @@ static void get_scan_ratio(struct zone *
>        file_prio = 200 - sc->swappiness;
>
>        /*
> -        *                  anon       recent_rotated[0]
> -        * %anon = 100 * ----------- / ----------------- * IO cost
> -        *               anon + file      rotate_sum
> +        *         recent_scanned[anon]
> +        * %anon = -------------------- * sc->swappiness
> +        *         recent_rotated[anon]
>         */
>        ap = (anon_prio + 1) * (zone->recent_scanned[0] + 1);
>        ap /= zone->recent_rotated[0] + 1;

looks good to me, absolutely.
      Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
