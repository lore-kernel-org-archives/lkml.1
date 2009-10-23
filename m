Return-Path: <linux-kernel-owner+w=401wt.eu-S1752243AbZJWOzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243AbZJWOzM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 10:55:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752034AbZJWOzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 10:55:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50545 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751758AbZJWOzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 10:55:11 -0400
Date: Fri, 23 Oct 2009 16:55:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Young <hidave.darkstar@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC/PATCH] ratelimit: make output more useful
Message-ID: <20091023145509.GA13793@elte.hu>
References: <200910191706.42223.borntraeger@de.ibm.com> <20091023113348.GD5886@elte.hu> <200910231458.11832.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910231458.11832.borntraeger@de.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> Index: tip/include/linux/kernel.h
> ===================================================================
> --- tip.orig/include/linux/kernel.h
> +++ tip/include/linux/kernel.h
> @@ -16,6 +16,7 @@
>  #include <linux/log2.h>
>  #include <linux/typecheck.h>
>  #include <linux/dynamic_debug.h>
> +#include <linux/ratelimit.h>
>  #include <asm/byteorder.h>
>  #include <asm/bug.h>
>  

hm, this will cause circular dependencies - see:

 3fff4c4: printk: Remove ratelimit.h from kernel.h

Any reason why it couldnt be pushed inside printk.c? We just need the 
func string - not the pointer pass-in. That would also address some of 
the call-site bloat.

	Ingo
