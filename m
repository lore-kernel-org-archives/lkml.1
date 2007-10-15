Return-Path: <linux-kernel-owner+w=401wt.eu-S1764725AbXJOTZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764725AbXJOTZ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 15:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757332AbXJOTZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 15:25:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50047 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756608AbXJOTZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 15:25:15 -0400
Date: Mon, 15 Oct 2007 21:24:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Boaz Harrosh <bharrosh@panasas.com>,
       James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch] scsi: fix crash in gdth_timeout()
Message-ID: <20071015192456.GA9046@elte.hu>
References: <20071015165534.GA17833@elte.hu> <alpine.LFD.0.999.0710151006400.6887@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0710151006400.6887@woody.linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, 15 Oct 2007, Ingo Molnar wrote:
> > 
> > A further problem is probably that the GDTH timer is not stopped by a
> > failed GDTH probe?
> 
> Indeed. Maybe this is a better fix?
> 
> That driver is pretty messy, and this should have been found ealier. 
> James? Boaz?

> @@ -5213,6 +5213,10 @@ static int __init gdth_init(void)
>  #endif /* CONFIG_PCI */
>  
>  	TRACE2(("gdth_detect() %d controller detected\n", gdth_ctr_count));
> +
> +	if (list_empty(&gdth_instances))
> +		return -ENODEV;

indeed - with this patch instead of the one i did the CONFIG_SCSI_GDTH=y 
bzImage boots up fine too, and no crash:

 Calling initcall 0x80a417e0: gdth_init+0x0/0xb20()
 GDT-HA: Storage RAID Controller Driver. Version: 3.05
 GDT-HA: Found 0 PCI Storage RAID Controllers
 initcall 0x80a417e0: gdth_init+0x0/0xb20() returned -19.
 initcall 0x80a417e0 ran for 5 msecs: gdth_init+0x0/0xb20()

Tested-by: Ingo Molnar <mingo@elte.hu>

	Ingo
