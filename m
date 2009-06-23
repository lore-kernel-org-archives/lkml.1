Return-Path: <linux-kernel-owner+w=401wt.eu-S1756829AbZFWCVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829AbZFWCVS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 22:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752423AbZFWCVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 22:21:05 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52579 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335AbZFWCVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 22:21:04 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, dm-devel@redhat.com,
       jens.axboe@oracle.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com,
       dhaval@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, jbaron@redhat.com, agk@redhat.com,
       snitzer@redhat.com, akpm@linux-foundation.org, peterz@infradead.org
Subject: Re: [PATCH 02/20] io-controller: Common flat fair queuing code in elevaotor layer
References: <1245443858-8487-1-git-send-email-vgoyal@redhat.com>
	<1245443858-8487-3-git-send-email-vgoyal@redhat.com>
	<20090622084612.GD3728@balbir.in.ibm.com>
	<20090623020515.GA3620@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 22 Jun 2009 22:20:24 -0400
In-Reply-To: <20090623020515.GA3620@redhat.com> (Vivek Goyal's message of
	"Mon, 22 Jun 2009 22:05:15 -0400")
Message-ID: <x49k533ofmf.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Mon, Jun 22, 2009 at 02:16:12PM +0530, Balbir Singh wrote:
>> > +	ioq->pid = current->pid;
>> 
>> Is pid used for cgroup association later? I don't see why we save the
>> pid otherwise? If yes, why not store the cgroup of the current->pid?
>> 
>
> This is just for logging purposes (blktrace), useful for CFQ where every task
> context sets up one queue and this number becomes the identifier for the queue.
> Look at elv_log_ioq(), which uses ioq->pid.

Well, that's not 100% accurate as tasks can share I/O contexts.
However, the 1:1 mapping does hold true most of the time.

> [..]
>> > + * coop tells that io scheduler selected a queue for us and we did not
>> 
>> coop?
>
> coop refers to "cooperating". I guess "coop" is not descriptive. I will
> change the name to "cooperating" and also put more description for
> clarity.

I think just more description is fine.  I'm not sure you need to spell
out cooperating (that will make for some long lines!).

>> > +	struct io_queue *async_idle_queue;
>> > +
>> > +	/*
>> > +	 * Used to track any pending rt requests so we can pre-empt current
>> > +	 * non-RT cfqq in service when this value is non-zero.
>> > +	 */
>> > +	unsigned int busy_rt_queues;
>> > +};
>> > +
>> > +struct elv_fq_data {
>> 
>> What does fq stand for?
>
> Fair queuing. Any suggestions to make it better?

I think you could just put it in the comment.

Cheers,
Jeff
