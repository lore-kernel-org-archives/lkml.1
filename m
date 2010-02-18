Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758624Ab0BRR3x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 12:29:53 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:53024 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757583Ab0BRR3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 12:29:51 -0500
Message-ID: <4B7D7617.9070600@oracle.com>
Date: Thu, 18 Feb 2010 09:17:11 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Patrick McHardy <kaber@trash.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, netfilter-devel@vger.kernel.org,
       Netdev <netdev@vger.kernel.org>
Subject: Re: linux-next: Tree for February 18 (netfilter)
References: <20100218204937.54a613d2.sfr@canb.auug.org.au> <4B7D70D0.9090003@oracle.com> <4B7D72FF.4010401@trash.net>
In-Reply-To: <4B7D72FF.4010401@trash.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4B7D7631.00FB:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/10 09:03, Patrick McHardy wrote:
> Randy Dunlap wrote:
>> On 02/18/10 01:49, Stephen Rothwell wrote:
>>> Hi all,
>>>
>>> Changes since 20100217:
>>>
>>> The net tree lost its build failure but gained a conflict against the kvm
>>> tree.
>>
>>
>> include/net/netfilter/nf_conntrack.h:94: error: field 'ct_general' has incomplete type
>> include/net/netfilter/nf_conntrack.h:178: error: 'const struct sk_buff' has no member named 'nfct'
>> include/net/netfilter/nf_conntrack.h:185: error: implicit declaration of function 'nf_conntrack_put'
>> include/net/netfilter/nf_conntrack.h:294: error: 'const struct sk_buff' has no member named 'nfct'
>> net/ipv4/netfilter/nf_defrag_ipv4.c:45: error: 'struct sk_buff' has no member named 'nfct'
>> net/ipv4/netfilter/nf_defrag_ipv4.c:46: error: 'struct sk_buff' has no member named 'nfct'
>>
>> CONFIG_NF_CONNTRACK is not enabled
>> but CONFIG_NF_DEFRAG_IPV4=y.  It is "select"ed by
>> NETFILTER_XT_MATCH_SOCKET and NETFILTER_XT_TARGET_TPROXY,
>> both of which are enabled.
>>
>> Hm, NETFILTER_XT_MATCH_SOCKET depends on !NF_CONNTRACK || NF_CONNTRACK.
>> Maybe NETFILTER_XT_TARGET_TPROXY needs to do that also.  No, that would
>> go against that config option's help text:
> 
> No, the problem is use of skb->nfct without CONFIG_NF_CONNTRACK.
> 
> This patch should fix it.

Nope:

In file included from /lnx/src/NEXT/linux-next-20100218/include/net/netfilter/nf_conntrack_extend.h:4,
                 from /lnx/src/NEXT/linux-next-20100218/include/net/netfilter/nf_conntrack_zones.h:4,
                 from /lnx/src/NEXT/linux-next-20100218/net/ipv4/netfilter/nf_defrag_ipv4.c:19:
/lnx/src/NEXT/linux-next-20100218/include/net/netfilter/nf_conntrack.h:94: error: field 'ct_general' has incomplete type
/lnx/src/NEXT/linux-next-20100218/include/net/netfilter/nf_conntrack.h: In function 'nf_ct_get':
/lnx/src/NEXT/linux-next-20100218/include/net/netfilter/nf_conntrack.h:178: error: 'const struct sk_buff' has no member named 'nfct'
/lnx/src/NEXT/linux-next-20100218/include/net/netfilter/nf_conntrack.h: In function 'nf_ct_put':
/lnx/src/NEXT/linux-next-20100218/include/net/netfilter/nf_conntrack.h:185: error: implicit declaration of function 'nf_conntrack_put'
/lnx/src/NEXT/linux-next-20100218/include/net/netfilter/nf_conntrack.h: In function 'nf_ct_is_untracked':
/lnx/src/NEXT/linux-next-20100218/include/net/netfilter/nf_conntrack.h:294: error: 'const struct sk_buff' has no member named 'nfct'
make[4]: *** [net/ipv4/netfilter/nf_defrag_ipv4.o] Error 1


-- 
~Randy
