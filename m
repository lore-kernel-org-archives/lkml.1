Return-Path: <linux-kernel-owner+w=401wt.eu-S1754868AbZBPUUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868AbZBPUUn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 15:20:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752242AbZBPUUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 15:20:11 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59450 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752081AbZBPUUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 15:20:10 -0500
Date: Mon, 16 Feb 2009 12:19:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/8] kzfree()
Message-Id: <20090216121925.a34cca6e.akpm@linux-foundation.org>
In-Reply-To: <4999C556.7010605@cs.helsinki.fi>
References: <20090216142926.440561506@cmpxchg.org>
	<20090216115931.12d9b7ed.akpm@linux-foundation.org>
	<4999C556.7010605@cs.helsinki.fi>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Feb 2009 21:58:14 +0200 Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> Hi Andrew,
> 
> Andrew Morton wrote:
> > On Mon, 16 Feb 2009 15:29:26 +0100 Johannes Weiner <hannes@cmpxchg.org> wrote:
> > 
> >> This series introduces kzfree() and converts callsites which do
> >> memset() + kfree() explicitely.
> > 
> > I dunno, this looks like putting lipstick on a pig.
> > 
> > What is the point in zeroing memory just before freeing it?  afacit
> > this is always done as a poor-man's poisoning operation.
> 
> I think they do it as security paranoia to make sure other callers don't 
> accidentally see parts of crypto keys, passwords, and such. So I don't 
> think we can just get rid of the memsets.

Ok, you're right - I thought only a couple were doing that but it looks like
all of them except for perhaps ATM are being non-stupid.
