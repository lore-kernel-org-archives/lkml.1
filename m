Return-Path: <linux-kernel-owner+w=401wt.eu-S1755079AbZDNIf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079AbZDNIf1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 04:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752372AbZDNIfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 04:35:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37670 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169AbZDNIfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 04:35:07 -0400
Date: Tue, 14 Apr 2009 10:34:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Theodore Ts'o" <tytso@mit.edu>, Shawn Du <duyuyang@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-btrace@vger.kernel.org
Subject: Re: PATCH 1/3] blktrace: support per-partition tracing
Message-ID: <20090414083453.GE27003@elte.hu>
References: <49E42620.4050701@cn.fujitsu.com> <20090414075947.GA27003@elte.hu> <49E445CB.4030001@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E445CB.4030001@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.3 required=5.9 tests=BAYES_00,SUBJECT_FUZZY_TION autolearn=no SpamAssassin version=3.2.5
	0.2 SUBJECT_FUZZY_TION     Attempt to obfuscate words in Subject:
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> >> @@ -193,6 +194,7 @@ extern void __trace_note_message(struct blk_trace *, const char *fmt, ...);
> >>  extern void blk_add_driver_data(struct request_queue *q, struct request *rq,
> >>  				void *data, size_t len);
> >>  extern int blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
> >> +			   struct block_device *bdev,
> >>  			   char __user *arg);
> >>  extern int blk_trace_startstop(struct request_queue *q, int start);
> >>  extern int blk_trace_remove(struct request_queue *q);
> > 
> > Small detail: you forgot about the !CONFIG_BLK_DEV_IO_TRACE case 
> > here, the wrapper macros there need to be updated.
> > 
> 
> Ah, sorry..
> 
> > (no need to resend - i fixed this up in the 1/3 and 3/3 patches)
> > 
> 
> and thanks! (But I think only 1/3 patch needs to be fixed)

3/3 had context dependencies - no functionality dependency.

> The 3rd patch can be for 2.6.30, if Ted or somene else wants to 
> use ftrace-plugin blktrace to trace dm devices in 2.6.30.

ok, good point - we can cherry-pick it over into tracing/urgent 
after Ted reports back his experiences with these changes.

	Ingo
