Return-Path: <linux-kernel-owner+w=401wt.eu-S1755168AbYFJMul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168AbYFJMul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 08:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753140AbYFJMub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 08:50:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44551 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753046AbYFJMua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 08:50:30 -0400
Date: Tue, 10 Jun 2008 08:50:11 -0400
From: Rik van Riel <riel@redhat.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       lee.schermerhorn@hp.com, kosaki.motohiro@jp.fujitsu.com,
       linux-mm@kvack.org, eric.whitney@hp.com
Subject: Re: [PATCH -mm 17/25] Mlocked Pages are non-reclaimable
Message-ID: <20080610085011.15bd481e@bree.surriel.com>
In-Reply-To: <20080610033130.GK19404@wotan.suse.de>
References: <20080606202838.390050172@redhat.com>
	<20080606202859.522708682@redhat.com>
	<20080606180746.6c2b5288.akpm@linux-foundation.org>
	<20080610033130.GK19404@wotan.suse.de>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2008 05:31:30 +0200
Nick Piggin <npiggin@suse.de> wrote:

> It should definitely be enabled for 32-bit machines, and enabled by default.
> The argument is that 32 bit machines won't have much memory so it won't
> be a problem, but a) it also has to work well on other machines without
> much memory, and b) it is a nightmare to have significant behaviour changes
> like this. For kernel development as well as kernel running.
> 
> If we eventually run out of page flags on 32 bit, then sure this might be
> one we could look at geting rid of. Once the code has proven itself.

Alternatively, we tell the 32 bit people not to compile their kernel
with support for 64 NUMA nodes :)

The number of page flags on 32 bits is (32 - ZONE_SHIFT - NODE_SHIFT)
after Christoph's cleanup and no longer a fixed number.

Does anyone compile a 32 bit kernel with a large (ZONE_SHIFT + NODE_SHIFT)?

-- 
All rights reversed.
