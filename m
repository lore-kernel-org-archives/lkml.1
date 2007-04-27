Return-Path: <linux-kernel-owner+w=401wt.eu-S1755456AbXD0Hwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbXD0Hwm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 03:52:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755458AbXD0Hwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 03:52:42 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:58797 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148AbXD0Hwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 03:52:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=IC5C9URpLwU+j2/F14rfk6Wyf67sgop7ZH1pnGypYau6PEo6bvadWpOhaSg1g0ZcUb2o/eBm2I9rHg6hTjkS8RWwNN8VFqVA7e2m24b450px0rm9nFGjrSt8nZ6GsF1urEW5CrtMbwxiqTghECNyzUakpAnBzvRSoIzmhB7myTo=
Message-ID: <74d0deb30704270052w1b6e2b92t590368936e711d6d@mail.gmail.com>
Date: Fri, 27 Apr 2007 09:52:39 +0200
From: "pHilipp Zabel" <philipp.zabel@gmail.com>
To: "Matt Reimer" <mreimer@vpop.net>
Subject: Re: [2/2] Driver for the Maxim DS1WM, a 1-wire bus master ASIC core.
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>, linux-kernel@vger.kernel.org
In-Reply-To: <50E54C86-53FA-4FEE-83ED-AB0BF2E56F48@vpop.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070424100203.GB16473@2ka.mipt.ru>
	 <20070425174643.f1fc189d.akpm@linux-foundation.org>
	 <50E54C86-53FA-4FEE-83ED-AB0BF2E56F48@vpop.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/26/07, Matt Reimer <mreimer@vpop.net> wrote:
> On Apr 25, 2007, at 5:46 PM, Andrew Morton wrote:
>
> > On Tue, 24 Apr 2007 14:02:03 +0400 Evgeniy Polyakov
> > <johnpol@2ka.mipt.ru> wrote:
> >
> >> +#define DS1WM_CMD_1W_RESET  1 << 0  /* force reset on 1-wire bus */
> >> +#define DS1WM_CMD_SRA           1 << 1      /* enable Search ROM accelerator
> >> mode */
> >> +#define DS1WM_CMD_DQ_OUTPUT 1 << 2  /* write only - forces bus low */
> >> +#define DS1WM_CMD_DQ_INPUT  1 << 3  /* read only - reflects state
> >> of bus */
> >> +
> >> +#define DS1WM_INT_PD            1 << 0      /* presence detect */
> >> +#define DS1WM_INT_PDR           1 << 1      /* presence detect result */
> >> +#define DS1WM_INT_TBE           1 << 2      /* tx buffer empty */
> >> +#define DS1WM_INT_TSRE          1 << 3      /* tx shift register empty */
> >> +#define DS1WM_INT_RBF           1 << 4      /* rx buffer full */
> >> +#define DS1WM_INT_RSRF          1 << 5      /* rx shift register full */
> >> +
> >> +#define DS1WM_INTEN_EPD         1 << 0      /* enable presence detect int */
> >> +#define DS1WM_INTEN_IAS         1 << 1      /* INTR active state */
> >> +#define DS1WM_INTEN_ETBE    1 << 2  /* enable tx buffer empty int */
> >> +#define DS1WM_INTEN_ETMT    1 << 3  /* enable tx shift register
> >> empty int */
> >> +#define DS1WM_INTEN_ERBF    1 << 4  /* enable rx buffer full int */
> >> +#define DS1WM_INTEN_ERSRF   1 << 5  /* enable rx shift register
> >> full int */
> >> +#define DS1WM_INTEN_DQO         1 << 6      /* enable direct bus driving ops
> >> +                                       (undocumented), Szabolcs Gyurko */
> >
> > These macros are very dangerous - please parenthesise them all.
>
> (and several other helpful suggestions...)
>
> Thanks for your review Andrew. I made all the code changes you
> suggested in the attached patch.
>
> Matt
>
>

diff --git a/drivers/w1/masters/Makefile b/drivers/w1/masters/Makefile
index 4cee256..a9e45fb 100644
--- a/drivers/w1/masters/Makefile
+++ b/drivers/w1/masters/Makefile
@@ -5,4 +5,4 @@
 obj-$(CONFIG_W1_MASTER_MATROX)		+= matrox_w1.o
 obj-$(CONFIG_W1_MASTER_DS2490)		+= ds2490.o
 obj-$(CONFIG_W1_MASTER_DS2482)		+= ds2482.o
-
+obj-$(CONFIG_W1_DS1WM)                  += ds1wm.o

Wouldn't it be better to call the config option CONFIG_W1_MASTER_DS1WM
for consistency?

regards
Philipp
