Return-Path: <linux-kernel-owner+w=401wt.eu-S1758098AbYABLAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758098AbYABLAy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 06:00:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755762AbYABLAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 06:00:45 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53714 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754811AbYABLAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 06:00:45 -0500
Date: Wed, 2 Jan 2008 12:00:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Boaz Harrosh <bharrosh@panasas.com>, Alan Cox <alan@redhat.com>
Subject: Re: 2.6.24-rc6-git7: Reported regressions from 2.6.23
Message-ID: <20080102110008.GB14731@elte.hu>
References: <200801012202.57851.rjw@sisk.pl> <alpine.LFD.1.00.0801011408470.32517@woody.linux-foundation.org> <1199244650.3252.18.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199244650.3252.18.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> Could you direct this poster to linux-scsi and we'll see if we can 
> finger the root cause (which will be difficult to do without getting a 
> boot trace).

FYI, here's a new one reported against 2.6.24-rc6-git7:

http://bugzilla.kernel.org/show_bug.cgi?id=9674

           Summary: Oops during rmmod'ing modeuls sdhci, sr_mod, ricoh_mmc,
                    mmc_core
           Product: Other
           Version: 2.5
     KernelVersion: 2.6.24-rc6-git7

has a very SCSI looking crash backtrace:

[   40.158530] Call Trace:
[   40.158537]  [<ffffffff80331800>] elv_next_request+0xe0/0x170
[   40.158543]  [<ffffffff803f7fa9>] scsi_request_fn+0x69/0x360
[   40.158547]  [<ffffffff803352a2>] blk_execute_rq_nowait+0x62/0xb0
[   40.158551]  [<ffffffff80336d6a>] blk_execute_rq+0x8a/0x100
[   40.158553]  [<ffffffff803347e5>] get_request+0x155/0x2d0
[   40.158557]  [<ffffffff803f7d64>] scsi_execute+0xe4/0x120
[   40.158560]  [<ffffffff803f7e31>] scsi_execute_req+0x91/0x100
[   40.158565]  [<ffffffff8800b70b>] :sr_mod:sr_probe+0x21b/0x630
[   40.158570]  [<ffffffff802fa0a9>] sysfs_create_link+0xa9/0x150
[   40.158575]  [<ffffffff805620a5>] klist_next+0x35/0xe0
[   40.158579]  [<ffffffff803c34cc>] driver_probe_device+0x9c/0x1b0
[   40.158582]  [<ffffffff803c37b1>] __driver_attach+0xe1/0xf0
[   40.158585]  [<ffffffff803c36d0>] __driver_attach+0x0/0xf0
[   40.158589]  [<ffffffff803c26bd>] bus_for_each_dev+0x4d/0x80
[   40.158592]  [<ffffffff803c2acf>] bus_add_driver+0xaf/0x220

	Ingo
