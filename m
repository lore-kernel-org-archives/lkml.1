Return-Path: <linux-kernel-owner+w=401wt.eu-S1758473AbZDHJFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758473AbZDHJFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 05:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755343AbZDHJFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 05:05:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35994 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753241AbZDHJFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 05:05:20 -0400
Date: Wed, 8 Apr 2009 11:04:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, alan.brunelle@hp.com,
       jens.axboe@oracle.com, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:tracing/blktrace-v2] blktrace: fix a bug in
	blk_msg_write()
Message-ID: <20090408090453.GC12283@elte.hu>
References: <49D5BB56.7000807@cn.fujitsu.com> <tip-48cefde3c17bbf37fee99e2889bcc718e5805dfa@git.kernel.org> <49DBFEB0.9080308@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49DBFEB0.9080308@cn.fujitsu.com>
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


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> Hi Ingo,
> 
> Though Carl <chlunde@ping.uio.no>'s patch has been applied,
> (a4b3ada83d06554d307dd54abdc62b2e5648264a), this patch hasn't
> been dropped, thus the code in -tip looks like:
> 
> static ssize_t blk_msg_write(...)
> {
> 	...
>         if (copy_from_user(msg, buffer, count)) {
>                 kfree(msg);
>                 return -EFAULT;
>         }
>         msg[count] = '\0';	<---
> 
>         msg[count] = '\0';	<---
> 	...
> }

indeed - that's a (harmless) merge artifact in tip/master, it has 
not propagated into the tracing topics and will go away on the next 
reintegration.

Thanks for letting me know, i'll keep an eye on it.

	Ingo
