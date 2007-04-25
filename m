Return-Path: <linux-kernel-owner+w=401wt.eu-S1030865AbXDYNrD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030865AbXDYNrD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 09:47:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030877AbXDYNrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 09:47:03 -0400
Received: from mail.screens.ru ([213.234.233.54]:38543 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030865AbXDYNrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 09:47:01 -0400
Date: Wed, 25 Apr 2007 16:52:14 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, David Miller <davem@davemloft.net>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cancel_delayed_work: use del_timer() instead of del_timer_sync()
Message-ID: <20070425125214.GB94@tv-sign.ru>
References: <20070424215034.GA5985@tv-sign.ru> <20070425130246.GA4086@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070425130246.GA4086@ff.dom.local>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25, Jarek Poplawski wrote:
>
> On Wed, Apr 25, 2007 at 01:50:34AM +0400, Oleg Nesterov wrote:
> > del_timer_sync() buys nothing for cancel_delayed_work(), but it is less
> > efficient since it locks the timer unconditionally, and may wait for the
> > completion of the delayed_work_timer_fn().
> 
> I'm not sure what is the main aim of this patch.

optimization

>                                                  It seems this
> change cannot do any harm, but anyway it could change a few
> things, e.g. with current version of cancel_rearming_delayed_work
> some flush_workqueue could be done needlessly, before the work
> is queued from timer.

I don't think so... Could you clarify?

>                       It's not a big deal here, but if anybody
> did something like this without loop - it could matter.
> 
> So, probably a lot of current code should be checked, before
> applying and I doubt the gain is worth of this. Maybe, for
> safety, make this with new name as an alternative and
> deprecate the current version?

This change should not make any visible difference for the callers,
otherwise it is buggy.

Oleg.

