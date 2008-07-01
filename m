Return-Path: <linux-kernel-owner+w=401wt.eu-S1758163AbYGAJWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163AbYGAJWb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 05:22:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755151AbYGAJWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 05:22:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48658 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753881AbYGAJWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 05:22:18 -0400
Date: Tue, 1 Jul 2008 11:21:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Nick Piggin <npiggin@suse.de>, Mark McLoughlin <markmc@redhat.com>,
       xen-devel <xen-devel@lists.xensource.com>,
       Eduardo Habkost <ehabkost@redhat.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Stephen Tweedie <sct@redhat.com>, x86@kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [Xen-devel] Re: [PATCH 00 of 36] x86/paravirt: groundwork for
	64-bit Xen support
Message-ID: <20080701092152.GA18918@elte.hu>
References: <20080626105818.GA13805@elte.hu> <4863A8E6.1010807@goop.org> <20080627160333.GA27072@elte.hu> <486539A3.3030102@goop.org> <20080629084318.GA28815@elte.hu> <48684CD4.7040403@goop.org> <20080630082135.GA22844@elte.hu> <20080630092209.GA29815@elte.hu> <48696690.90907@goop.org> <20080701085204.GA23289@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080701085204.GA23289@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> great - i've applied your fix and re-integrated x86/xen-64bit, it's 
> under testing now. (no problems so far)

hm, -tip testing still triggers a 64-bit bootup crash:

[    0.000000] init_memory_mapping
[    0.000000] kernel direct mapping tables up to 3fff0000 @ 8000-a000
PANIC: early exception 0e rip 10:ffffffff80418f81 error 0 cr2 ffffffffff300000
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.26-rc8-tip #13363
[    0.000000]
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff807f088b>] ? init_memory_mapping+0x341/0x56b
[    0.000000]  [<ffffffff80dba19f>] early_idt_handler+0x5f/0x73
[    0.000000]  [<ffffffff80418f81>] ? __memcpy_fromio+0xd/0x1e
[    0.000000]  [<ffffffff80de238a>] dmi_scan_machine+0x41/0x19b
[    0.000000]  [<ffffffff80dbeba8>] setup_arch+0x46d/0x5d8
[    0.000000]  [<ffffffff802896a0>] ? kernel_text_unlock+0x10/0x12
[    0.000000]  [<ffffffff80263b86>] ? raw_notifier_chain_register+0x9/0xb
[    0.000000]  [<ffffffff80dba140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff80dbac5a>] start_kernel+0xf4/0x3b3
[    0.000000]  [<ffffffff80dba140>] ? early_idt_handler+0x0/0x73
[    0.000000]  [<ffffffff80dba2a4>] x86_64_start_reservations+0xa9/0xad
[    0.000000]  [<ffffffff80dba3b8>] x86_64_start_kernel+0x110/0x11f
[    0.000000]

  http://redhat.com/~mingo/misc/crash.log-Tue_Jul__1_10_55_47_CEST_2008.bad
  http://redhat.com/~mingo/misc/config-Tue_Jul__1_10_55_47_CEST_2008.bad

Excluding the x86/xen-64bit topic solves the problem.

It triggered on two 64-bit machines so it seems readily reproducible 
with that config.

i've pushed the failing tree out to tip/tmp.xen-64bit.Tue_Jul__1_10_55

	Ingo

