Return-Path: <linux-kernel-owner+w=401wt.eu-S1755845AbZJARFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845AbZJARFZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 13:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755797AbZJARFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 13:05:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49640 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755782AbZJARFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 13:05:24 -0400
Date: Thu, 1 Oct 2009 10:03:19 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Tejun Heo <tj@kernel.org>
cc: jeff@garzik.org, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com
Subject: Re: [PATCH 15/19] workqueue: reimplement workqueue flushing using
 color coded works
In-Reply-To: <1254384558-1018-16-git-send-email-tj@kernel.org>
Message-ID: <alpine.LFD.2.01.0910010959390.6996@localhost.localdomain>
References: <1254384558-1018-1-git-send-email-tj@kernel.org> <1254384558-1018-16-git-send-email-tj@kernel.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 1 Oct 2009, Tejun Heo wrote:
>
> Reimplement workqueue flushing using color coded works.  There are two
> colors and each cwq has the current color which is painted on the
> works being issued via the cwq.  Flushing a workqueue is achieved by
> flipping the current colors of each cwq and wait for the works which
> have the old color to drain.

Is there any reason for the "two colors" choice? I could imagine that it 
could end up being a limitation (and possible deadlock?) to allow just a 
single flush pending at any time.

Could the color be an 8-bit counter or something like that instead?

		Linus
