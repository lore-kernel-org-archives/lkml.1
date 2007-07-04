Return-Path: <linux-kernel-owner+w=401wt.eu-S1760652AbXGDK72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760652AbXGDK72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 06:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757870AbXGDK7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 06:59:04 -0400
Received: from ozlabs.org ([203.10.76.45]:42474 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757059AbXGDK7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 06:59:01 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18059.32111.58643.97174@cargo.ozlabs.ibm.com>
Date: Wed, 4 Jul 2007 20:58:55 +1000
From: Paul Mackerras <paulus@samba.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] [PATCH] Remove process freezer from suspend to RAM pathway
In-Reply-To: <200707041242.59552.rjw@sisk.pl>
References: <20070703211227.GA28758@srcf.ucam.org>
	<200707032337.52544.rjw@sisk.pl>
	<18059.5690.908102.273897@cargo.ozlabs.ibm.com>
	<200707041242.59552.rjw@sisk.pl>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki writes:

> Okay, so in fact you don't know.

Don't know what exactly?

It has been a while since I had my head in the USB code.  I assume
it's being maintained by competent people. :)

> And that's my point in this thread.

Well, I'd be interested in hearing from Matthew whether he has
actually been using his patch in Ubuntu, and if so, what bug reports
he has been receiving related to it?

> I won't fight for the freezer for what it's worth, but let's do things in the
> _right_ _order_.  For example, let's make sure that by making the $subject
> change we won't introduce (too many) regressions and fix the frameworks
> that don't get it right.
> 
> Using the problems with FUSE as an argument for making this change immediately
> doesn't seem to be right to me.

I can see your point, but I won't be moving powermac over to use the
generic suspend path until the freezer is gone, since I am pretty
confident that the drivers we care about behave sensibly, and I have
seen a lot of traffic on linux-pm and lkml about problems caused by
the freezer.

Also, no-one has yet answered my fundamental objection to the freezer,
which is that the very kernel threads we would want to freeze are
often the same ones that we must not freeze, namely the threads that
issue I/O requests in order to satisfy incoming I/O requests.

If there was an automatic way to construct the graph of dependencies
(including data flows) between tasks, and derive an ordering for
freezing that guarantees that all I/Os will get completed without
deadlocks, then I could accept the freezer.  But we don't have
anything like that.

Paul.
