Return-Path: <linux-kernel-owner+w=401wt.eu-S1753876AbXDWP6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbXDWP6K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 11:58:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753888AbXDWP6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 11:58:10 -0400
Received: from keetweej.vanheusden.com ([213.84.46.114]:32920 "EHLO
	keetweej.vanheusden.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876AbXDWP6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 11:58:08 -0400
Date: Mon, 23 Apr 2007 17:58:06 +0200
From: Folkert van Heusden <folkert@vanheusden.com>
To: linux-kernel@vger.kernel.org
Subject: [2.6.20] system sometimes stops responding
Message-ID: <20070423155800.GA20799@vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Tue Apr 24 17:43:51 CEST 2007
X-Message-Flag: www.unixexpert.nl
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

System: kernel 2.6.20
        P4
	2GB ram
	512 MB swap

Situation:
Sometimes systems stops. SSH session stop. New logins proceed but just
before the command-prompt they exit again (after a delay of, say, 30s)
and return to the login prompt. New ssh logins do not even reach the
login-prompt. Network seems to still forward traffic and also the system
seems still be doing diskflushes.

I pressed sysreq m which gives:

[3535562.643029] SysRq : Show Memory
[3535562.643113] Mem-info:
[3535562.643153] DMA per-cpu:
[3535562.643193] CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
[3535562.643242] CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
[3535562.643290] Normal per-cpu:
[3535562.643330] CPU    0: Hot: hi:  186, btch:  31 usd: 152   Cold: hi:   62, btch:  15 usd:  13
[3535562.643379] CPU    1: Hot: hi:  186, btch:  31 usd: 128   Cold: hi:   62, btch:  15 usd:   0
[3535562.643426] HighMem per-cpu:
[3535562.643466] CPU    0: Hot: hi:  186, btch:  31 usd: 156   Cold: hi:   62, btch:  15 usd:  14
[3535562.643516] CPU    1: Hot: hi:  186, btch:  31 usd:  81   Cold: hi:   62, btch:  15 usd:   9
[3535562.643566] Active:321905 inactive:152128 dirty:18 writeback:0 unstable:0 free:21864 slab:16213 mapped:15187 pagetables:1797
[3535562.643619] DMA free:9876kB min:68kB low:84kB high:100kB active:1276kB inactive:3616kB present:16256kB pages_scanned:0 all_unreclaimable? no
[3535562.643670] lowmem_reserve[]: 0 873 2015
[3535562.643838] Normal free:71724kB min:3744kB low:4680kB high:5616kB active:349232kB inactive:375312kB present:894080kB pages_scanned:0 all_unreclaimable? no
[3535562.643891] lowmem_reserve[]: 0 0 9137
[3535562.644060] HighMem free:5856kB min:512kB low:1736kB high:2960kB active:937112kB inactive:229584kB present:1169608kB pages_scanned:0 all_unreclaimable? no
[3535562.644113] lowmem_reserve[]: 0 0 0
[3535562.644280] DMA: 339*4kB 47*8kB 161*16kB 50*32kB 8*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 9876kB
[3535562.644713] Normal: 2151*4kB 2684*8kB 1327*16kB 486*32kB 20*64kB 6*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 71724kB
[3535562.645147] HighMem: 432*4kB 406*8kB 11*16kB 10*32kB 0*64kB 1*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 5856kB
[3535562.645588] Swap cache: add 2474, delete 2458, find 601/816, race 0+0
[3535562.645633] Free swap  = 454424kB
[3535562.645675] Total swap = 454600kB
[3535562.645714] Free swap:       454424kB
[3535562.653672] 524080 pages of RAM
[3535562.653725] 294704 pages of HIGHMEM
[3535562.653765] 5929 reserved pages
[3535562.653807] 175200 pages shared
[3535562.653846] 16 pages swap cached
[3535562.653886] 18 pages dirty
[3535562.653926] 0 pages writeback
[3535562.653966] 15187 pages mapped
[3535562.654005] 16213 pages slab
[3535562.654046] 1797 pages pagetables
[3535580.176308] SysRq : Emergency Sync

So it looks like it is NOT out of memory.

Last messages before I pressed sysreg m:

[3535514.466556] Sig 3 send to 5432 owned by 0.0 (login)
[3535514.466748] kobject_uevent_env
[3535514.466795] fill_kobj_path: path = '/class/vc/vcs3'
[3535514.466919] kobject vcs3: cleaning up
[3535514.466970] kobject_uevent_env
[3535514.467014] fill_kobj_path: path = '/class/vc/vcsa3'
[3535514.467110] kobject vcsa3: cleaning up
[3535514.467774] kobject vcs3: registering. parent: vc, set: devices
[3535514.467863] kobject_uevent_env
[3535514.467927] fill_kobj_path: path = '/class/vc/vcs3'
[3535514.468272] kobject vcsa3: registering. parent: vc, set: devices
[3535514.468356] kobject_uevent_env
[3535514.468414] fill_kobj_path: path = '/class/vc/vcsa3'
[3535514.469533] kobject_uevent_env
[3535514.469586] fill_kobj_path: path = '/class/vc/vcs3'
[3535514.469729] kobject vcs3: cleaning up
[3535514.469781] kobject_uevent_env
[3535514.469822] fill_kobj_path: path = '/class/vc/vcsa3'
[3535514.469919] kobject vcsa3: cleaning up
[3535514.469998] kobject vcs3: registering. parent: vc, set: devices
[3535514.470059] kobject_uevent_env
[3535514.470102] fill_kobj_path: path = '/class/vc/vcs3'
[3535514.470207] kobject vcsa3: registering. parent: vc, set: devices
[3535514.470260] kobject_uevent_env
[3535514.470305] fill_kobj_path: path = '/class/vc/vcsa3'

(as you can see, the login process gets shot by signal 3 (SIGQUIT))

Anything else I can try?
I also found a list of stacktraces of all processes running in the
system.


Folkert van Heusden

-- 
To MultiTail einai ena polymorfiko ergaleio gia ta logfiles kai tin
eksodo twn entolwn. Prosferei: filtrarisma, xrwmatismo, sygxwneysi,
diaforetikes provoles. http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
