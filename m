Return-Path: <linux-kernel-owner+w=401wt.eu-S1753772AbYAWMs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772AbYAWMs7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 07:48:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751780AbYAWMsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 07:48:52 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4976 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751114AbYAWMsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 07:48:51 -0500
Date: Fri, 11 Jan 2008 17:58:47 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Andrea Righi <righiandr@users.sourceforge.net>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Valdis.Kletnieks@vt.edu,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] per-uid/gid I/O throttling (was Re: [RFC][PATCH] per-task I/O throttling)
Message-ID: <20080111175847.GA4016@ucw.cz>
References: <47869FFE.1050000@users.sourceforge.net> <661de9470801110759h318347acw5f08c91b48ca742d@mail.gmail.com> <47879A32.8060508@users.sourceforge.net> <3777.1200113861@turing-police.cc.vt.edu> <1200131197.7999.14.camel@lappy> <20080112105702.GC25388@balbir.in.ibm.com> <1200136245.7999.20.camel@lappy> <4789006C.2030804@users.sourceforge.net> <20080113044607.GA13633@balbir.in.ibm.com> <478CE41F.5010401@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478CE41F.5010401@users.sourceforge.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-01-15 17:49:36, Andrea Righi wrote:
> Allow to limit the I/O bandwidth for specific uid(s) or gid(s) imposing
> additional delays on those processes that exceed the limits defined in a
> configfs tree.
> 
> Examples:
> 
> Limit the I/O bandwidth for user www-data (UID 33) to 4MB/s:
> 
> root@linux:/config/io-throttle# mkdir uid:33
> root@linux:/config/io-throttle# cd uid:33/
> root@linux:/config/io-throttle/uid:33# cat io-rate
>      io-rate: 0 KiB/sec
>    requested: 0 KiB
> last_request: 0 jiffies
>        delta: 388202 jiffies
> root@linux:/config/io-throttle/uid:33# echo 4096 > io-rate
> root@linux:/config/io-throttle/uid:33# cat io-rate
>      io-rate: 4096 KiB/sec
>    requested: 0 KiB
> last_request: 389271 jiffies
>        delta: 91 jiffies
> 
> Limit the I/O bandwidth of group backup (GID 34) to 512KB/s:

Maybe ionice from cfq should be improved, instead?
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
