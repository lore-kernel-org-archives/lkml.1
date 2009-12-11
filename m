Return-Path: <linux-kernel-owner+w=401wt.eu-S1762125AbZLKBJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762125AbZLKBJU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 20:09:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760725AbZLKBJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 20:09:19 -0500
Received: from mail-px0-f189.google.com ([209.85.216.189]:46699 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758016AbZLKBJT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 20:09:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Cve+dcJ19lLAdSlVynUSVE+rwnccCAm4RH9m6EU82JIO4pquf8stWDAkxdHLma5t4t
         5Svw1EwC2DSz5nqs9JmQDOLrTl/GAirmrnZGmK9D0coETrYG48jwYaN1d9lvs4WEFZ+J
         wdbNuL4R7RKkX10YnZx06UA53JFzm4iuqSTBc=
MIME-Version: 1.0
In-Reply-To: <20091210170036.dde2c147.kamezawa.hiroyu@jp.fujitsu.com>
References: <20091210163115.463d96a3.kamezawa.hiroyu@jp.fujitsu.com>
	 <20091210170036.dde2c147.kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 11 Dec 2009 10:09:25 +0900
Message-ID: <28c262360912101709o54ebd549v31b5bcde0fc8613@mail.gmail.com>
Subject: Re: [RFC mm][PATCH 4/5] add a lowmem check function
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       cl@linux-foundation.org,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>, mingo@elte.hu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 10, 2009 at 5:00 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>
> Final purpose of this patch is for improving oom/memoy shortage detection
> better. In general there are OOM cases that lowmem is exhausted. What
> this lowmem means is determined by the situation, but in general,
> limited amount of memory for some special use is lowmem.
>
> This patch adds an integer lowmem_zone, which is initialized to -1.
> If zone_idx(zone) <= lowmem_zone, the zone is lowmem.
>
> This patch uses simple definition that the zone for special use is the lowmem.
> Not taking the amount of memory into account.
>
> For example,
>  - if HIGHMEM is used, NORMAL is lowmem.
>  - If the system has both of NORMAL and DMA32, DMA32 is lowmem.
>  - When the system consists of only one zone, there are no lowmem.
>
> This will be used for lowmem accounting per mm_struct and its information
> will be used for oom-killer.
>
> Changelog: 2009/12/09
>  - stop using policy_zone and use unified definition on each config.
>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

I like this than policy_zone version.


-- 
Kind regards,
Minchan Kim
