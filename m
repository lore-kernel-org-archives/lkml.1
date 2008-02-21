Return-Path: <linux-kernel-owner+w=401wt.eu-S1761210AbYBUQfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761210AbYBUQfc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 11:35:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbYBUQfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 11:35:16 -0500
Received: from stinky.trash.net ([213.144.137.162]:54925 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829AbYBUQfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 11:35:15 -0500
Message-ID: <47BDA830.1000608@trash.net>
Date: Thu, 21 Feb 2008 17:34:56 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@vyatta.com>
CC: Tilman Schmidt <tilman@imap.cc>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       netfilter-devel@vger.kernel.org
Subject: Re: 2.6.25-rc2-mm1 - several bugs and a crash
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org>	<47BC982C.7050402@imap.cc>	<47BD6072.4000407@trash.net> <20080221083248.5b76b496@extreme>
In-Reply-To: <20080221083248.5b76b496@extreme>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger wrote:
> On Thu, 21 Feb 2008 12:28:50 +0100
> Patrick McHardy <kaber@trash.net> wrote:
>
>
>   
>> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
>> index 327e847..b77eb56 100644
>> --- a/net/netfilter/nf_conntrack_core.c
>> +++ b/net/netfilter/nf_conntrack_core.c
>> @@ -256,13 +256,19 @@ __nf_conntrack_find(const struct nf_conntrack_tuple *tuple)
>>  	struct hlist_node *n;
>>  	unsigned int hash = hash_conntrack(tuple);
>>  
>> +	/* Disable BHs the entire time since we normally need to disable them
>> +	 * at least once for the stats anyway.
>> +	 */
>> +	local_bh_disable();
>>     
>
> Use rcu_read_lock instead. local_bh_disable() won't work with some of the other forms
> of RCU alternatives.
>   

The caller already calls rcu_read_lock(). This is for the per-cpu
statistics.

