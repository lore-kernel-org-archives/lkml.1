Return-Path: <linux-kernel-owner+w=401wt.eu-S1755305AbZBBPkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305AbZBBPkm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 10:40:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752673AbZBBPkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 10:40:33 -0500
Received: from fifo99.com ([67.223.236.141]:45146 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557AbZBBPkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 10:40:33 -0500
Subject: Re: [RFC][PATCH] create workqueue threads only when needed
From: Daniel Walker <dwalker@fifo99.com>
To: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <c62985530902020651j59f3e041u2c80b96914b04765@mail.gmail.com>
References: <20090127001708.GA4815@nowhere>
	 <1233586140.5903.95.camel@desktop>
	 <c62985530902020651j59f3e041u2c80b96914b04765@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Mon, 02 Feb 2009 07:40:25 -0800
Message-Id: <1233589225.5903.107.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-02 at 15:51 +0100, Frédéric Weisbecker wrote:
> 2009/2/2 Daniel Walker <dwalker@fifo99.com>:
> > On Tue, 2009-01-27 at 01:17 +0100, Frederic Weisbecker wrote:
> >
> >> All of the workqueues with 0 work inserted do nothing.
> >> For several reasons:
> >>
> >> _ Unneeded built drivers for my system that create workqueue(s) when they init
> >> _ Services which need their own workqueue, for several reasons, but who receive
> >>   very rare jobs (often never)
> >> _ ...?
> >>
> >
> > Some of the workqueues you have on your system can be removed just by
> > tuning your kernel config. It's more desirable to be able to remove the
> > whole unused feature since that's all unused memory beyond just
> > thread ..
> >
> > Daniel
> 
> 
> Yes of course. I just think about the distros which enable a lot of
> options by default.

The problem is that your just removing the visible part of the memory
waste .. Even distros can/do use modules where some of these features
wouldn't get loaded.

I think it's a better policy to assume if a kernel has a feature enabled
that feature will get used, including the workqueue.

Daniel

