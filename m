Return-Path: <linux-kernel-owner+w=401wt.eu-S1755516AbXLGA3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516AbXLGA3w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 19:29:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753060AbXLGA3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 19:29:43 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39114 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752217AbXLGA3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 19:29:42 -0500
Date: Thu, 6 Dec 2007 16:29:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Phillips <phillips@phunq.net>
Cc: davidsen@tmr.com, linux-kernel@vger.kernel.org, peterz@infradead.org
Subject: Re: [RFC] [PATCH] A clean approach to writeout throttling
Message-Id: <20071206162915.a3917d1c.akpm@linux-foundation.org>
In-Reply-To: <200712061604.41490.phillips@phunq.net>
References: <200712051603.02183.phillips@phunq.net>
	<200712052221.45409.phillips@phunq.net>
	<47586F59.5090507@tmr.com>
	<200712061604.41490.phillips@phunq.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Dec 2007 16:04:41 -0800
Daniel Phillips <phillips@phunq.net> wrote:

> The runner up key idea is that we will gain a notion of "block device 
> stack" (or block stack for short, so that we may implement block 
> stackers) which for the time being will simply be Device Mapper's 
> notion of device stack, however many warts that may have.  It's there 
> now and we use it for ddsnap.

Perhaps all we need to track is the outermost point?

submit_bio(...)
{
	bool remove_the_rq = false;

	...
	if (current->the_rq == NULL) {
		current->the_rq = rq;
		remove_the_rq = true;
	}
	...
	if (remove_the_rq)
		current->the_rq = NULL;
}

?
