Return-Path: <linux-kernel-owner+w=401wt.eu-S1755034AbZIUIGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034AbZIUIGG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 04:06:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754912AbZIUIGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 04:06:04 -0400
Received: from mail.gmx.net ([213.165.64.20]:36138 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753069AbZIUIGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 04:06:03 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19m2xACcOpm3zRxkkuMTRndpm0vSwbHWCE/GM4lH9
	B+W8moAF01d4HN
Subject: Re: Poor desktop responsiveness with background I/O-operations
From: Mike Galbraith <efault@gmx.de>
To: Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <4AB72FDC.5090403@datenparkplatz.de>
References: <4AB59CBB.8090907@datenparkplatz.de>
	 <20090920080728.73bfe2a1@infradead.org>
	 <4AB5ECD0.7010903@datenparkplatz.de>
	 <1253475521.9224.43.camel@marge.simson.net>  <4AB6C73C.1030004@gmail.com>
	 <1253507034.23414.90.camel@marge.simson.net>
	 <4AB72FDC.5090403@datenparkplatz.de>
Content-Type: text/plain
Date: Mon, 21 Sep 2009 10:06:04 +0200
Message-Id: <1253520364.25640.57.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-21 at 09:48 +0200, Ulrich Lukas wrote:
> Hi and thanks for your reply!

Hi.

> Mike Galbraith wrote:
> > nicing a shell or the dd should (and does) help a LOT.
> 
> If this is the only way to influence this, maybe the default settings
> for the niceness of interactive and non-interactive tasks are not the
> best choice. (Maybe a distribution problem in this case)

There is no knowledge in the CPU nor IO scheduler wrt interactive vs
non-interactive.  I've tinkered many times with a SCHED_INTERACTIVE
class, but it's not at all an easy problem, so keeps landing on the
trash heap.  I could ramble on _for ever_ about that subject, but it's
thankfully irrelevant to this thread ;-)
 
> > reads are sync, more heavily affected by seek latency than writes.
> 
> But how does this explain the seconds-long delays?

Seek latencies are cumulative is my (wild arsed) theory.

> If an interactive process causes a lot of seeks because of reads/writes
> which "are sync", I see how this can greatly slow down otherwise
> pipelined write operations, but the other way around?

If you seek between tiny reads, the more little reads you do, the more
seeks hurt.  Readahead is supposed to help, but.. the pain is there.

	-Mike 

