Return-Path: <linux-kernel-owner+w=401wt.eu-S1762250AbXEZQRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762250AbXEZQRP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 12:17:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbXEZQRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 12:17:04 -0400
Received: from keetweej.vanheusden.com ([213.84.46.114]:55698 "EHLO
	keetweej.vanheusden.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627AbXEZQRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 12:17:01 -0400
Date: Sat, 26 May 2007 18:17:00 +0200
From: Folkert van Heusden <folkert@vanheusden.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Parag Warudkar <parag.warudkar@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.21.1] soft lockup when removing netconsole module
Message-ID: <20070526161645.GA11760@vanheusden.com>
References: <20070526154011.GB3735@vanheusden.com> <465857DF.2020603@gmail.com> <1180195927.4264.11.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1180195927.4264.11.camel@chaos>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Sun May 27 17:52:04 CEST 2007
X-Message-Flag: www.vanheusden.com
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Seems to be hrtimers related - CC'ed Thomas.
> I doubt that. The tick interrupt just finds out, that the machine is
> stuck in rmmod.
> > > Also the rmmod hangs and would not exit even with kill -9. It also
> > > sucks up 100% cpu.
> Can you please enable CONFIG_PROVE_LOCKING ?

Luckily I already had :-)
Here is its output:

[   44.500182] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[   44.500228] ... MAX_LOCKDEP_SUBCLASSES:    8
[   44.500266] ... MAX_LOCK_DEPTH:          30
[   44.500305] ... MAX_LOCKDEP_KEYS:        2048
[   44.500343] ... CLASSHASH_SIZE:           1024
[   44.500383] ... MAX_LOCKDEP_ENTRIES:     8192
[   44.500421] ... MAX_LOCKDEP_CHAINS:      16384
[   44.500459] ... CHAINHASH_SIZE:          8192
[   44.500498]  memory used by lock dependency info: 1096 kB
[   44.500537]  per task-struct memory footprint: 1200 bytes
[   44.500576] ------------------------
[   44.500614] | Locking API testsuite:
[   44.500651] ----------------------------------------------------------------------------
[   44.500697]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[   44.500743]   --------------------------------------------------------------------------
[   44.500794]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[   44.501739]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[   44.502675]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[   44.503617]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[   44.504557]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[   44.505509]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[   44.506469]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[   44.507424]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[   44.508327]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[   44.509245]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[   44.510197]   --------------------------------------------------------------------------
[   44.510243]               recursive read-lock:             |  ok  |             |  ok  |
[   44.510656]            recursive read-lock #2:             |  ok  |             |  ok  |
[   44.511069]             mixed read-write-lock:             |  ok  |             |  ok  |
[   44.511507]             mixed write-read-lock:             |  ok  |             |  ok  |
[   44.511968]   --------------------------------------------------------------------------
[   44.512015]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[   44.512501]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[   44.512998]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[   44.513484]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[   44.513970]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
[   44.514456]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
[   44.514941]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[   44.515425]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[   44.515910]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[   44.516396]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[   44.516882]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[   44.517380]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[   44.517924]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[   44.518417]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[   44.518909]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[   44.519402]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[   44.519896]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[   44.520388]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[   44.520881]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[   44.521388]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[   44.521886]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[   44.522389]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[   44.522907]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[   44.523402]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[   44.523894]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[   44.524387]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[   44.524880]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[   44.525373]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[   44.525866]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[   44.526359]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[   44.526850]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[   44.527342]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[   44.527842]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[   44.528382]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[   44.529025]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[   44.529516]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[   44.530010]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[   44.530501]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[   44.530995]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[   44.531488]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[   44.531980]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[   44.532470]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[   44.532962]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[   44.533478]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[   44.533998]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[   44.534515]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[   44.535017]       hard-irq read-recursion/123:  ok  |
[   44.535227]       soft-irq read-recursion/123:  ok  |
[   44.535440]       hard-irq read-recursion/132:  ok  |
[   44.535652]       soft-irq read-recursion/132:  ok  |
[   44.535865]       hard-irq read-recursion/213:  ok  |
[   44.536079]       soft-irq read-recursion/213:  ok  |
[   44.536291]       hard-irq read-recursion/231:  ok  |
[   44.536504]       soft-irq read-recursion/231:  ok  |
[   44.536742]       hard-irq read-recursion/312:  ok  |
[   44.536979]       soft-irq read-recursion/312:  ok  |
[   44.537216]       hard-irq read-recursion/321:  ok  |
[   44.537454]       soft-irq read-recursion/321:  ok  |
[   44.537693] -------------------------------------------------------
[   44.537733] Good, all 218 testcases passed! |
[   44.537774] ---------------------------------


Folkert van Heusden

-- 
MultiTail ist eine flexible Applikation um Logfiles und Kommando
Eingaben zu überprüfen. Inkl. Filter, Farben, Zusammenführen,
Ansichten etc. http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
