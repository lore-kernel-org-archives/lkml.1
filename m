Return-Path: <linux-kernel-owner+w=401wt.eu-S1752471AbYIVLsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471AbYIVLsr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 07:48:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751486AbYIVLsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 07:48:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55990 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363AbYIVLsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 07:48:39 -0400
Date: Mon, 22 Sep 2008 13:48:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, rpurdie@rpsys.net,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/1] SGI X86 UV: Provide a System Activity Indicator
	driver
Message-ID: <20080922114820.GA13990@elte.hu>
References: <20080919143744.009764000@polaris-admin.engr.sgi.com> <20080919143744.190005000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080919143744.190005000@polaris-admin.engr.sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Travis <travis@sgi.com> wrote:

>  arch/x86/kernel/genx2apic_uv_x.c |  138 +++++++++++++++++++++++++++++++++++++++
>  include/asm-x86/uv/uv_hub.h      |   62 +++++++++++++++++

hm, why is this in genx2apic_uv_x.c, not a separate file?

> +	idle_notifier_register(&uv_idle_notifier);

no, we really dont want such overhead in an idle notifier. (those 
interfaces will go away)

As i suggested in my previous mail about this topic, a low-frequency 
sampling method should be used instead, to indicate system status. I 
thought the leds drivers have all that in place already.

	Ingo
