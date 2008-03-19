Return-Path: <linux-kernel-owner+w=401wt.eu-S935964AbYCSVDN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935964AbYCSVDN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:03:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756638AbYCSTxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:53:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42429 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760536AbYCSTxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:53:06 -0400
Date: Wed, 19 Mar 2008 20:52:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de, ak@suse.de
Subject: Re: [PATCH] build fix for smp
Message-ID: <20080319195217.GA20762@elte.hu>
References: <12059466674071-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12059466674071-git-send-email-gcosta@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0094]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Glauber de Oliveira Costa <gcosta@redhat.com> wrote:

> +#if defined(CONFIG_X86_64) || defined(CONFIG_X86_BIOS_REBOOT)
>  	if (reboot_force)
>  		return;
> +#endif

please solve it slightly differently: introduce a uniformly usable 
reboot_force flag, that will always default to the constant of 1 if 
!X86_64 && !X86_BIOS_REBOOT. That makes the code cleaner - and not the 
least i can also merge the fix earlier in the series, without having to 
redo the big smp.c movement patch :-)

	Ingo
