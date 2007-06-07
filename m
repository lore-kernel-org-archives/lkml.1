Return-Path: <linux-kernel-owner+w=401wt.eu-S966306AbXFGD1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966306AbXFGD1p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 23:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965527AbXFGD1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 23:27:37 -0400
Received: from gate.crashing.org ([63.228.1.57]:42472 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965390AbXFGD1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 23:27:36 -0400
Subject: Re: [BUG] ptraced process waiting on syscall may return kernel
	internal errnos
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
       Oleg Nesterov <oleg@tv-sign.ru>
In-Reply-To: <alpine.LFD.0.98.0706060811470.4205@woody.linux-foundation.org>
References: <20070606105900.DE5E94D0592@magilla.localdomain>
	 <alpine.LFD.0.98.0706060811470.4205@woody.linux-foundation.org>
Content-Type: text/plain
Date: Thu, 07 Jun 2007 13:27:01 +1000
Message-Id: <1181186821.14818.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-06 at 08:35 -0700, Linus Torvalds wrote:
> So now we should do "recalc_sigpending()" only when signals may be
> *added* 
> (where messing with the "blocked" mask obviously is a form of adding 
> signals, and possibly the most common reason for having to recalculate
> the 
> sigpending mask).
> 
> Comments? This patch is _entirely_ and utterly untested, so I'm only 
> saying that this "feels" safer and more correct to me.

Oh and we still need to at least do the if (tsk == current) thingy
for the DRM notifier hack...

Ben.


