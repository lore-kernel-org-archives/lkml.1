Return-Path: <linux-kernel-owner+w=401wt.eu-S1758061AbXI2O51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758061AbXI2O51 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 10:57:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754838AbXI2O5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 10:57:18 -0400
Received: from postfix1-g20.free.fr ([212.27.60.42]:55461 "EHLO
	postfix1-g20.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022AbXI2O5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 10:57:17 -0400
Message-ID: <46FE6751.3050205@free.fr>
Date: Sat, 29 Sep 2007 16:55:13 +0200
From: Cedric Le Goater <legoater@free.fr>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
       David Miller <davem@davemloft.net>
Subject: Re: 2.6.23-rc8-mm2 - tcp_fastretrans_alert() WARNING
References: <20070927022220.c76a7a6e.akpm@linux-foundation.org> <46FD20F0.3050909@fr.ibm.com> <Pine.LNX.4.64.0709282143020.6013@kivilampi-30.cs.helsinki.fi> <Pine.LNX.4.64.0709291532200.6776@kivilampi-30.cs.helsinki.fi>
In-Reply-To: <Pine.LNX.4.64.0709291532200.6776@kivilampi-30.cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ilpo Järvinen wrote:
> On Fri, 28 Sep 2007, Ilpo Järvinen wrote:
>> On Fri, 28 Sep 2007, Cedric Le Goater wrote:
>>
>>> I just found that warning in my logs. It seems that it's been 
>>> happening since rc7-mm1 at least. 
>>>
>>> WARNING: at /home/legoater/linux/2.6.23-rc8-mm2/net/ipv4/tcp_input.c:2314 tcp_fastretrans_alert()
>>>
>>> Call Trace:
>>>  <IRQ>  [<ffffffff8040fdc3>] tcp_ack+0xcd6/0x1894
>>> ...snip...
>> ...Thanks for the report, I'll have look what could still break 
>> fackets_out...
> 
> I think this one is now clear to me, tcp_fragment/collapse adjusts 
> fackets_out (incorrectly) also for reno flow when there were some dupACKs 
> that made sacked_out != 0. Could you please try if patch below proves all 
> them to be of non-SACK origin... In case that's true, it's rather 
> harmless, I'll send a fix on Monday or so (this would anyway be needed)... 
> If you find out that them occur with SACK enabled flow, that would be
> more interesting and requires more digging...

I'm trying now to reproduce this WARNING. 

It seems that the n/w behaves differently during the week ends. Probably
taking a break. 

C.
