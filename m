Return-Path: <linux-kernel-owner+w=401wt.eu-S1752461Ab0ARCZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461Ab0ARCZQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 21:25:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753844Ab0ARCZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 21:25:13 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:49761 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723Ab0ARCZL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 21:25:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tj6ESPVRNDpR+2Za+oeELHPwZobfLK5Qo1bZDjv0lTKHc+tW0aYmrjWTigwhntyu/u
         dL3vL6My/d/VDRHXr5XRakhYurjSCKTCOVWXef4iEGnLehdgLYR8YdAyroZi2R+5G6Dj
         eVWRyeSj+7/eVkuwIj0muhRLKVRUN9N2oNGCY=
MIME-Version: 1.0
In-Reply-To: <4B53C466.4010103@redhat.com>
References: <20100118100359.AE22.A69D9226@jp.fujitsu.com>
	 <28c262361001171747w450c8fd8j4daf84b72fb68e1a@mail.gmail.com>
	 <20100118104910.AE2D.A69D9226@jp.fujitsu.com>
	 <28c262361001171810w544614b7rdd3df0f984692f35@mail.gmail.com>
	 <4B53C466.4010103@redhat.com>
Date: Mon, 18 Jan 2010 11:25:10 +0900
Message-ID: <28c262361001171825l59e8ecbemd30a628cd36aab01@mail.gmail.com>
Subject: Re: [PATCH 2/3][v2] vmstat: add anon_scan_ratio field to zoneinfo
From: Minchan Kim <minchan.kim@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 11:16 AM, Rik van Riel <riel@redhat.com> wrote:
> On 01/17/2010 09:10 PM, Minchan Kim wrote:
>
>> Absoultely right. I missed that. Thanks.
>> get_scan_ratio used lru_lock to get reclaim_stat->recent_xxxx.
>> But, it doesn't used lru_lock to get ap/fp.
>>
>> Is it intentional? I think you or Rik know it. :)
>> I think if we want to get exact value, we have to use lru_lock until
>> getting ap/fp.
>> If it isn't, we don't need lru_lock when we get the
>> reclaim_stat->recent_xxxx.
>>
>> What do you think about it?
>
> This is definately not intentional.
>
> Getting race conditions in this code could throw off the
> statistics by a factor 2.  I do not know how serious that
> would be for the VM or whether (and how quickly) it would
> self correct.

Okay. How about making patch to get exact ap/fp?
Although it were not serious or fast recoverable, I think it would be better
to protect lru_lock for consistency if lru_lock isn't big contention lock.

>
> --
> All rights reversed.
>



-- 
Kind regards,
Minchan Kim
