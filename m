Return-Path: <linux-kernel-owner+w=401wt.eu-S1757033AbYJNLsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757033AbYJNLsf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 07:48:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755274AbYJNLsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 07:48:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56106 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755261AbYJNLsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 07:48:21 -0400
Date: Tue, 14 Oct 2008 13:48:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Patrick McHardy <kaber@trash.net>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, shemminger@linux-foundation.org,
       netdev@vger.kernel.org, containers@lists.linux-foundation.org,
       kaber@trash.et, "David S. Miller" <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, Jan Engelhardt <jengelh@computergmbh.de>,
       Netfilter Development Mailinglist 
	<netfilter-devel@vger.kernel.org>
Subject: Re: [bug, -git] ERROR: "ebt_unregister_table"
	[net/bridge/netfilter/ebtable_nat.ko] undefined
Message-ID: <20081014114806.GA20480@elte.hu>
References: <20080821221943.GO31136@x200.localdomain> <20081013070347.GA3813@elte.hu> <20081013070940.GA6340@elte.hu> <20081013073501.GB4254@x200.localdomain> <20081014103005.GA19420@elte.hu> <48F47BB9.9090902@trash.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F47BB9.9090902@trash.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Patrick McHardy <kaber@trash.net> wrote:

> Ingo Molnar wrote:
>> i think you misunderstood my report. This is about latest upstream -git 
>> being broken:
>>
>> ERROR: "ebt_register_table" [net/bridge/netfilter/ebtable_filter.ko] undefined!
>> ERROR: "ebt_do_table" [net/bridge/netfilter/ebtable_filter.ko] undefined!
>> ERROR: "ebt_unregister_table" [net/bridge/netfilter/ebtable_filter.ko] undefined!
>> ERROR: "ebt_register_table" [net/bridge/netfilter/ebtable_broute.ko] undefined!
>> ERROR: "ebt_do_table" [net/bridge/netfilter/ebtable_broute.ko] undefined!
>> ERROR: "ebt_unregister_table" [net/bridge/netfilter/ebtable_broute.ko] undefined!
>> make[1]: *** [__modpost] Error 1
>> make: *** [modules] Error 2
>>
>> i posted to this thread because i wanted to find a relevant context.  
>> (but probably is not)
>>
>> Anyway, i started a new thread for this.
>>
>> the dependencies there look pretty complex so i did not find a quick 
>> fix - but i can test patches.
>
> This appears to be caused by Jan's Kconfig changes to use menuconfig,
> which lost a dependency on BRIDGE:
>
> -menu "Bridge: Netfilter Configuration"
> -       depends on BRIDGE && BRIDGE_NETFILTER
> -
> -config BRIDGE_NF_EBTABLES
> +menuconfig BRIDGE_NF_EBTABLES
>         tristate "Ethernet Bridge tables (ebtables) support"
>         select NETFILTER_XTABLES
>         help
>           ebtables is a general, extensible frame/packet identification
>           framework. Say 'Y' or 'M' here if you want to do Ethernet
>           filtering/NAT/brouting on the Ethernet bridge.
>
> Does this patch fix it?

yeah, the module build now succeeds fine with that config, thanks 
Patrick!

Tested-by: Ingo Molnar <mingo@elte.hu>

	Ingo
