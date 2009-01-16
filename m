Return-Path: <linux-kernel-owner+w=401wt.eu-S936445AbZAPO2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936445AbZAPO2r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 09:28:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936402AbZAPO2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 09:28:01 -0500
Received: from mail.gmx.net ([213.165.64.20]:52131 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S936397AbZAPO2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 09:28:00 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18Dz1tMpWoDL/mGbgSgOHqEm+O1A77FIE36sx/W6c
	BONgUgre8fn9ff
Subject: Re: [PATCH 0/2] prefer wakers -v2
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20090114113917.199690328@chello.nl>
References: <20090114113917.199690328@chello.nl>
Content-Type: text/plain
Date: Fri, 16 Jan 2009 15:27:55 +0100
Message-Id: <1232116075.6141.29.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.67
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-14 at 12:39 +0100, Peter Zijlstra wrote:
> OK, so lets try this again...

I took tip out for a little test-drive.  Mysql/pgsql+oltp showed no
effect vs 29.git beyond noise level, but cache hot make -j8 kbuild times
in an nfs4 mount show marked improvement.

2.6.29.git
real    6m29.291s
user    10m20.355s
sys     2m1.288s

2.6.29.tip
real    4m30.160s
user    10m26.115s
sys     2m3.088s

Wire saturates at ~4m, so there's still some room for improvement.

On the interactivity front, tip feels snappier, particularly when IO is
going on.  One place that this is quite noticeable is reading lkml with
evolution while building a new kernel.  I generally keep thread count
low when using evolution because IO makes it sluggish when deleting and
moving on to the next message.  With tip, the evolution experience is
much improved.

	-Mike

