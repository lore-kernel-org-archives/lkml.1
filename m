Return-Path: <linux-kernel-owner+w=401wt.eu-S1755164Ab0ASBTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164Ab0ASBTe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 20:19:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754025Ab0ASBTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 20:19:34 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42429 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978Ab0ASBTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 20:19:33 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC][PATCH] PM: Force GFP_NOIO during suspend/resume (was: Re: [linux-pm] Memory allocations in .suspend became very unreliable)
Cc: kosaki.motohiro@jp.fujitsu.com, Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, "linux-mm" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
In-Reply-To: <201001182155.09727.rjw@sisk.pl>
References: <20100118110324.AE30.A69D9226@jp.fujitsu.com> <201001182155.09727.rjw@sisk.pl>
Message-Id: <20100119101101.5F2E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 19 Jan 2010 10:19:29 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi 

> > If suspend need lots memory, we need to make free memory before starting IO
> > suspending, I think.
> 
> Suspend as such doesn't need a lot of memory, except for some drivers doing
> things they shouldn't do.
> 
> However, there are a few problems that need to be addressed in general.
> 
> First, we can't really guarantee that there's a lot of free memory available
> during suspend and some memory allocations are done indirectly, using
> GFP_KERNEL (for example, when new kernel threads are started).  If one of
> these is done during suspend and it happens to cause the mm subsystem to
> start I/O on a suspended devices, the kernel will lock up.
> 
> Second, there may be a memory allocation in progress when suspend is started
> that causes I/O to happen and races with the suspend process.  If the latter
> wins the race, the I/O may be attempted on a suspended device and the kernel
> will lock up.

I think the race happen itself is bad. memory and I/O subsystem can't solve such race
elegantly. These doesn't know enough suspend state knowlege. I think the practical 
solution is that higher level design prevent the race happen.


> My patch attempts to avoid these two problems as well as the problem with
> drivers using GFP_KERNEL allocations during suspend which I admit might be
> solved by reworking the drivers.

Agreed. In this case, only drivers change can solve the issue.



