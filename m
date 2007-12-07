Return-Path: <linux-kernel-owner+w=401wt.eu-S1752187AbXLGHN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187AbXLGHN5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 02:13:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751008AbXLGHNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 02:13:49 -0500
Received: from phunq.net ([64.81.85.152]:55259 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751224AbXLGHNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 02:13:49 -0500
From: Daniel Phillips <phillips@phunq.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] [PATCH] A clean approach to writeout throttling
Date: Thu, 6 Dec 2007 23:13:42 -0800
User-Agent: KMail/1.9.5
Cc: davidsen@tmr.com, linux-kernel@vger.kernel.org, peterz@infradead.org
References: <200712051603.02183.phillips@phunq.net> <200712061604.41490.phillips@phunq.net> <20071206162915.a3917d1c.akpm@linux-foundation.org>
In-Reply-To: <20071206162915.a3917d1c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712062313.43383.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 December 2007 16:29, Andrew Morton wrote:
> On Thu, 6 Dec 2007 16:04:41 -0800
>
> Daniel Phillips <phillips@phunq.net> wrote:
> > The runner up key idea is that we will gain a notion of "block
> > device stack" (or block stack for short, so that we may implement
> > block stackers) which for the time being will simply be Device
> > Mapper's notion of device stack, however many warts that may have. 
> > It's there now and we use it for ddsnap.
>
> Perhaps all we need to track is the outermost point?
>
> submit_bio(...)
> {
> 	bool remove_the_rq = false;
>
> 	...
> 	if (current->the_rq == NULL) {
> 		current->the_rq = rq;
> 		remove_the_rq = true;
> 	}
> 	...
> 	if (remove_the_rq)
> 		current->the_rq = NULL;
> }
>
> ?

The parent patch already has that crucial property in a simple say, see

       if (q && q->metric && !bio->bi_queue) {
               bio->bi_queue = q;

Regards,

Daniel
