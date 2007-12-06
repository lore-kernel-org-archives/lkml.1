Return-Path: <linux-kernel-owner+w=401wt.eu-S1754419AbXLFPx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419AbXLFPx1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 10:53:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751847AbXLFPxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 10:53:19 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44006 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592AbXLFPxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 10:53:18 -0500
Date: Thu, 6 Dec 2007 10:52:42 -0500
From: Rik van Riel <riel@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Daniel Phillips <phillips@phunq.net>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC] [PATCH] A clean approach to writeout throttling
Message-ID: <20071206105242.3e289a21@cuia.boston.redhat.com>
In-Reply-To: <20071206035511.83bef995.akpm@linux-foundation.org>
References: <200712051603.02183.phillips@phunq.net>
	<200712052221.45409.phillips@phunq.net>
	<20071205233152.c567fa57.akpm@linux-foundation.org>
	<200712060148.53805.phillips@phunq.net>
	<20071206035511.83bef995.akpm@linux-foundation.org>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Dec 2007 03:55:11 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> - We a-priori decide to limit a particular stack's peak memory usage to
>   1MB
> 
> - We empirically discover that the maximum amount of memory which is
>   allocated by that stack on behalf of a single BIO is 16kb.  (ie: that's
>   the most it has ever used for a single BIO).
> 
> - Now, we refuse to feed any more BIOs into the stack when its
>   instantaneous memory usage exceeds (1MB - 16kb).
> 
> Of course, the _average_ memory-per-BIO is much less than 16kb.  So there
> are a lot of BIOs in flight - probably hundreds, but a minimum of 63.

There is only one problem I can see with this.  With network block
IO, some memory will be consumed upon IO completion.  We need to
make sure we reserve (number of in flight BIOs * maximum amount of
memory consumed upon IO completion) memory, in addition to the
memory you're accounting in your example above.

-- 
All Rights Reversed
