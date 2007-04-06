Return-Path: <linux-kernel-owner+w=401wt.eu-S1767560AbXDFK2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767560AbXDFK2z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 06:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767567AbXDFK2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 06:28:55 -0400
Received: from www.osadl.org ([213.239.205.134]:59673 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1767560AbXDFK2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 06:28:54 -0400
Subject: Re: [2.6 patch] the scheduled -EINVAL for invalid timevals in
	setitimer
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Adrian Bunk <bunk@stusta.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070406102036.GF29169@stusta.de>
References: <20070406102036.GF29169@stusta.de>
Content-Type: text/plain
Date: Fri, 06 Apr 2007 12:29:19 +0200
Message-Id: <1175855360.28263.439.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-06 at 12:20 +0200, Adrian Bunk wrote:
> As scheduled, do_setitimer() now returns -EINVAL for invalid timeval.
>
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

Ha, you beat me by a minute :)

> -	check_itimerval(value);
> +	if (unlikely(!timeval_valid(&value->it_value) || !timeval_valid(&value->it_interval)))
> +		return -EINVAL;
>  

Please make this:

+       if (!timeval_valid(&value->it_value) ||
+           !timeval_valid(&value->it_interval))
+               return -EINVAL;

	tglx


