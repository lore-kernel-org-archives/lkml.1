Return-Path: <linux-kernel-owner+w=401wt.eu-S1755555AbYKCTrv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555AbYKCTrv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 14:47:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754029AbYKCTrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 14:47:40 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48944 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753222AbYKCTrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 14:47:39 -0500
Date: Mon, 3 Nov 2008 20:47:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: BUG: sleeping function called from invalid context at
	kernel/sched.c:5558
Message-ID: <20081103194721.GA16897@elte.hu>
References: <1225736361.5126.2.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225736361.5126.2.camel@localhost.localdomain>
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


* Thomas Meyer <thomas@m3y3r.de> wrote:

> False positive, while suspend/resume-to/from-disk?
> 
> [19332.352863] BUG: sleeping function called from invalid context at kernel/sched.c:5558
> [19332.352866] in_atomic(): 0, irqs_disabled(): 1, pid: 3287, name: pm-hibernate
> [19332.352869] Pid: 3287, comm: pm-hibernate Tainted: G        W  2.6.28-rc2 #97
> [19332.352871] Call Trace:
> [19332.352878]  [<c0436408>] __might_sleep+0xdc/0xe3
> [19332.352882]  [<c043bbde>] __cond_resched+0x12/0x36
> [19332.352886]  [<c09d29a8>] _cond_resched+0x27/0x32
> [19332.352889]  [<c0697d9c>] acpi_ps_complete_op+0x1e0/0x1ef
> [19332.352892]  [<c069884e>] ? acpi_ps_alloc_op+0x82/0x84
> [19332.352896]  [<c0689814>] ? acpi_ds_exec_end_op+0x30c/0x370
> [19332.352899]  [<c069839f>] acpi_ps_parse_loop+0x5f4/0x721
> [19332.352902]  [<c069779c>] acpi_ps_parse_aml+0x6d/0x267

Such messages are never false positives, this is a real bug.

	Ingo
