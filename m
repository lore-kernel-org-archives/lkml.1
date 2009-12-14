Return-Path: <linux-kernel-owner+w=401wt.eu-S1751101AbZLNNDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751101AbZLNNDW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 08:03:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750706AbZLNNDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 08:03:21 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:36450 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667AbZLNNDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 08:03:20 -0500
Date: Mon, 14 Dec 2009 08:03:02 -0500
From: Christoph Hellwig <hch@infradead.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>, lwoodman@redhat.com,
       akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, minchan.kim@gmail.com
Subject: Re: [PATCH 2/8] Mark sleep_on as deprecated
Message-ID: <20091214130302.GA25797@infradead.org>
References: <20091211164651.036f5340@annuminas.surriel.com> <20091214210823.BBAE.A69D9226@jp.fujitsu.com> <20091214212351.BBB4.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091214212351.BBB4.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 14, 2009 at 09:24:40PM +0900, KOSAKI Motohiro wrote:
> 
> 
> sleep_on() function is SMP and/or kernel preemption unsafe. we shouldn't
> use it on new code.

And the best way to archive this is to remove the function.

In Linus' current tree I find:

 - 5 instances of sleep_on(), all in old and obscure block drivers
 - 2 instances of sleep_on_timeout(), both in old and obscure drivers 
 
 - 28 instances of interruptible_sleep_on_timeout(), mostly in obscure
   drivers with a high concentration in the old oss core which should be
   killed anyway.  And unfortunately a few relatively recent additions
   like the SGI xpc driver or usbvision driver
 - tons of instances of interruptible_sleep_on all over the drivers code

So I think you're be better off just killing the first two ASAP instead
of just deprecating them.

for the other two deprecating and removing some of the horrible drivers
still using them might be best.
