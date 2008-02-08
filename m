Return-Path: <linux-kernel-owner+w=401wt.eu-S1762038AbYBHTLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762038AbYBHTLT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 14:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751808AbYBHTLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 14:11:08 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:34115 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbYBHTLG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 14:11:06 -0500
Date: Fri, 8 Feb 2008 20:11:10 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Rodolfo Giometti <giometti@linux.it>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 1/8] LinuxPPS core support.
Message-ID: <20080208191110.GB31072@uranus.ravnborg.org>
References: <1202493644764-git-send-email-giometti@linux.it> <120249364418-git-send-email-giometti@linux.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <120249364418-git-send-email-giometti@linux.it>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rodolfo.

Kconfig bits are trivial and looks OK.

> diff --git a/drivers/pps/Makefile b/drivers/pps/Makefile
> new file mode 100644
> index 0000000..5a9a51b
> --- /dev/null
> +++ b/drivers/pps/Makefile
> @@ -0,0 +1,10 @@
> +#
> +# Makefile for the PPS core.
> +#
> +
> +pps_core-objs			+= pps.o kapi.o sysfs.o
> +obj-$(CONFIG_PPS)		+= pps_core.o

Please use:
pps_core-y        := pps.o kapi.o sysfs.o
obj-$(CONFIG_PPS) := pps_core.o

The change from '+=' to ':=' is purely cosmetic
but I prefer this way to make it explicit that the
variables contain no other values.

> +
> +ifeq ($(CONFIG_PPS_DEBUG),y)
> +EXTRA_CFLAGS += -DDEBUG
> +endif
And this we do so today:
ccflags-$(CONFIG_PPS_DEBUG) := -DDEBUG


I did not look at the code so do not consider it reviewed by
this feedback.

	Sam

