Return-Path: <linux-kernel-owner+w=401wt.eu-S1758539AbYDZGMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758539AbYDZGMx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 02:12:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751923AbYDZGMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 02:12:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37723 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751830AbYDZGMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 02:12:01 -0400
Date: Fri, 25 Apr 2008 23:10:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-mm@kvack.org, mel@csn.ul.ie, mingo@elte.hu,
       linux-kernel@vger.kernel.org, clameter@sgi.com
Subject: Re: [PATCH 1/4] Add a basic debugging framework for memory
 initialisation
Message-Id: <20080425231028.cb4a57b1.akpm@linux-foundation.org>
In-Reply-To: <20080422183153.13750.61533.sendpatchset@skynet.skynet.ie>
References: <20080422183133.13750.57133.sendpatchset@skynet.skynet.ie>
	<20080422183153.13750.61533.sendpatchset@skynet.skynet.ie>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 22 Apr 2008 19:31:53 +0100 (IST) Mel Gorman <mel@csn.ul.ie> wrote:
>
> This patch creates a new file mm/mm_init.c which is conditionally compiled
> to have almost all of the debugging and verification code to avoid further
> polluting page_alloc.c. Ideally other mm initialisation code will be moved
> here over time and the file partially compiled depending on Kconfig.

I was wondering why the file was misnamed ;)

I worry that

a) MM developers will forget to turn on the debug option (ask me about
   this) and the code in mm_init.c will break and 

b) The mm_init.c code is broken (or will break) on some architecture(s)
   and people who run that arch won't turn on the debug option either.

So hm.  I think that we should be more inclined to at least compile the
code even if we don't run it.  To catch compile-time breakage.

And it would be good if we could have a super-quick version of the checks
just so that more people at least partially run them.  Or something.
