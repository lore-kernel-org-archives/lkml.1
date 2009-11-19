Return-Path: <linux-kernel-owner+w=401wt.eu-S1755866AbZKSOid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866AbZKSOid (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 09:38:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754022AbZKSOid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 09:38:33 -0500
Received: from stinky.trash.net ([213.144.137.162]:43825 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346AbZKSOic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 09:38:32 -0500
Message-ID: <4B05586C.5020308@trash.net>
Date: Thu, 19 Nov 2009 15:38:36 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Patrick Mullaney <pmullaney@novell.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Edge Virtual Bridging <evb@yahoogroups.com>,
       Anna Fischer <anna.fischer@hp.com>, bridge@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       Jens Osterkamp <jens@linux.vnet.ibm.com>,
       Gerhard Stenzel <gerhard.stenzel@de.ibm.com>
Subject: Re: [PATCH 3/3] macvlan: export macvlan mode through netlink
References: <1258497551-25959-1-git-send-email-arnd@arndb.de> <1258497551-25959-4-git-send-email-arnd@arndb.de> <4B0398D4.8030904@gmail.com> <200911181059.45331.arnd@arndb.de>
In-Reply-To: <200911181059.45331.arnd@arndb.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Wednesday 18 November 2009, Eric Dumazet wrote:
>>> --- a/drivers/net/macvlan.c
>>> +++ b/drivers/net/macvlan.c
>>> @@ -33,12 +33,6 @@
>>>  
>>>  #define MACVLAN_HASH_SIZE    (1 << BITS_PER_BYTE)
>>>  
>>> -enum macvlan_type {
>>> -     MACVLAN_PRIVATE         = 1,
>>> -     MACVLAN_VEPA            = 2,
>>> -     MACVLAN_BRIDGE          = 4,
>>> -};
>> I realize you defined MACVLAN_PRIVATE in patch 2, but used MACVLAN_MODE_PRIVATE,
>> so patch 2 is not compilable and breaks bisection ?
>>
> 
> Hmm, right. I'll fix that up as well.

> +enum ifla_macvlan_mode {
> +	MACVLAN_MODE_PRIVATE = 1, /* don't talk to other macvlans */
> +	MACVLAN_MODE_VEPA    = 2, /* talk to other ports through ext bridge */
> +	MACVLAN_MODE_BRIDGE  = 4, /* talk to bridge ports directly */
> +};

Please also keep the enum named something without ifla_ since
the mode values themselves are not netlink attributes. Just
macvlan_mode seems fine.
