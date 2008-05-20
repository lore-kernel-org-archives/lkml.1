Return-Path: <linux-kernel-owner+w=401wt.eu-S1763735AbYETJWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763735AbYETJWo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 05:22:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761121AbYETJWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 05:22:36 -0400
Received: from mail.gmx.net ([213.165.64.20]:42288 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1761023AbYETJWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 05:22:35 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18gUspczDogvnJIN7qRkqk/++j1aYjL87PoIkVTGA
	OiuSBAiL61zO8a
Subject: Re: hackbench regression with 2.6.26-rc2 on tulsa machine
From: Mike Galbraith <efault@gmx.de>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1211270946.3177.236.camel@ymzhang>
References: <1211270946.3177.236.camel@ymzhang>
Content-Type: text/plain; charset=utf-8
Date: Tue, 20 May 2008 11:22:32 +0200
Message-Id: <1211275352.24305.6.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-05-20 at 16:09 +0800, Zhang, Yanmin wrote:
> Comparing with 2.6.26-rc1, hackbench has about 30% regression with 2.6.26-rc2 on my tulsa machine
> which is a netburst architecure hyper-threading x86_64.
> 
> Command line to test: #hackbench 100 process 2000
> 
> With ﻿2.6.26-rc1, it takes 30 seconds. But with 2.6.26-rc2/rc3, it takes 40 seconds.
> 
> Bisect located below patch:
> 46151122e0a2e80e5a6b2889f595e371fe2b600d is first bad commit
> commit 46151122e0a2e80e5a6b2889f595e371fe2b600d
> Author: Mike Galbraith <efault@gmx.de>
> Date:   Thu May 8 17:00:42 2008 +0200
> 
>     sched: fix weight calculations
>     
>     The conversion between virtual and real time is as follows:
>     
>       dvt = rw/w * dt <=> dt = w/rw * dvt
>     
>     Since we want the fair sleeper granularity to be in real time, we actually
>     need to do:
>     
>       dvt = - rw/w * l
> 
> 
> 
> The bisect steps look stable.
> 
> On my core architecure machines(stoakley and tigerton), I do see improvement instead of regression,
> like result from 31 seconds down to 28 seconds.
> 
> I'm not sure if hyper-threading need more cares in this situation.

Oh joy.  I'll update my poor old P4 and see what I can duplicate this.

Do you still have group scheduling enabled?  If so, can you turn it off
and try again?  (when in doubt, grasp at any straw within reach;)

	-Mike

