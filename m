Return-Path: <linux-kernel-owner+w=401wt.eu-S1754580AbZC3MHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580AbZC3MHF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 08:07:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751599AbZC3MGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 08:06:52 -0400
Received: from stinky.trash.net ([213.144.137.162]:59409 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbZC3MGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 08:06:51 -0400
Message-ID: <49D0B5D9.3070405@trash.net>
Date: Mon, 30 Mar 2009 14:06:49 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Roman Mindalev <r000n@r000n.net>
CC: Stephen Hemminger <shemminger@vyatta.com>,
       Eric Dumazet <dada1@cosmosbay.com>, LKML <linux-kernel@vger.kernel.org>,
       netfilter@vger.kernel.org
Subject: Re: Regression caused by commit "netfilter: iptables: lock free counters"
References: <20090329234702.4988017f@desktop.r000n.info>
In-Reply-To: <20090329234702.4988017f@desktop.r000n.info>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roman Mindalev wrote:
> Since 2.6.29-git1 I got many debug messages in kernel log.
> One from them:
> 
> Mar 29 12:06:11 desktop kernel: [  917.414369] BUG: using
> smp_processor_id() in preemptible [00000000] code: hddtemp/2820 Mar 29
> 12:06:11 desktop kernel: [  917.414378] caller is
> ipt_do_table+0xd0/0x3a8 [ip_tables]

Stephen, please have a look at this. I think we need to disable
preemption in *t_do_table() for PREEMPT_RCU.

