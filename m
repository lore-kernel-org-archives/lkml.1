Return-Path: <linux-kernel-owner+w=401wt.eu-S1754184AbYHTKcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbYHTKcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 06:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbYHTKcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 06:32:03 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52840 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716AbYHTKcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 06:32:01 -0400
Date: Wed, 20 Aug 2008 12:31:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rodolfo Giometti <giometti@linux.it>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 09/10] PPS: low level IRQ timestamps recording.
Message-ID: <20080820103115.GA3912@elte.hu>
References: <1219182612-13814-1-git-send-email-giometti@linux.it> <1219182612-13814-2-git-send-email-giometti@linux.it> <1219182612-13814-3-git-send-email-giometti@linux.it> <1219182612-13814-4-git-send-email-giometti@linux.it> <1219182612-13814-5-git-send-email-giometti@linux.it> <1219182612-13814-6-git-send-email-giometti@linux.it> <1219182612-13814-7-git-send-email-giometti@linux.it> <1219182612-13814-8-git-send-email-giometti@linux.it> <1219182612-13814-9-git-send-email-giometti@linux.it> <1219182612-13814-10-git-send-email-giometti@linux.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219182612-13814-10-git-send-email-giometti@linux.it>
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


* Rodolfo Giometti <giometti@linux.it> wrote:

> Add low level IRQ timestamps recording for x86 (32 and 64 bits)
> platforms and enable UART clients in order to use it.
> 
> This improves PPS precision. :)
> 
> Signed-off-by: Rodolfo Giometti <giometti@linux.it>
> ---
>  arch/x86/kernel/irq_32.c        |   18 ++++++++++++++++++
>  arch/x86/kernel/irq_64.c        |   22 ++++++++++++++++++++--
>  drivers/pps/Kconfig             |   12 ++++++++++++
>  drivers/pps/clients/pps-ldisc.c |   18 ++++++++++++++++++
>  include/linux/pps.h             |    1 +
>  5 files changed, 69 insertions(+), 2 deletions(-)

hm, NACK on this line of approach. If then this instrumentation should 
be done at the genirq level (kernel/irq/*.c). Also, the #ifdefs are ugly 
- please hide them in include files.

	Ingo
