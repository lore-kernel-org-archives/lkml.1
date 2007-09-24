Return-Path: <linux-kernel-owner+w=401wt.eu-S1761331AbXIXREy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761331AbXIXREy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 13:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758597AbXIXREq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 13:04:46 -0400
Received: from stinky.trash.net ([213.144.137.162]:44270 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758591AbXIXREp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 13:04:45 -0400
Message-ID: <46F7EC0A.9030506@trash.net>
Date: Mon, 24 Sep 2007 18:55:38 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051019)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] Remove broken netfilter binary sysctls from bridging
 code
References: <20070918011841.2381bd93.akpm@linux-foundation.org>	<20070921020554.GE31759@nineveh.local> <m1fy18k5ru.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1fy18k5ru.fsf@ebiederm.dsl.xmission.com>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> jfannin@gmail.com (Joseph Fannin) writes:
> 
> 
>>The netfilter sysctls in the bridging code don't set strategy routines:
>>
>> sysctl table check failed: /net/bridge/bridge-nf-call-arptables .3.10.1 Missing
>>strategy
>> sysctl table check failed: /net/bridge/bridge-nf-call-iptables .3.10.2 Missing
>>strategy
>> sysctl table check failed: /net/bridge/bridge-nf-call-ip6tables .3.10.3 Missing
>>strategy
>> sysctl table check failed: /net/bridge/bridge-nf-filter-vlan-tagged .3.10.4
>>Missing strategy
>> sysctl table check failed: /net/bridge/bridge-nf-filter-pppoe-tagged .3.10.5
>>Missing strategy
>>
>>    These binary sysctls can't work. The binary sysctl numbers of
>>other netfilter sysctls with this problem are being removed.  These
>>need to go as well.
>>
>>Signed-off-by: Joseph Fannin <jfannin@gmail.com>
> 
> 
> Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>


Queued for 2.6.24, thanks.

> Hmm.  This is an interesting case.  The proc method is forcing
> the integer to be either 0 or 1 in a racy fashion.  But none of the
> users appear to depend upon that.
> 
> So this is the least broken set of binary sysctls I have seen caught
> by my check.
> 
> A really good fix would be to remove the binary side and then to
> modify brnf_sysctl_call_tables to allocate a temporary ctl_table and
> integer on the stack and only set ctl->data after we have normalized
> the written value.  But since in practice nothing cares about
> the race a better fix probably isn't worth it.


I seem to be missing something, the entire brnf_sysctl_call_tables
thing looks purely cosmetic to me, wouldn't it be better to simply
remove it?

