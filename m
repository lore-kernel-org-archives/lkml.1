Return-Path: <linux-kernel-owner+w=401wt.eu-S1754092AbYJEHQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbYJEHQc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 03:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752416AbYJEHQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 03:16:23 -0400
Received: from relay.2ka.mipt.ru ([194.85.80.65]:55723 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734AbYJEHQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 03:16:22 -0400
Date: Sun, 5 Oct 2008 11:14:26 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>
Subject: Re: 2.6.27-rc8-git7: Reported regressions from 2.6.26
Message-ID: <20081005071421.GA17685@2ka.mipt.ru>
References: <0pOgGB.A.uLG.E475IB@wind>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0pOgGB.A.uLG.E475IB@wind>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Sat, Oct 04, 2008 at 07:28:42PM +0200, Rafael J. Wysocki (rjw@sisk.pl) wrote:
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11308
> Subject		: tbench regression on each kernel release from 2.6.22 -&gt; 2.6.28
> Submitter	: Christoph Lameter <cl@linux-foundation.org>
> Date		: 2008-08-11 18:36 (55 days old)
> References	: http://marc.info/?l=linux-kernel&m=121847986119495&w=4
> 		  http://marc.info/?l=linux-kernel&m=122125737421332&w=4

Just for the reference, this one regresses from the 2.6.23. Particular
2.6.26-27 part can be partially fixed by disabling TSO/GSO, since tbench
workload issues quite small packets, and system has no time to
incorporate them into particulary big TSO/GSO frame to get advantage of
this technology. The most noticeble perfromance drop was between 23 and
24 kernels. I work on this issue.
 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11207
> Subject		: VolanoMark regression with 2.6.27-rc1
> Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
> Date		: 2008-07-31 3:20 (66 days old)
> References	: http://marc.info/?l=linux-kernel&m=121747464114335&w=4
> Handled-By	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
> 		  Peter Zijlstra <a.p.zijlstra@chello.nl>
> 		  Dhaval Giani <dhaval@linux.vnet.ibm.com>
> 		  Miao Xie <miaox@cn.fujitsu.com>

This one is different, but any other benchmark related to network over
loopback (and in some case over other media) performance degradation
should be very likely handled by the above case.

-- 
	Evgeniy Polyakov
