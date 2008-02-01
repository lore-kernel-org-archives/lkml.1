Return-Path: <linux-kernel-owner+w=401wt.eu-S1765526AbYBAMLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765526AbYBAMLZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 07:11:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764512AbYBAMKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 07:10:30 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:50467 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764434AbYBAMK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 07:10:27 -0500
Subject: Re: [Regression] 2.6.24-git9: RT sched mishandles artswrapper
	(bisected)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200802011250.18699.rjw@sisk.pl>
References: <200802010237.59320.rjw@sisk.pl>
	 <1201851896.32654.34.camel@lappy> <1201859458.32654.41.camel@lappy>
	 <200802011250.18699.rjw@sisk.pl>
Content-Type: text/plain
Date: Fri, 01 Feb 2008 13:09:56 +0100
Message-Id: <1201867797.32654.52.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-01 at 12:50 +0100, Rafael J. Wysocki wrote:
> On Friday, 1 of February 2008, Peter Zijlstra wrote:

> > > It arts run as root, or does it use RLIMIT_RTPRIO to allow users to
> > > execute realtime tasks?
> 
> artswrapper is setuid root and RLIMIT_RTPRIO is apparently not used.
> Still, artswrapper is running as a regular user, so it most probably drops
> privileges early.
> 
> BTW, it fails while running the artsmessage utility used for displaying arts
> error messages, so I guess there's an error in arts that this thing tries to
> display and deadlocks (or something like that).
> 
> Should I test the patch nevertheless?

Don't think that would help any in this situation. The thing to look out
for are RT tasks running with a different uid than 0.

This patch would only stop a task from obtaining RT class scheduling
when already in a (misconfigured) group. If the task is RT and then
switches group another - similar - thing is needed.

Does this artsmessage thing also run with RT priority?



