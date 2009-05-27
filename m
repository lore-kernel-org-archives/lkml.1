Return-Path: <linux-kernel-owner+w=401wt.eu-S1759587AbZE0WtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759587AbZE0WtU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 18:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753339AbZE0WtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 18:49:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41350 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752340AbZE0WtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 18:49:03 -0400
Date: Wed, 27 May 2009 15:48:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Yu, Fenghua" <fenghua.yu@intel.com>
Cc: dwmw2@infradead.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org
Subject: Re: [PATCH] Time out for possible dead loops during queued
 invalidation wait
Message-Id: <20090527154816.23541b2a.akpm@linux-foundation.org>
In-Reply-To: <A6AD88C3F2289247BE726C37303E1EB8AF9331CE@orsmsx505.amr.corp.intel.com>
References: <20090327212241.234500000@intel.com>
	<20090327212321.070229000@intel.com>
	<20090416001957.GA1527@linux-os.sc.intel.com>
	<1240135508.3589.75.camel@macbook.infradead.org>
	<A6AD88C3F2289247BE726C37303E1EB8A4DF7DB1@orsmsx505.amr.corp.intel.com>
	<20090520174259.GA10646@linux-os.sc.intel.com>
	<20090526225146.2faeeb05.akpm@linux-foundation.org>
	<A6AD88C3F2289247BE726C37303E1EB8AF9331CE@orsmsx505.amr.corp.intel.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 May 2009 15:40:35 -0700
"Yu, Fenghua" <fenghua.yu@intel.com> wrote:

> >> +			WARN(1, "No space in invalidation queue.\n");
> >> +			return -ENOSPC;
> >
> >ENOSPC means "your disk filled up".  I think it makes no sense to use
> >that error code in this context, even though it kinda sounds the same.
> >
> 
> Which error code is better? Is EAGAIN ok?

That depends on driver details - probably EIO would be suitable, dunno.

But all the callers of qi_submit_sync() seem to just drop the error
code on the floor:

	/* should never fail */
	qi_submit_sync(&desc, iommu);

and may well cause a kernel crash as a result.
