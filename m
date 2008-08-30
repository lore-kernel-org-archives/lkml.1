Return-Path: <linux-kernel-owner+w=401wt.eu-S1757392AbYH3CL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757392AbYH3CL1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 22:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754146AbYH3CLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 22:11:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59627 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754045AbYH3CLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 22:11:19 -0400
Date: Fri, 29 Aug 2008 19:10:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@tglx.de,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 1/5] select: add a timespec version of the timeout to
 select/poll
Message-Id: <20080829191032.077ca1c8.akpm@linux-foundation.org>
In-Reply-To: <20080829080630.5e0ea608@infradead.org>
References: <20080829080549.6906b744@infradead.org>
	<20080829080630.5e0ea608@infradead.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Aug 2008 08:06:30 -0700 Arjan van de Ven <arjan@infradead.org> wrote:

> +	memset(&end_time, 0, sizeof(end_time));

It's a bit dorkward using memset to clear out a structure which
zillions of code sites already know contains only two members.

It could be that two plain old writes is more efficient.  (and it could
be that this is how the compiler implements the memset anyway?)

But I'd suggest that adding a new inlined timespec_zero(timespec*) or
timespec_set(timespec*,int,int) would be nicer.

