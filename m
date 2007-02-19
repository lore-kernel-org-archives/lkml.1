Return-Path: <linux-kernel-owner+w=401wt.eu-S1750772AbXBSJQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750772AbXBSJQp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 04:16:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750777AbXBSJQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 04:16:45 -0500
Received: from mu-out-0910.google.com ([209.85.134.186]:12319 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbXBSJQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 04:16:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HqCyUlftrbdDSbfzH7cDThIjxsrQn70IE5jV3W3/bc9wONETvO/U27flEF6OX2IZJ5VCzwvxu9N+w4M6Qjp8xSwgAWHI8wsCddqz8p7zKwkW85hQ48AvVE02WGkCOErJBD12NXGnORWJLdV+zw/fRTq2e4Qn002AijAgmRl98iE=
Message-ID: <aec7e5c30702190116j26efcba3oe5223584f99ac25a@mail.gmail.com>
Date: Mon, 19 Feb 2007 18:16:42 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH][0/4] Memory controller (RSS Control)
Cc: "Balbir Singh" <balbir@in.ibm.com>, linux-kernel@vger.kernel.org,
       vatsa@in.ibm.com, ckrm-tech@lists.sourceforge.net, xemul@sw.ru,
       linux-mm@kvack.org, menage@google.com, svaidy@linux.vnet.ibm.com,
       devel@openvz.org
In-Reply-To: <20070219005441.7fa0eccc.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070219065019.3626.33947.sendpatchset@balbir-laptop>
	 <20070219005441.7fa0eccc.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/19/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Mon, 19 Feb 2007 12:20:19 +0530 Balbir Singh <balbir@in.ibm.com> wrote:
>
> > This patch applies on top of Paul Menage's container patches (V7) posted at
> >
> >       http://lkml.org/lkml/2007/2/12/88
> >
> > It implements a controller within the containers framework for limiting
> > memory usage (RSS usage).

> The key part of this patchset is the reclaim algorithm:
>
> Alas, I fear this might have quite bad worst-case behaviour.  One small
> container which is under constant memory pressure will churn the
> system-wide LRUs like mad, and will consume rather a lot of system time.
> So it's a point at which container A can deleteriously affect things which
> are running in other containers, which is exactly what we're supposed to
> not do.

Nice with a simple memory controller. The downside seems to be that it
doesn't scale very well when it comes to reclaim, but maybe that just
comes with being simple. Step by step, and maybe this is a good first
step?

Ideally I'd like to see unmapped pages handled on a per-container LRU
with a fallback to the system-wide LRUs. Shared/mapped pages could be
handled using PTE ageing/unmapping instead of page ageing, but that
may consume too much resources to be practical.

/ magnus
