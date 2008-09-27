Return-Path: <linux-kernel-owner+w=401wt.eu-S1753585AbYI0QgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585AbYI0QgR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 12:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752697AbYI0QgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 12:36:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57268 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654AbYI0QgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 12:36:06 -0400
Date: Sat, 27 Sep 2008 18:35:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Linas Vepstas <linas@austin.ibm.com>,
       "rajesh.shah@intel.com" <rajesh.shah@intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Kristen Accardi <kristen.c.accardi@intel.com>,
       Muli Ben-Yehuda <muli@il.ibm.com>, jbarnes@virtuousgeek.org,
       tglx@linutronix.de, hpa@zytor.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] x86, pci-hotplug, calgary / rio: fix EBDA ioremap()
Message-ID: <20080927163528.GD4600@elte.hu>
References: <20080926014334.GF15609@linux-os.sc.intel.com> <20080926073902.GA30041@elte.hu> <20080926081226.GA8556@elte.hu> <20080926083542.GA5431@elte.hu> <20080926094634.GA13527@elte.hu> <48DCC403.7070302@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48DCC403.7070302@linux.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arjan van de Ven <arjan@linux.intel.com> wrote:

>>>
>>> mapping the EBDA is rather ... un-nice from that driver, so i guess  
>>> you check does the right thing in flagging possible crap.
>>
>> it does:
>>
>>     addr:  0x9f800
>>      end:  0xaf5e7
>> p->start:  0x9f800
>>   p->end:  0x9ffff
>>
>> resources are laid out like this:
>>
>>   0009f800-0009ffff : reserved
>>   000a0000-000bffff : Video RAM area
>>
>> so the driver over-maps into the Video RAM...
>
> ... and makes that uncachable (while it probably was WC before)

ah, neat angle, i did not consider that. One more entry into the '10 
good reasons why ioremap-ing RAM is bad' list.

	Ingo
