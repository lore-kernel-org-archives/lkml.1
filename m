Return-Path: <linux-kernel-owner+w=401wt.eu-S1754133AbZBAKXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133AbZBAKXA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 05:23:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752672AbZBAKWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 05:22:52 -0500
Received: from smtp1.stealer.net ([88.198.224.204]:43019 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569AbZBAKWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 05:22:51 -0500
Date: Sun, 1 Feb 2009 11:22:40 +0100 (CET)
From: Sven Wegener <sven.wegener@stealer.net>
To: Peter Zijlstra <peterz@infradead.org>
cc: David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Chinner <david@fromorbit.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Fix dirty_bytes/dirty_background_bytes sysctls on
 64bit arches
In-Reply-To: <1233479979.4787.64.camel@laptop>
Message-ID: <alpine.LNX.2.00.0902011036470.6140@titan.stealer.net>
References: <alpine.DEB.2.00.0811230228070.11384@chino.kir.corp.google.com>  <alpine.DEB.2.00.0811230228530.11384@chino.kir.corp.google.com>  <alpine.LNX.2.00.0902010218350.6140@titan.stealer.net> <1233479979.4787.64.camel@laptop>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
Organization: STEALER.net
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: 0.1
X-Spam-Bar: /
X-Spam-Report: Scanned by SpamAssassin 3.2.1-gr1 2007-05-02 on smtp1.stealer.net at Sun, 01 Feb 2009 10:22:49 +0000
	Bayes: 0.4703 Tokens: new, 168; hammy, 4; neutral, 3; spammy, 2.
	AutoLearn: no
	*  0.1 RDNS_NONE Delivered to trusted network by a host with no rDNS
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4703]
X-Spam-Signature: 68be8d562db371d0f1236eb7cac1a70228fec232
X-DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Feb 2009, Peter Zijlstra wrote:

> On Sun, 2009-02-01 at 02:22 +0100, Sven Wegener wrote:
> > We need to pass an unsigned long as the minimum, because it gets casted
> > to an unsigned long in the sysctl handler. If we pass an int, we'll
> > access four more bytes on 64bit arches, resulting in a random minimum
> > value.
> 
> If that's so, how can any of those other limit values still be good?

The problem here is that we use proc_doulongvec_minmax(), which expects an 
unsigned long. Most other sysctls use the dointvec versions and are safe, 
as long as they pass an int. If they pass a char or a short, they're 
subject to the same problem.

The other sysctls in sysctl.c that use proc_doulongvec_minmax() don't pass 
a min/max value. The others in the kernel I checked do the same or pass a 
proper unsigned long.

Sven
