Return-Path: <linux-kernel-owner+w=401wt.eu-S1759909AbYDOX1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759909AbYDOX1r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 19:27:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753464AbYDOX1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 19:27:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49563 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753016AbYDOX1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 19:27:37 -0400
Date: Wed, 16 Apr 2008 01:27:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <clameter@sgi.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai.Lu@sun.com, apw@shadowen.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [bug] SLUB + mm/slab.c boot crash in -rc9
Message-ID: <20080415232711.GA22679@elte.hu>
References: <20080415204025.GA29784@elte.hu> <alpine.LFD.1.00.0804151353380.2879@woody.linux-foundation.org> <20080415211359.GA1531@elte.hu> <20080415212430.GA5467@elte.hu> <Pine.LNX.4.64.0804151437300.3252@schroedinger.engr.sgi.com> <20080415215504.GA9066@elte.hu> <Pine.LNX.4.64.0804151455520.4038@schroedinger.engr.sgi.com> <20080415221314.GA12094@elte.hu> <Pine.LNX.4.64.0804151517530.4038@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0804151609510.5018@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804151609510.5018@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <clameter@sgi.com> wrote:

> Hmmm... If one enables CONFIG_X86_PAE (even with no highmem) then 
> everything is fine. For PAE to be enabled some other things also fall 
> by the wayside. Diff to your failing config follows. Will try to 
> minimize the diff even further:

... in the thread i've already explained that it's because on PAE we use 
1GB sparse chunks (shift 30) which masks the bug.

(on PAE we cannot go below a shift of 29 due to shortage of page->flags)

	Ingo
