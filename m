Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab0CDQu6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 11:50:58 -0500
Received: from tenax.loup.net ([209.169.16.66]:34262 "EHLO tenax.loup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756133Ab0CDQuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 11:50:55 -0500
Date: Thu, 4 Mar 2010 09:37:55 -0700
Message-Id: <201003041637.o24GbtJX005739@alien.loup.net>
From: Mike Hayward <hayward@loup.net>
To: foosaa@gmail.com
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, jens.axboe@oracle.com, linux-mm@kvack.org
In-reply-to: <f875e2fe1003040458o3e13de97v3d839482939b687b@mail.gmail.com>
	(message from foo saa on Thu, 4 Mar 2010 07:58:07 -0500)
Subject: Re: Linux kernel - Libata bad block error handling to user mode 
	program
References: <f875e2fe1003032052p944f32ayfe9fe8cfbed056d4@mail.gmail.com>
	 <20100303224245.ae8d1f7a.akpm@linux-foundation.org> <f875e2fe1003040458o3e13de97v3d839482939b687b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I always take it for granted, but forgot to mention, you should also
use O_DIRECT to bypass the linux buffer cache.  It often gets in the
way of error propagation since it is changing your io requests into
it's own page sized ios and will also "lie" to you about having
written your data in the first place since it's a write back cache.

The point is you have to disable all the caches everywhere or the
error information will get absorbed by the caches.

- Mike
