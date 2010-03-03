Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab0CCRmw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 12:42:52 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56710 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754969Ab0CCRmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 12:42:51 -0500
Subject: Re: [RFC][PATCH 06/11] perf, x86: PEBS infrastructure
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, paulus@samba.org,
       eranian@google.com, fweisbec@gmail.com
In-Reply-To: <20100303173802.GL13205@erda.amd.com>
References: <20100303163936.906011640@chello.nl>
	 <20100303164306.299625712@chello.nl>  <20100303173802.GL13205@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Mar 2010 18:42:48 +0100
Message-ID: <1267638168.25158.98.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-03 at 18:38 +0100, Robert Richter wrote:
> > +     fake_cpuc = kmalloc(sizeof(*fake_cpuc), GFP_KERNEL | __GFP_ZERO);
> > +     if (!fake_cpuc)
> > +             return -ENOMEM;
> > +
> > +     c = x86_pmu.get_event_constraints(fake_cpuc, event);
> > +
> > +     if (!c || !c->weight)
> > +             ret = -ENOSPC;
> > +
> > +     if (x86_pmu.put_event_constraints)
> > +             x86_pmu.put_event_constraints(fake_cpuc, event);
> 
> A fake cpu with the struct filled with zeros will cause a null pointer
> exception in amd_get_event_constraints():
> 
>         struct amd_nb *nb = cpuc->amd_nb;

That should result in nb == NULL, right? which is checked slightly
further in the function.

> Shouldn't x86_schedule_events() sufficient to decide if a single
> counter is available? I did not yet look at group events, this might
> happen there too.

Sure, but we will only attempt scheduling them at enable time, this is a
creation time check, failing to create an unschedulable event seems
prudent.

