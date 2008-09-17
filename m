Return-Path: <linux-kernel-owner+w=401wt.eu-S1754593AbYIQIik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbYIQIik (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 04:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752422AbYIQIic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 04:38:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43023 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644AbYIQIic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 04:38:32 -0400
Date: Wed, 17 Sep 2008 10:38:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] x86: add KERN_APIC
Message-ID: <20080917083809.GB24035@elte.hu>
References: <1221640067-24389-1-git-send-email-yhlu.kernel@gmail.com> <1221640067-24389-7-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221640067-24389-7-git-send-email-yhlu.kernel@gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> and kill apic_printk
> using loglevel=apic:8 instead

yes, that aspect is very nice.

> +DEFINE_LOGLEVEL_SETUP_DEF(apic, KERN_APIC, "apic:", 6);

> -		printk(KERN_WARNING "APIC calibration not consistent "
> +		printk(KERN_WARNING KERN_APIC "APIC calibration not consistent "

here too the question arises: what should the semantics of the 'mixing' 
of such subsystem printk tags with the classic priority tags be. I think 
in this particular case we dont want the KERN_APIC tag, as that would 
prevent this failure message to be printed by default. I.e. this line 
should remain:

> -		printk(KERN_WARNING "APIC calibration not consistent "

to make sure this warning always shows up in the logs. Agreed?

	Ingo
