Return-Path: <linux-kernel-owner+w=401wt.eu-S1752917AbZKBAsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917AbZKBAsN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 19:48:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752780AbZKBAsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 19:48:13 -0500
Received: from mail-px0-f179.google.com ([209.85.216.179]:37115 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbZKBAsM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 19:48:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IWxfSiycVt8dRC/nRJiJyimQi5q303qWjTW5JC4y50HeMUbZiH6FtSQncA7TjNLbaB
         ZZDYc/AemblDJuEncM6ADb0WEkGCqyVNlulmAE5uzf4GuRAXijDumkqw3e/oGvY/S56c
         Egthzg2lSoS3G49ZcxWLjuBtZSXu81KF8rHBY=
MIME-Version: 1.0
In-Reply-To: <20091102093517.32021780.minchan.kim@barrios-desktop>
References: <20091101234614.F401.A69D9226@jp.fujitsu.com>
	 <20091102093517.32021780.minchan.kim@barrios-desktop>
Date: Mon, 2 Nov 2009 09:48:16 +0900
Message-ID: <28c262360911011648r642ec104x9232303a7f355fdb@mail.gmail.com>
Subject: Re: [PATCHv2 1/5] vmscan: separate sc.swap_cluster_max and 
	sc.nr_max_reclaim
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Rik van Riel <riel@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 2, 2009 at 9:35 AM, Minchan Kim <minchan.kim@gmail.com> wrote:
> Hi, Kosaki.
>
> On Mon, 2 Nov 2009 00:08:44 +0900 (JST)
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
>
>> Currently, sc.scap_cluster_max has double meanings.
>>
>>  1) reclaim batch size as isolate_lru_pages()'s argument
>>  2) reclaim baling out thresolds
>>
>> The two meanings pretty unrelated. Thus, Let's separate it.
>> this patch doesn't change any behavior.
>>
>> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> Cc: Rafael J. Wysocki <rjw@sisk.pl>
>> Reviewed-by: Rik van Riel <riel@redhat.com>
>> ---
>>  mm/vmscan.c |   21 +++++++++++++++------
>>  1 files changed, 15 insertions(+), 6 deletions(-)
>>
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index f805958..6a3eb9f 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -55,6 +55,9 @@ struct scan_control {
>>       /* Number of pages freed so far during a call to shrink_zones() */
>>       unsigned long nr_reclaimed;
>>
>> +     /* How many pages shrink_list() should reclaim */
>> +     unsigned long nr_to_reclaim;
>
> If you try to divide meaning of swap_cluster_max,
> How about changing 'swap_cluster_max', too?
>
> It has a meaning which represents 'batch size'. ;)
> I hope we change it in this chance.

I see the your 4th patch 'Kill sc.swap_cluster_max' now.
It's good to me. Forget this comment. :)


-- 
Kind regards,
Minchan Kim
