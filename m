Return-Path: <linux-kernel-owner+w=401wt.eu-S936944AbXGQXyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936944AbXGQXyR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 19:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756863AbXGQXyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 19:54:05 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35308 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583AbXGQXyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 19:54:04 -0400
Date: Wed, 18 Jul 2007 00:54:00 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Uwe Kleine-K?nig <ukleinek@informatik.uni-freiburg.de>,
       Avi Kivity <avi@qumranet.com>, linux-kernel@vger.kernel.org
Subject: Re: a52b1752c07 broke !SMP: error: implicit declaration of function `WARN_ON'
Message-ID: <20070717235400.GQ21668@ftp.linux.org.uk>
References: <20070717232446.GA20140@lala>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070717232446.GA20140@lala>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2007 at 01:24:46AM +0200, Uwe Kleine-K?nig wrote:
> Hello,
> 
> kernel/timer.c (and some others as arch/arm/kernel/irq.c) include
> <linux/smp.h>, but not <linux/kernel.h>
> 
> a52b1752c07 introduces usage of the WARN_ON macro in <linux/smp.h>, but
> doesn't pull in <linux/kernel.h>.  (<asm/bug.h> is not enough, at least
> for arm, because WARN_ON uses printk there.)
> 
> The obvious options are:
> 
> 1) include <linux/kernel.h> in <linux/smp.h>, maybe conditioned by !SMP
> 2) include <linux/kernel.h> in all includers of <linux/smp.h>
> 3) remove the WARN_ONs introduced by a52b1752c07.
> 
> WARN_ON is used in an inline function that isn't used in every file
> including <linux/smp.h>, so maybe updating the compiler might make
> the effort for 2) smaller!?  (I'm using gcc 3.4.4)

4) turn the sucker into macro
