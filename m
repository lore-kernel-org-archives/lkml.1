Return-Path: <linux-kernel-owner+w=401wt.eu-S1764660AbXGaRgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764660AbXGaRgs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 13:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755471AbXGaRgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 13:36:40 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:41965 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935AbXGaRgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 13:36:39 -0400
Date: Tue, 31 Jul 2007 10:36:11 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Manfred Spraul <manfred@colorfullife.com>, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] Use ERESTARTNOHAND if poll() is interrupted by a signal
Message-ID: <20070731173611.GF3673@sequoia.sous-sol.org>
References: <200707291705.l6TH554a003344@colorfullife.mysite.adiungo.com> <20070730163538.67b256da.akpm@linux-foundation.org> <20070731001117.GA583@tv-sign.ru> <20070731001847.GA623@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070731001847.GA623@tv-sign.ru>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov (oleg@tv-sign.ru) wrote:
> > I am not sure. This means we restart sys_poll() with the same timeout
> > if there is no pending signal. I think we need ERESTART_RESTARTBLOCK
> > logic.
> 
> Forgot to mention, sys_select() can use ERESTARTNOHAND because it
> modifies "struct timeval __user *tvp" before return, but sys_poll()
> gets timeout_msecs by value.

Yeah, you're right.  Means sys_poll with STOP/CONT cycles going in
background (and no fds ready) would never return.
