Return-Path: <linux-kernel-owner+w=401wt.eu-S1757691AbZKZC6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691AbZKZC6b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 21:58:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754184AbZKZC6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 21:58:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59585 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754005AbZKZC6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 21:58:30 -0500
Message-ID: <4B0DEEAB.4000807@redhat.com>
Date: Wed, 25 Nov 2009 21:57:47 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, lwoodman@redhat.com,
       kosaki.motohiro@fujitsu.co.jp, Tomasz Chmielewski <mangoo@wpkg.org>,
       akpm@linux-foundation.org
Subject: Re: [PATCH] vmscan: do not evict inactive pages when skipping an
 active list scan
References: <20091125133752.2683c3e4@bree.surriel.com> <20091126110340.5A62.A69D9226@jp.fujitsu.com>
In-Reply-To: <20091126110340.5A62.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2009 09:50 PM, KOSAKI Motohiro wrote:
>
>> -	if (lru == LRU_ACTIVE_ANON&&  inactive_anon_is_low(zone, sc)) {
>> -		shrink_active_list(nr_to_scan, zone, sc, priority, file);
>> +	if (lru == LRU_ACTIVE_ANON) {
>> +		if (inactive_file_is_low(zone, sc))
>>      
> This inactive_file_is_low() should be inactive_anon_is_low().
> cut-n-paste programming often makes similar mistake. probaby we need make
> more cleanup to this function.
>
> How about this? (this is incremental patch from you)
>
>
>    
Doh!  Nice catch...
> Signed-off-by: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
>
>    
Reviewed-by: Rik van Riel <riel@redhat.com>
