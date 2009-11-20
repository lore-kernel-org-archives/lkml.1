Return-Path: <linux-kernel-owner+w=401wt.eu-S1755155AbZKTSlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155AbZKTSlg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 13:41:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753974AbZKTSlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 13:41:36 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:41979 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbZKTSlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 13:41:35 -0500
Date: Fri, 20 Nov 2009 10:40:30 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Subject: Re: linux-next: Tree for November 20 (snd_jack)
Message-Id: <20091120104030.01972d33.randy.dunlap@oracle.com>
In-Reply-To: <20091120230513.0d2e5cb5.sfr@canb.auug.org.au>
References: <20091120230513.0d2e5cb5.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4B06E2D6.01EC:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Nov 2009 23:05:13 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20091119:


This commit in linux-next-20091120:

author	Mark Brown <broonie@opensource.wolfsonmicro.com>	
	Mon, 28 Jul 2008 18:05:36 +0000 (19:05 +0100)
committer	Jaroslav Kysela <perex@perex.cz>	
	Tue, 29 Jul 2008 19:32:06 +0000 (21:32 +0200)
commit	0d94e41abe271c86df06bcf72d24f9ca7ce771f0

causes build errors when:

CONFIG_INPUT=m
CONFIG_SND=y
CONFIG_SND_JACK=y
CONFIG_SND_SOC=m
CONFIG_SND_HDA_INTEL=m
CONFIG_SND_HDA_INPUT_JACK=y

At least part of the problem is that when a tristate kconfig symbol with
a value of 'm' selects a boolean kconfig symbol, the boolean becomes 'y',
so we end up with
snd-$(CONFIG_SND_JACK)	  += jack.o
being built into the kernel image and INPUT=m, giving:

sound/built-in.o: In function `snd_jack_report':
(.text+0xb5c5): undefined reference to `input_event'
sound/built-in.o: In function `snd_jack_report':
(.text+0xb627): undefined reference to `input_event'
sound/built-in.o: In function `snd_jack_dev_register':
jack.c:(.text+0xb736): undefined reference to `input_register_device'
sound/built-in.o: In function `snd_jack_dev_free':
jack.c:(.text+0xb806): undefined reference to `input_unregister_device'
jack.c:(.text+0xb861): undefined reference to `input_free_device'
sound/built-in.o: In function `snd_jack_new':
(.text+0xb953): undefined reference to `input_allocate_device'
sound/built-in.o: In function `snd_jack_new':
(.text+0xba0d): undefined reference to `input_set_capability'
sound/built-in.o: In function `snd_jack_new':
(.text+0xba2c): undefined reference to `input_free_device'

---
~Randy
