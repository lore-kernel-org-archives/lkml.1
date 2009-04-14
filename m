Return-Path: <linux-kernel-owner+w=401wt.eu-S1757655AbZDNQwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757655AbZDNQwV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 12:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754107AbZDNQwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 12:52:04 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:9855 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338AbZDNQwB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 12:52:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ei63GrtCBZAWsT16RCeNkK0JifI2F6nxFcwEpMsgSaiZkXDMaJ3VpvErM/QPh+bOEh
         A/jjt87iuhogqOFmdlJU9TZ940lyJqCe1dRjtAAJeqik6OWVj/eYE/sk9mqmQCYaJE8k
         LgpBhDDTSI2xxWso2g4zR7KaSmJvzkVaefvi0=
MIME-Version: 1.0
In-Reply-To: <49E4B0A5.70404@cosmosbay.com>
References: <20090411174801.GG6822@linux.vnet.ibm.com>
	 <18913.53699.544083.320542@cargo.ozlabs.ibm.com>
	 <20090412173108.GO6822@linux.vnet.ibm.com>
	 <20090412.181330.23529546.davem@davemloft.net>
	 <20090413040413.GQ6822@linux.vnet.ibm.com>
	 <20090413095309.631cf395@nehalam> <49E48136.5060700@trash.net>
	 <49E49C65.8060808@cosmosbay.com> <20090414074554.7fa73e2f@nehalam>
	 <49E4B0A5.70404@cosmosbay.com>
Date: Wed, 15 Apr 2009 00:51:59 +0800
Message-ID: <b6a2187b0904140951r3c6a41fdnc26b149202bdfa84@mail.gmail.com>
Subject: Re: [PATCH] netfilter: use per-cpu spinlock rather than RCU
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>,
       Patrick McHardy <kaber@trash.net>, paulmck@linux.vnet.ibm.com,
       David Miller <davem@davemloft.net>, paulus@samba.org, mingo@elte.hu,
       torvalds@linux-foundation.org, laijs@cn.fujitsu.com, jengelh@medozas.de,
       r000n@r000n.net, linux-kernel@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       benh@kernel.crashing.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 11:49 PM, Eric Dumazet <dada1@cosmosbay.com> wrote:
> Stephen Hemminger a écrit :
>> On Tue, 14 Apr 2009 16:23:33 +0200
>> Eric Dumazet <dada1@cosmosbay.com> wrote:
>>
>>> Patrick McHardy a écrit :
>>>> Stephen Hemminger wrote:
>>>>> This is an alternative version of ip/ip6/arp tables locking using
>>>>> per-cpu locks.  This avoids the overhead of synchronize_net() during
>>>>> update but still removes the expensive rwlock in earlier versions.

Tested. Loaded as fast as 2.6.29.

> Here is an updated patch ontop of yours, with the smp_wmb() in xt_replace_table() :

Tested as well. Loaded as fast as 2.6.29.

Thanks,
Jeff.
