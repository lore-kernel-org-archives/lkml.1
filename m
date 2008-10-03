Return-Path: <linux-kernel-owner+w=401wt.eu-S1755470AbYJCHnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470AbYJCHnk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 03:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754403AbYJCHnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 03:43:33 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:46948 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103AbYJCHnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 03:43:32 -0400
Subject: Re: [patch 3/4] cpu alloc: The allocator
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, rusty@rustcorp.com.au, jeremy@goop.org,
       ebiederm@xmission.com, travis@sgi.com, herbert@gondor.apana.org.au,
       xemul@openvz.org
In-Reply-To: <20081003003342.4d592c1f.akpm@linux-foundation.org>
References: <20080929193500.470295078@quilx.com>
	 <20080929193516.278278446@quilx.com>
	 <20081003003342.4d592c1f.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 03 Oct 2008 10:43:31 +0300
Message-Id: <1223019811.30285.12.camel@penberg-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Fri, 2008-10-03 at 00:33 -0700, Andrew Morton wrote:
> > +static void set_map(int start, int length)
> > +{
> > +	while (length-- > 0)
> > +		__set_bit(start++, cpu_alloc_map);
> > +}
> 
> Can we use bitmap_fill() here?

But bitmap_fill() assumes that the starting offset is aligned to
unsigned long (which is not the case here), doesn't it?

﻿On Fri, 2008-10-03 at 00:33 -0700, Andrew Morton wrote:
> But I'd have though that it would be possible to only allocate the
> storage for online CPUs.  That would be a pretty significant win for
> some system configurations?

Maybe, but then you'd have to deal with CPU hotplug... iik.

		Pekka

