Return-Path: <linux-kernel-owner+w=401wt.eu-S1752770AbYIZLOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbYIZLOg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 07:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751374AbYIZLO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 07:14:27 -0400
Received: from mga10.intel.com ([192.55.52.92]:63908 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750875AbYIZLO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 07:14:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,313,1220252400"; 
   d="scan'208";a="384690163"
Message-ID: <48DCC403.7070302@linux.intel.com>
Date: Fri, 26 Sep 2008 04:14:11 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Suresh Siddha <suresh.b.siddha@intel.com>,
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
References: <20080926014334.GF15609@linux-os.sc.intel.com> <20080926073902.GA30041@elte.hu> <20080926081226.GA8556@elte.hu> <20080926083542.GA5431@elte.hu> <20080926094634.GA13527@elte.hu>
In-Reply-To: <20080926094634.GA13527@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>
>> mapping the EBDA is rather ... un-nice from that driver, so i guess 
>> you check does the right thing in flagging possible crap.
> 
> it does:
> 
>     addr:  0x9f800
>      end:  0xaf5e7
> p->start:  0x9f800
>   p->end:  0x9ffff
> 
> resources are laid out like this:
> 
>   0009f800-0009ffff : reserved
>   000a0000-000bffff : Video RAM area
> 
> so the driver over-maps into the Video RAM...

... and makes that uncachable (while it probably was WC before)

