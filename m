Return-Path: <linux-kernel-owner+w=401wt.eu-S1753469AbYLCQKB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbYLCQKB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 11:10:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751227AbYLCQJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 11:09:53 -0500
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3530 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbYLCQJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 11:09:52 -0500
Date: Wed, 3 Dec 2008 17:09:07 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@localhost.localdomain
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
cc: john stultz <johnstul@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       alex.shi@intel.com, Thomas Gleixner <tglx@tglx.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] Catch xtime_nsec underflows and fix them
In-Reply-To: <1228279532.2866.192.camel@ymzhang>
Message-ID: <Pine.LNX.4.64.0812031701210.24668@localhost.localdomain>
References: <1228185281.7176.37.camel@localhost.localdomain> 
 <Pine.LNX.4.64.0812022118330.24668@localhost.localdomain> 
 <1228273295.2866.189.camel@ymzhang>  <Pine.LNX.4.64.0812030436590.24668@localhost.localdomain>
 <1228279532.2866.192.camel@ymzhang>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1980313245-1228320547=:24668"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1980313245-1228320547=:24668
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

Hi,

On Wed, 3 Dec 2008, Zhang, Yanmin wrote:

> > > When ﻿﻿xtime_nsec underflows at the first time, xtime.tv_nsec becomes -1.
> > > Later on when the second tick arrives, below statement in the while loop
> > >  clock->xtime_nsec += clock->xtime_interval;
> > > will cause ﻿clock->xtime_nsec becomes positive again. So the second tick
> > > appears a going-backward time.
> > 
> > Yes, but only by 1nsec, so normally it wouldn't be noticable.
> Not 1nsec. At the second tick, go back about 4294967296 nsec (2^32), about
> 4 seconds. That matches the output of testing process.

Above code is not the problem. The error appeared in do_vgettimeofday() as 
it only uses unsigned values, so the -1 became 0xffffffff in nsec and the 
clock jumped forward 4 seconds and a tick later 4 seconds back.

bye, Roman
--8323328-1980313245-1228320547=:24668--
