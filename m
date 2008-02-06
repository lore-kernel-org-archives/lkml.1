Return-Path: <linux-kernel-owner+w=401wt.eu-S932623AbYBFXSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932623AbYBFXSR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 18:18:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932318AbYBFXPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:15:41 -0500
Received: from smtp1.stealer.net ([88.198.224.204]:43026 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764277AbYBFXNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:13:10 -0500
Date: Thu, 7 Feb 2008 00:12:58 +0100 (CET)
From: Sven Wegener <sven.wegener@stealer.net>
To: David Rientjes <rientjes@google.com>
cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipvs: Make the synchronization interval controllable
In-Reply-To: <alpine.DEB.1.00.0802061409130.7879@chino.kir.corp.google.com>
Message-ID: <Pine.LNX.4.64.0802062329150.15729@titan.stealer.net>
References: <1202333990-19359-1-git-send-email-sven.wegener@stealer.net>
 <alpine.DEB.1.00.0802061409130.7879@chino.kir.corp.google.com>
Organization: STEALER.net
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Spam-Score: -1.0
X-Spam-Bar: -
X-Spam-Report: Scanned by SpamAssassin 3.2.1-gr1 2007-05-02 on smtp1.stealer.net at Wed, 06 Feb 2008 23:13:08 +0000
	Bayes: 0.0173 Tokens: new, 167; hammy, 4; neutral, 3; spammy, 0.
	AutoLearn: no
	*  0.1 RDNS_NONE Delivered to trusted network by a host with no rDNS
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0173]
X-Spam-Signature: b7de34a763dc7f54c85d00c01973086ce21c2cb5
X-DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Feb 2008, David Rientjes wrote:

> On Wed, 6 Feb 2008, Sven Wegener wrote:
>
>> diff --git a/net/ipv4/ipvs/ip_vs_sync.c b/net/ipv4/ipvs/ip_vs_sync.c
>> index 948378d..9b57ad3 100644
>> --- a/net/ipv4/ipvs/ip_vs_sync.c
>> +++ b/net/ipv4/ipvs/ip_vs_sync.c
>> @@ -143,6 +143,8 @@ char ip_vs_backup_mcast_ifn[IP_VS_IFNAME_MAXLEN];
>>  /* multicast addr */
>>  static struct sockaddr_in mcast_addr;
>>
>> +/* milliseconds between synchronization runs */
>> +int sysctl_ip_vs_sync_interval = 1000;
>>
>>  static inline void sb_queue_tail(struct ip_vs_sync_buff *sb)
>>  {
>
> How useful is a negative ip_vs_sync_interval?

Negative values will be converted to MAX_JIFFY_OFFSET by msecs_to_jiffies 
and result in a very long interval. A too long interval will be a good way 
to get your system OOM. We could use an unsigned int or even restrict the 
value with proc_dointvec_minmax. I'd prefer the latter, that's what I 
already had in my mind and it also protects from unintentionally choosing 
a too long interval.

Sven
