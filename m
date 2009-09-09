Return-Path: <linux-kernel-owner+w=401wt.eu-S1753176AbZIIOJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176AbZIIOJc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 10:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752460AbZIIOJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 10:09:32 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:50259 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751768AbZIIOJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 10:09:31 -0400
Date: Wed, 9 Sep 2009 10:08:23 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, linux-mm <linux-mm@kvack.org>,
       Oleg Nesterov <onestero@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [rfc] lru_add_drain_all() vs isolation
In-Reply-To: <20090909131945.0CF5.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.1.10.0909091005010.28070@V090114053VZO-1>
References: <alpine.DEB.1.10.0909081110450.30203@V090114053VZO-1> <alpine.DEB.1.10.0909081124240.30203@V090114053VZO-1> <20090909131945.0CF5.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Sep 2009, KOSAKI Motohiro wrote:

> Christoph, I'd like to discuss a bit related (and almost unrelated) thing.
> I think page migration don't need lru_add_drain_all() as synchronous, because
> page migration have 10 times retry.

True this is only an optimization that increases the chance of isolation
being successful. You dont need draining at all.

> Then asynchronous lru_add_drain_all() cause
>
>   - if system isn't under heavy pressure, retry succussfull.
>   - if system is under heavy pressure or RT-thread work busy busy loop, retry failure.
>
> I don't think this is problematic bahavior. Also, mlock can use asynchrounous lru drain.
>
> What do you think?

The retries can be very fast if the migrate pages list is small. The
migrate attempts may be finished before the IPI can be processed by the
other cpus.


