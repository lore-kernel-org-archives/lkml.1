Return-Path: <linux-kernel-owner+w=401wt.eu-S1757848AbYAFPSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757848AbYAFPSN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 10:18:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752951AbYAFPR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 10:17:59 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35672 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752769AbYAFPR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 10:17:58 -0500
Date: Sun, 6 Jan 2008 16:17:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Gregor Jasny <jasny@vidsoft.de>
Cc: linux-kernel@vger.kernel.org,
       video4linux-list <video4linux-list@redhat.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       v4l-dvb-maintainer@linuxtv.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] Re: Regression: VIDIOCGMBUF ioctl hangs on bttv driver
	(2.6.24-rc6)
Message-ID: <20080106151730.GA17789@elte.hu>
References: <20080105223338.GA18690@vidsoft.de> <20080106141548.GB18690@vidsoft.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080106141548.GB18690@vidsoft.de>
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


* Gregor Jasny <jasny@vidsoft.de> wrote:

> From: Gregor Jasny <gjasny@web.de>
> 
> Fix bttv VIDIOCGMBUF locking like done in commit
> 820eacd84cff23b76693f4be1e28feb672f4488f. 

i've double-checked that there are no other video drivers affected by 
this problem:

 $ cd drivers/media/
 $ grep -C 10 videobuf_mmap_setup `grep -l mutex_lock */*.c */*/*.c */*/*/*.c`

 video/videobuf-core.c-  mutex_lock(&q->lock);
 video/videobuf-core.c-  mutex_lock(&q->lock);
 video/bt8xx/bttv-driver.c-              mutex_lock(&fh->cap.lock);

so only bttv-driver.c was affected, at first sight.

	Ingo
