Return-Path: <linux-kernel-owner+w=401wt.eu-S1755997AbYK3OAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbYK3OAX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 09:00:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751605AbYK3OAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 09:00:08 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:59697 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbYK3OAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 09:00:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=d9r6oqPmoE5t1QY3Hev6rZ7Gz6m0WKriwBTxmWAZReh3/rwL5acTC/2Kx9tL9YvgTw
         SQqePSWkvm6EDaG9+6dlKXD/fD8s8xUyy+Kelt6Ztgcg+68gRqWdL6HqcgrTn1CYeSzb
         00h9fo7OldSgD924zLcMg8xPYnZcQN3xCLREA=
Message-ID: <2f11576a0811300600r6e23b12frf45c165eab2e398b@mail.gmail.com>
Date: Sun, 30 Nov 2008 23:00:05 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Cyrill Gorcunov" <gorcunov@gmail.com>
Subject: Re: [PATCH 02/09] memcg: make inactive_anon_is_low()
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Rik van Riel" <riel@redhat.com>
In-Reply-To: <20081130122554.GA12552@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081130193502.8145.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20081130195508.814B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20081130122554.GA12552@localhost>
X-Google-Sender-Auth: fc2ccd347bb3e61d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> | +static void mem_cgroup_set_inactive_ratio(struct mem_cgroup *memcg)
> | +{
> | +     unsigned int gb, ratio;
> | +
> | +     gb = res_counter_read_u64(&memcg->res, RES_LIMIT) >> 30;
> | +     ratio = int_sqrt(10 * gb);
> | +     if (!ratio)
> | +             ratio = 1;
>
> Hi Kosaki,
>
> maybe better would be
>
>        gb = ...;
>        if (gb) {
>                ratio = int_sqrt(10 * gb);
>        } else
>                ratio = 1;
>

Will fix.
Thanks.

Actually, setup_per_zone_inactive_ratio() (it calcule for global
reclaim) also have the same non-easy review thning.

I also fix it later.
