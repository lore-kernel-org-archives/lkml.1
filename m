Return-Path: <linux-kernel-owner+w=401wt.eu-S1760698AbZCYRIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760698AbZCYRIZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 13:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755043AbZCYRHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 13:07:47 -0400
Received: from stinky.trash.net ([213.144.137.162]:34958 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbZCYRHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 13:07:45 -0400
Message-ID: <49CA64D8.9040602@trash.net>
Date: Wed, 25 Mar 2009 18:07:36 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: Francis.Dupont@fdupont.fr, linux-kernel@vger.kernel.org,
       coreteam@netfilter.org, Francis_Dupont@isc.org,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: netfilter spurious ELOOP
References: <200903242302.n2ON25u4024288@givry.fdupont.fr> <20090324.162808.114465835.davem@davemloft.net>
In-Reply-To: <20090324.162808.114465835.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Francis Dupont <Francis.Dupont@fdupont.fr>
> Date: Wed, 25 Mar 2009 00:02:05 +0100
> 
> Adding correct CC:'s
> 
>> summary: iptables command gets spurious ELOOP errors
>>
>> report: when a rule with a target like MARK --set-mark 0x80000001
>> then adding new other rules can failed with "Too many levels of symbolic
>> links" (aka ELOOP) error.
>> The problem is in kernel net/ipv4/netfilter/ip_tables.c in the 
>> mark_source_chains() routine which checks the verdict field of
>> targets even for not standard targets.
>>
>> keywords: netfilter target eloop
>>
>> environment: recent gentoo and fedora. Problem not fixed in
>> linux-2.6.29 (last stable version taken from kernel.org some minutes ago).

Just to clarify: does the problem happens when you have the MARK rule
above in a user-defined chain that has more then one jump leading to
it or does it also happen in other cases?
