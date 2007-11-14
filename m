Return-Path: <linux-kernel-owner+w=401wt.eu-S1763618AbXKNF1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763618AbXKNF1g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 00:27:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750967AbXKNF1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 00:27:24 -0500
Received: from mu-out-0910.google.com ([209.85.134.186]:30537 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbXKNF1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 00:27:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=ALBXQ9lHY3IV0sqj3XH2EuDTAoTkx73jgssh4+IqkOAg2A563y+MCGDI6XfhAnK4R3arLDMYH+GfxWZ7+WKE/ibK4dUkTjFBarCNzYRuRfyBjrQo17J9WxC/CUBonNGG18pzYnQgQFNo5JYoeQuyZm/jpm3RcgpOwP6XBwML6bQ=
Message-ID: <473A8733.3000506@googlemail.com>
Date: Wed, 14 Nov 2007 06:27:15 +0100
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071004)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Ulrich Drepper <drepper@redhat.com>,
       Roland McGrath <roland@redhat.com>
Subject: Re: 2.6.24-rc2-mm1
References: <20071113175906.497a1a6a.akpm@linux-foundation.org>	<473A6E72.60503@googlemail.com> <20071113205544.2a7743b4.akpm@linux-foundation.org>
In-Reply-To: <20071113205544.2a7743b4.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 14 Nov 2007 04:41:38 +0100 Gabriel C <nix.or.die@googlemail.com> wrote:
> 
>> Uff clone-prepare-to-recycle-clone_detached-and-clone_stopped.patch *really* spams.
>> Looks like some programs are using this 'deprecated flag'. 
>>
>> Could this have some CONFIG_SPAM_ME_PLEASE ?;)
>>
>> This is what I got in some minutes :
>>
>>
>> --dmesg|grep 'used deprecated clone flags'|sed 's/.*] //'|sort -u
>> fork(): process `artsd' used deprecated clone flags 0x400000
>> fork(): process `firefox-bin' used deprecated clone flags 0x400000
>> fork(): process `gcompris' used deprecated clone flags 0x400000
>> fork(): process `qgit' used deprecated clone flags 0x400000
>> fork(): process `thunderbird-bin' used deprecated clone flags 0x400000
>> fork(): process `wish' used deprecated clone flags 0x400000
>> fork(): process `xchat' used deprecated clone flags 0x400000
>> fork(): process `kdbus' used deprecated clone flags 0x400000
>>
>> --dmesg|grep 'used deprecated clone flags'|wc -l
>> 151
> 
> hm, that was supposed to shut itself off after 100 messages:
> 
> 	if (unlikely(clone_flags & (CLONE_DETACHED|CLONE_STOPPED))) {
> 		static int __read_mostly count = 100;
> 
> 		if (count && printk_ratelimit()) {
> 			char comm[TASK_COMM_LEN];
> 
> 			count--;
> 			printk(KERN_INFO "fork(): process `%s' used deprecated "
> 					"clone flags 0x%lx\n",
> 				get_task_comm(comm, current),
> 				clone_flags & (CLONE_DETACHED|CLONE_STOPPED));
> 		}
> 	}
> 
> I don't see how you got 151 instances.  I guess I'm having another stupid
> day.
> 

No idea how I got this I just grepped the dmesg =)

> Oh well.  That's CLONE_DETACHED and I think Ulrich's question just got
> answered.
> 
> Which distro/version are you running?

I'm using Frugalware Linux 'current' right now with the following software :

 -- sh scripts/ver_linux
 If some fields are empty or look unusual you may have an old version.
 Compare to the current minimal requirements in Documentation/Changes.
 
 Linux lara 2.6.24-rc2-mm1 #4 SMP Wed Nov 14 05:47:48 CET 2007 i686 Intel(R) Xeon(TM) CPU 2.00GHz GenuineIntel GNU/Linux
 
 Gnu C                  4.2.2
 Gnu make               3.81
 binutils               2.18.50.0.2.20071001
 util-linux             2.13
 mount                  2.13
 module-init-tools      3.2.2
 e2fsprogs              1.40.2
 xfsprogs               2.9.4
 pcmciautils            014
 Linux C Library        2.7
 Dynamic linker (ldd)   2.7
 Linux C++ Library      so.6.0
 Procps                 3.2.7
 Net-tools              1.60
 Kbd                    1.12
 Sh-utils               6.9
 udev                   116
 Modules Loaded         fuse pc87360 hwmon_vid eeprom adm1021 ext4dev jbd2 crc16 loop lp 3c59x intel_agp mii agpgart sr_mod parport_pc cdrom iTCO_wdt parport thermal dcdbas i82860_edac iTCO_vendor_support evdev i2c_i801 button pcspkr processor edac_core watchdog_core shpchp pci_hotplug watchdog_dev

> 
> Thanks for letting us know....
> 


