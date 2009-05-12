Return-Path: <linux-kernel-owner+w=401wt.eu-S1756809AbZELRTB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809AbZELRTB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 13:19:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbZELRSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 13:18:49 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:59148 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685AbZELRSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 13:18:48 -0400
Date: Tue, 12 May 2009 19:18:48 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: tom.leiming@gmail.com, arjan@infradead.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] kernel/async.c:introduce async_schedule*_atomic
Message-ID: <20090512191848.25764af6@gondolin>
In-Reply-To: <20090512165227.GE6255@nowhere>
References: <1242141222-8454-1-git-send-email-tom.leiming@gmail.com>
	<20090512154456.GC6255@nowhere>
	<20090512160434.GD6255@nowhere>
	<20090512183105.09e628f0@gondolin>
	<20090512165227.GE6255@nowhere>
Organization: IBM Deutschland Research & Development GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Erich
 Baier Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 May 2009 18:52:29 +0200,
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> This division would make more sense indeed.
> 
> - async_schedule_inatomic() would be nosync() and would use
>   GFP_ATOMIC. I guess the case where we want to run
>   a job synchronously from atomic in case of async failure is too rare
>   (non-existent?).

It would add complexity for those callers providing a function that is
safe to be called in both contexts.

> - async_schedule_nosync() would be only nosync() and would use
>   GFP_KERNEL
> 
> I'm not sure the second case will ever be used though.

It might make sense for the "just fail if we cannot get memory" case.

> 
> Another alternative would be to define a single async_schedule_nosync()
> which also takes a gfp flag.

Wouldn't async_schedule() then need a gfp flag as well?
