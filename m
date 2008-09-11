Return-Path: <linux-kernel-owner+w=401wt.eu-S1756223AbYIKTSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223AbYIKTSS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 15:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbYIKTSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 15:18:07 -0400
Received: from scing.com ([217.160.110.58]:47848 "EHLO scing.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752661AbYIKTSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 15:18:06 -0400
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
From: Janne Grunau <j@jannau.net>
To: Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [PATCH 01/18] lirc core device driver infrastructure
Date: Thu, 11 Sep 2008 21:18:00 +0200
User-Agent: KMail/1.9.9
Cc: hch@infradead.org, jarod@redhat.com, jwilson@redhat.com,
       linux-kernel@vger.kernel.org, superm1@ubuntu.com
References: <AlfDbh7ojFB@christoph>
In-Reply-To: <AlfDbh7ojFB@christoph>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809112118.00556.j@jannau.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 September 2008 20:03:00 Christoph Bartelmus wrote:
> Hi Janne,
>
> on 10 Sep 08 at 14:24, Janne Grunau wrote:
> > On Tuesday 09 September 2008 15:01:02 Christoph Hellwig wrote:
> >>> +	do {
> >>> +		if (ir->open) {
> >>> +			if (ir->jiffies_to_wait) {
> >>> +				set_current_state(TASK_INTERRUPTIBLE);
> >>> +				schedule_timeout(ir->jiffies_to_wait);
> >>> +			} else {
> >>> +				interruptible_sleep_on(
> >>> +					ir->p.get_queue(ir->p.data));
> >>> +			}
> >>
> >> No sleep on, please.  But this one should be trivial to fix
> >> anyway, by just changing this to a
> >>
> >> 	set_current_state(TASK_INTERRUPTIBLE);
> >> 	schedule();
> >>
> >> and using wake_up_process in the wakeup path.
> >
> > No driver uses the get_queue callback. So I'm inclined to just
> > remove it. Christoph, any objections?
>
> lirc_gpio is using it.
> I guess there will be no need to use lirc_gpio in future, but I'd
> like to keep this in CVS for people who still use it.

We don't have lirc_gpio in the kernel tree? And I guess there is no need 
to integrate into the kernel. I've removed it already.

Janne

> Christoph


