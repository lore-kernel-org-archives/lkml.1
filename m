Return-Path: <linux-kernel-owner+w=401wt.eu-S1754803AbYIQIfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbYIQIfr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 04:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754601AbYIQIfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 04:35:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58012 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460AbYIQIfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 04:35:33 -0400
Date: Wed, 17 Sep 2008 10:35:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] pci: using printk(KERN_PCI v3
Message-ID: <20080917083506.GA24035@elte.hu>
References: <1221640067-24389-1-git-send-email-yhlu.kernel@gmail.com> <1221640067-24389-4-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221640067-24389-4-git-send-email-yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0005]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> -			printk(KERN_DEBUG "PCI: %s reg %x 64bit mmio: [%llx, %llx]\n",
> +			printk(KERN_DEBUG KERN_PCI
> +				 "PCI: %s reg %x 64bit mmio: [%llx, %llx]\n",

i think we should aim to make the common usage of this facility as easy 
and short as possible. That means that i think the right line is:

+			printk(KERN_PCI
+				 "PCI: %s reg %x 64bit mmio: [%llx, %llx]\n",

as that is the shortest form. KERN_PCI should imply whatever 
common-sense default. It should still make sense to specify KERN_FOO 
KERN_PCI, to override that default.

	Ingo
