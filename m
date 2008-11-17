Return-Path: <linux-kernel-owner+w=401wt.eu-S1754542AbYKQRjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542AbYKQRjX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 12:39:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752497AbYKQRjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 12:39:14 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47427 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752317AbYKQRjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 12:39:13 -0500
Date: Mon, 17 Nov 2008 18:38:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix wakeup_cpu with numaq/es7000 v2
Message-ID: <20081117173859.GB7686@elte.hu>
References: <491FDE2A.1010809@kernel.org> <49200031.2040701@kernel.org> <20081117165224.GH12081@elte.hu> <20081117173728.GA7384@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081117173728.GA7384@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> hm, one of my testboxes is rather unhappy about your patch:
> 
> [   54.718062] SMP alternatives: switching to SMP code
> [   55.083610] Booting processor 1 APIC 0x1 ip 0x6000
> [   55.088329] BUG: unable to handle kernel paging request at ffffffff817b0880
> [   55.092304] IP: [<ffffffff80f5ce20>] native_cpu_up+0x410/0xf30

triggered via:

echo 0 > /sys/devices/system/cpu/cpu1/online
sleep 1
echo 1 > /sys/devices/system/cpu/cpu1/online
sleep 1
echo 0 > /sys/devices/system/cpu/cpu1/online
sleep 1
echo 1 > /sys/devices/system/cpu/cpu1/online
sleep 1

	Ingo
