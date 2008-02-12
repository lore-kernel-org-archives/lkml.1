Return-Path: <linux-kernel-owner+w=401wt.eu-S1756523AbYBLEau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523AbYBLEau (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 23:30:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750804AbYBLEak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 23:30:40 -0500
Received: from mail.gmx.net ([213.165.64.20]:41606 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750772AbYBLEaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 23:30:39 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18nLxUscHsn/zu92eV9yPQbp3CCfx4go3Luz5hsZ3
	naH3syQJJZt5sA
Subject: Re: Scheduler(?) regression from 2.6.22 to 2.6.24 for short-lived
	threads
From: Mike Galbraith <efault@gmx.de>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Olof Johansson <olof@lixom.net>, Willy Tarreau <w@1wt.eu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <47B0C1E8.2050809@tmr.com>
References: <20080209000456.GA21021@lixom.net>
	 <1202543920.9578.3.camel@homer.simson.net> <20080209080319.GO8953@1wt.eu>
	 <1202554705.10287.12.camel@homer.simson.net> <20080209114009.GP8953@1wt.eu>
	 <1202564259.4035.18.camel@homer.simson.net> <20080209161957.GA3364@1wt.eu>
	 <20080210052941.GA4731@lixom.net>  <47B0C1E8.2050809@tmr.com>
Content-Type: text/plain
Date: Tue, 12 Feb 2008 05:30:35 +0100
Message-Id: <1202790635.4165.43.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-02-11 at 16:45 -0500, Bill Davidsen wrote:

> I think the moving to another CPU gets really dependent on the CPU type. 
> On a P4+HT the caches are shared, and moving costs almost nothing for 
> cache hits, while on CPUs which have other cache layouts the migration 
> cost is higher. Obviously multi-core should be cheaper than 
> multi-socket, by avoiding using the system memory bus, but it still can 
> get ugly.
> 
> I have an IPC test around which showed that, it ran like hell on HT, and 
> progressively worse as cache because less shared. I wonder why the 
> latest git works so much better?

Yes, I'm wondering the same.  With latest git, ~400 usec work units
suffice to achieve overlap (on my P4/HT), whereas all other kernels
tested require several milliseconds.

	-Mike

