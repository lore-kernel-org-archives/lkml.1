Return-Path: <linux-kernel-owner+w=401wt.eu-S1753804AbZDNIAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbZDNIAY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 04:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751401AbZDNIAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 04:00:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52706 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242AbZDNIAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 04:00:08 -0400
Date: Tue, 14 Apr 2009 09:59:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Theodore Ts'o" <tytso@mit.edu>, Shawn Du <duyuyang@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-btrace@vger.kernel.org
Subject: Re: PATCH 1/3] blktrace: support per-partition tracing
Message-ID: <20090414075947.GA27003@elte.hu>
References: <49E42620.4050701@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E42620.4050701@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.3 required=5.9 tests=BAYES_00,SUBJECT_FUZZY_TION autolearn=no SpamAssassin version=3.2.3
	0.2 SUBJECT_FUZZY_TION     Attempt to obfuscate words in Subject:
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> --- a/include/linux/blktrace_api.h
> +++ b/include/linux/blktrace_api.h
> @@ -165,8 +165,9 @@ struct blk_trace {
>  
>  extern int blk_trace_ioctl(struct block_device *, unsigned, char __user *);
>  extern void blk_trace_shutdown(struct request_queue *);
> -extern int do_blk_trace_setup(struct request_queue *q,
> -	char *name, dev_t dev, struct blk_user_trace_setup *buts);
> +extern int do_blk_trace_setup(struct request_queue *q, char *name,
> +			      dev_t dev, struct block_device *bdev,
> +			      struct blk_user_trace_setup *buts);
>  extern void __trace_note_message(struct blk_trace *, const char *fmt, ...);
>  
>  /**
> @@ -193,6 +194,7 @@ extern void __trace_note_message(struct blk_trace *, const char *fmt, ...);
>  extern void blk_add_driver_data(struct request_queue *q, struct request *rq,
>  				void *data, size_t len);
>  extern int blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
> +			   struct block_device *bdev,
>  			   char __user *arg);
>  extern int blk_trace_startstop(struct request_queue *q, int start);
>  extern int blk_trace_remove(struct request_queue *q);

Small detail: you forgot about the !CONFIG_BLK_DEV_IO_TRACE case 
here, the wrapper macros there need to be updated.

(no need to resend - i fixed this up in the 1/3 and 3/3 patches)

	Ingo
