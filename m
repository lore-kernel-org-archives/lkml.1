Return-Path: <linux-kernel-owner+w=401wt.eu-S1754185AbYIJM0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185AbYIJM0a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 08:26:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbYIJM0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 08:26:21 -0400
Received: from scing.com ([217.160.110.58]:45717 "EHLO scing.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453AbYIJM0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 08:26:19 -0400
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
From: Janne Grunau <j@jannau.net>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/18] lirc core device driver infrastructure
Date: Wed, 10 Sep 2008 14:24:36 +0200
User-Agent: KMail/1.9.9
Cc: Jarod Wilson <jwilson@redhat.com>, linux-kernel@vger.kernel.org,
       Jarod Wilson <jarod@redhat.com>,
       Christoph Bartelmus <lirc@bartelmus.de>,
       Mario Limonciello <superm1@ubuntu.com>, Janne Grunau <j@jannau.net>
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com> <1220933164-10160-2-git-send-email-jwilson@redhat.com> <20080909130102.GB27837@infradead.org>
In-Reply-To: <20080909130102.GB27837@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200809101424.36654.j@jannau.net>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 September 2008 15:01:02 Christoph Hellwig wrote:

> > +	do {
> > +		if (ir->open) {
> > +			if (ir->jiffies_to_wait) {
> > +				set_current_state(TASK_INTERRUPTIBLE);
> > +				schedule_timeout(ir->jiffies_to_wait);
> > +			} else {
> > +				interruptible_sleep_on(
> > +					ir->p.get_queue(ir->p.data));
> > +			}
>
> No sleep on, please.  But this one should be trivial to fix anyway,
> by just changing this to a
>
> 	set_current_state(TASK_INTERRUPTIBLE);
> 	schedule();
>
> and using wake_up_process in the wakeup path.

No driver uses the get_queue callback. So I'm inclined to just remove 
it. Christoph, any objections?

Janne
