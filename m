Return-Path: <linux-kernel-owner+w=401wt.eu-S1755446AbZFHNVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446AbZFHNVf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 09:21:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753267AbZFHNV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 09:21:27 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53441 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885AbZFHNV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 09:21:26 -0400
Message-ID: <4A2D1017.6010308@redhat.com>
Date: Mon, 08 Jun 2009 09:20:23 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera> <D9VoutSOyXP.A.hvH.Ha7KKB@chimera> <4A2BBC30.2030300@lwfinger.net> <84144f020906070640rf5ab14nbf66d3ca7c97675f@mail.gmail.com> <4A2BCC6F.8090004@redhat.com> <84144f020906070732l31786156r5d9753a0cabfde79@mail.gmail.com> <20090608101739.GA15377@csn.ul.ie>
In-Reply-To: <20090608101739.GA15377@csn.ul.ie>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman wrote:

> We've encountered this before and the conclusion was that the current
> adjustments for watermark calculations of high-order allocations is right,
> or at least there is no better alternative. In other words, the page
> allocator in this instance is behaving as expected. Do we want to
> revisit that discussion as to whether the watermark calculations for
> high-order allocation should change? I think we'll reach the same
> conclusion or at least decide that allowing the order-1 atomic
> allocation to succeed here would just postpone the problem.

It would not just postpone the problem, it would also
bring the system closer to a state where kswapd does
something about the order-1 free areas.

This might postpone the problem indefinately.

Currently the system fails early, without kswapd
kicking in and freeing new order-1 areas.

-- 
All rights reversed.
