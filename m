Return-Path: <linux-kernel-owner+w=401wt.eu-S1756197AbXH1PKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197AbXH1PKT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 11:10:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753274AbXH1PKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 11:10:05 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:43113 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524AbXH1PKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 11:10:04 -0400
Message-ID: <46D43ABE.2090701@free.fr>
Date: Tue, 28 Aug 2007 17:09:50 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Daniel Walker <dwalker@mvista.com>
CC: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pdflush preemption
References: <46D3FB7F.6060805@free.fr> <1188311169.2435.279.camel@dhcp193.mvista.com>
In-Reply-To: <1188311169.2435.279.camel@dhcp193.mvista.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker wrote:

> John Sigler wrote:
> 
>> Why does pdflush kick in to ruin my party? :-)
>> The expected latency is ~600 µs.
>> http://linux.kernel.free.fr/latency/pdflush.trace
>> Does ide_inb mean I'm reading from the disk?
> 
> Does your real time application lock its memory, or allow itself to be
> swapped?

Now that you mention it, I do remember reading this page:
http://rt.wiki.kernel.org/index.php/HOWTO:_Build_an_RT-application

There is no swap configured on the system, and 90% of the 256 MB of RAM 
are free, according to /proc/meminfo, and the system is otherwise idle.

I don't think this is a major page fault. Am I wrong?

# /bin/time ./check_dektec_output2 4140063957 38000000 2632 30
0.02user 0.31system 0:20.02elapsed 1%CPU
(0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (0major+270minor)pagefaults 0swaps
                   ^^^^^^

# cat /proc/vmstat
nr_free_pages 59351
nr_inactive 1465
nr_active 1830
nr_anon_pages 486
nr_mapped 569
nr_file_pages 2813
nr_dirty 0
nr_writeback 0
nr_slab_reclaimable 449
nr_slab_unreclaimable 663
nr_page_table_pages 41
nr_unstable 0
nr_bounce 0
nr_vmscan_write 0
pgpgin 8197
pgpgout 113
pswpin 0
pswpout 0
pgalloc_dma 0
pgalloc_normal 27260
pgfree 86682
pgactivate 1372
pgdeactivate 0
pgfault 77490
pgmajfault 121
pgrefill_dma 0
pgrefill_normal 0
pgsteal_dma 0
pgsteal_normal 0
pgscan_kswapd_dma 0
pgscan_kswapd_normal 0
pgscan_direct_dma 0
pgscan_direct_normal 0
pginodesteal 0
slabs_scanned 0
kswapd_steal 0
kswapd_inodesteal 0
pageoutrun 0
allocstall 0
pgrotated 0

Regards.
