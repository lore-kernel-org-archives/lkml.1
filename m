Return-Path: <linux-kernel-owner+w=401wt.eu-S1754798AbXKXDth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798AbXKXDth (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 22:49:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751787AbXKXDt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 22:49:28 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58422 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751649AbXKXDt1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 22:49:27 -0500
Date: Sat, 24 Nov 2007 03:49:07 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Milan Broz <mbroz@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-rc2-mm1: kcryptd vs lockdep
Message-ID: <20071124034907.GD22843@agk.fab.redhat.com>
Mail-Followup-To: Alasdair G Kergon <agk@redhat.com>,
	Torsten Kaiser <just.for.lkml@googlemail.com>,
	Milan Broz <mbroz@redhat.com>, Ingo Molnar <mingo@elte.hu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel list <linux-kernel@vger.kernel.org>
References: <64bb37e0711182323v1e2a1341tfc7f20df771b988@mail.gmail.com> <20071119075627.GB28432@elte.hu> <64bb37e0711191134l6dac07a2ie3b4258c43e1f1f0@mail.gmail.com> <4741F97D.6090808@redhat.com> <64bb37e0711231442y7603366aib9642eab97e5be6b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64bb37e0711231442y7603366aib9642eab97e5be6b@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 23, 2007 at 11:42:36PM +0100, Torsten Kaiser wrote:
> ... or I just don't see the bug.
 
See my earlier post in this thread: there's a race in the write loop
where a work struct could be used twice on the same queue.
(Needs data structure change to fix that, which nobody has attempted
to do yet.)

BTW To eliminate any internal lockdep concerns (and people say there
should be no problem) temporarily add a second struct instead of reusing
one on two queues.

Alasdair
-- 
agk@redhat.com
