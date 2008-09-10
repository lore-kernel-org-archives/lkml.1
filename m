Return-Path: <linux-kernel-owner+w=401wt.eu-S1753952AbYIJM34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbYIJM34 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 08:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752088AbYIJM3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 08:29:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41148 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbYIJM3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 08:29:48 -0400
Date: Wed, 10 Sep 2008 08:29:43 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Janne Grunau <j@jannau.net>
Cc: Christoph Hellwig <hch@infradead.org>, Jarod Wilson <jwilson@redhat.com>,
       linux-kernel@vger.kernel.org, Jarod Wilson <jarod@redhat.com>,
       Christoph Bartelmus <lirc@bartelmus.de>,
       Mario Limonciello <superm1@ubuntu.com>
Subject: Re: [PATCH 01/18] lirc core device driver infrastructure
Message-ID: <20080910122943.GA29441@infradead.org>
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com> <1220933164-10160-2-git-send-email-jwilson@redhat.com> <20080909130102.GB27837@infradead.org> <200809101424.36654.j@jannau.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809101424.36654.j@jannau.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 02:24:36PM +0200, Janne Grunau wrote:
> On Tuesday 09 September 2008 15:01:02 Christoph Hellwig wrote:
> 
> > > +	do {
> > > +		if (ir->open) {
> > > +			if (ir->jiffies_to_wait) {
> > > +				set_current_state(TASK_INTERRUPTIBLE);
> > > +				schedule_timeout(ir->jiffies_to_wait);
> > > +			} else {
> > > +				interruptible_sleep_on(
> > > +					ir->p.get_queue(ir->p.data));
> > > +			}
> >
> > No sleep on, please.  But this one should be trivial to fix anyway,
> > by just changing this to a
> >
> > 	set_current_state(TASK_INTERRUPTIBLE);
> > 	schedule();
> >
> > and using wake_up_process in the wakeup path.
> 
> No driver uses the get_queue callback. So I'm inclined to just remove 
> it. Christoph, any objections?

Sounds good.
