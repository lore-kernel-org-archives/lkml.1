Return-Path: <linux-kernel-owner+w=401wt.eu-S1161727AbXDYM46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161727AbXDYM46 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 08:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161861AbXDYM46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 08:56:58 -0400
Received: from mx2.go2.pl ([193.17.41.42]:52649 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161727AbXDYM45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 08:56:57 -0400
Date: Wed, 25 Apr 2007 15:02:46 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, David Miller <davem@davemloft.net>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cancel_delayed_work: use del_timer() instead of del_timer_sync()
Message-ID: <20070425130246.GA4086@ff.dom.local>
References: <20070424215034.GA5985@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070424215034.GA5985@tv-sign.ru>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2007 at 01:50:34AM +0400, Oleg Nesterov wrote:
> del_timer_sync() buys nothing for cancel_delayed_work(), but it is less
> efficient since it locks the timer unconditionally, and may wait for the
> completion of the delayed_work_timer_fn().

I'm not sure what is the main aim of this patch. It seems this
change cannot do any harm, but anyway it could change a few
things, e.g. with current version of cancel_rearming_delayed_work
some flush_workqueue could be done needlessly, before the work
is queued from timer. It's not a big deal here, but if anybody
did something like this without loop - it could matter.

So, probably a lot of current code should be checked, before
applying and I doubt the gain is worth of this. Maybe, for
safety, make this with new name as an alternative and
deprecate the current version?

Regards,
Jarek P.
