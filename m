Return-Path: <linux-kernel-owner+w=401wt.eu-S932376AbZJFQ3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376AbZJFQ3i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 12:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756749AbZJFQ3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 12:29:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:49132 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756651AbZJFQ3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 12:29:37 -0400
Subject: Re: [PATCH 2/2] perf_events: add event constraints support for
 Intel processors
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stephane Eranian <eranian@googlemail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       perfmon2-devel@lists.sf.net, Stephane Eranian <eranian@gmail.com>
In-Reply-To: <1254840129-6198-3-git-send-email-eranian@gmail.com>
References: <> <1254840129-6198-1-git-send-email-eranian@gmail.com>
	 <1254840129-6198-2-git-send-email-eranian@gmail.com>
	 <1254840129-6198-3-git-send-email-eranian@gmail.com>
Content-Type: text/plain
Date: Tue, 06 Oct 2009 18:29:04 +0200
Message-Id: <1254846544.21044.298.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-06 at 16:42 +0200, Stephane Eranian wrote:

> 	This patch changes the event to counter assignment logic to take
> 	into account event constraints for Intel P6, Core and Nehalem
> 	processors. There is no contraints on Intel Atom. There are
> 	constraints on Intel Yonah (Core Duo) but they are not provided
> 	in this patch given that this processor is not yet supported by
> 	perf_events.

I don't think there's much missing for that, right?

I don't actually have that hardware, so I can't test it.

> 	As a result of the constraints, it is possible for some event groups
> 	to never actually be loaded onto the PMU if they contain two events
> 	which can only be measured on a single counter. That situation can be
> 	detected with the scaling information extracted with read().

Right, that's a pre existing bug in the x86 code (we can create groups
larger than the PMU) and should be fixed.

Patch looks nice though.


