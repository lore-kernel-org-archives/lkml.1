Return-Path: <linux-kernel-owner+w=401wt.eu-S1754533AbZLAR4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533AbZLAR4t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 12:56:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754446AbZLAR4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 12:56:48 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:41295 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753087AbZLAR4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 12:56:47 -0500
Subject: Re: Q, slab, kmemleak_erase() and redzone?
From: Catalin Marinas <catalin.marinas@arm.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: hooanon05@yahoo.co.jp, linux-kernel@vger.kernel.org
In-Reply-To: <4B1502E3.4000304@cs.helsinki.fi>
References: <4B1502E3.4000304@cs.helsinki.fi>
Content-Type: text/plain
Organization: ARM Ltd
Date: Tue, 01 Dec 2009 17:56:50 +0000
Message-Id: <1259690210.2121.233.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Dec 2009 17:56:51.0383 (UTC) FILETIME=[A9026470:01CA72AF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-01 at 11:49 +0000, Pekka Enberg wrote:
> hooanon05@yahoo.co.jp kirjoitti:
> > Pekka Enberg:
> >> We are setting an element in the per CPU array to NULL so the the
> >> kmemleak code in ____cache_alloc() is safe. Red-zoning is done at the
> >> _object_ which is not touched by kmemleak. Looking at the oops, it
> >> does seem likely that you have a bug in your module (or in some other
> >> part of the kernel).
> >
> > Thanks for reply.
> > In ____cache_alloc(), the variable 'ac' is assigned before
> > cache_alloc_refill() call, and it is used for the parameter of
> > kmemleak_erase(). The value may be changed by cache_alloc_refill(),
> > isn't it?
> 
> No. The pointer returned by cpu_cache_get() is not changed by
> cache_alloc_refill(). The contents of the array might change, yes. That
> said, we should check if objp is NULL before calling kmemleak_erase().

Possibly but I don't understand why that's needed. The kmemleak_erase()
call just sets the ac->entry[ac->avail] to NULL. If ac->avail is 0, it
doesn't cause any harm.

Thanks.

-- 
Catalin

