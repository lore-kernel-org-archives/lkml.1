Return-Path: <linux-kernel-owner+w=401wt.eu-S1756234AbZJKQkQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234AbZJKQkQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 12:40:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756059AbZJKQkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 12:40:14 -0400
Received: from vpnflf.ccur.com ([12.192.68.2]:31389 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756050AbZJKQkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 12:40:14 -0400
Date: Sun, 11 Oct 2009 12:39:28 -0400
From: Joe Korty <joe.korty@ccur.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: NOHZ: local_softirq_pending 08
Message-ID: <20091011163928.GA14263@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
References: <20091011095217.GA2200@darkstar>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091011095217.GA2200@darkstar>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 11, 2009 at 05:52:18PM +0800, Dave Young wrote:
> With kernel 2.6.32-rc3-00052-g0eca52a I got following KERN_ERR
> messages just while using firefox:
> 
> [  130.527399] NOHZ: local_softirq_pending 08
> [  130.559807] NOHZ: local_softirq_pending 08
> ...
> 
> Any idea? or known issue?

We have a single customer which also has this issue.
We've never been able to replicate it ourselves, but
for that one customer, changing the two places in the
networking code that use:

	__raise_softirq_irqoff
to
	raise_softirq_irqoff

seems (so far) to be working.

Regards,
Joe
