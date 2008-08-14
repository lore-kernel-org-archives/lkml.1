Return-Path: <linux-kernel-owner+w=401wt.eu-S1754581AbYHNWZH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581AbYHNWZH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 18:25:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751872AbYHNWY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 18:24:56 -0400
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:24526 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750822AbYHNWY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 18:24:56 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=fB3jD87IrK2xBabdL10iHYF3nnBpnnFYsbBEyHbLDYSMhc5FLMvMsBdIjUoSroWgkFxKwwKl+dXqSWLPbVPLurBHGCNUpLRLs9dJvieNRCVeFSpIWyWvHMeiAcDSW8T++FneHaynqD/Gpr9mgPXZZOqvuyXhacPIyX/EKh4ke4E=  ;
X-YMail-OSG: SYZvQawVM1nXJ9xClzGtdT3P2411TLDCpwPwMUkHwvQ1cbB2rgmnaP0iXIsAyzGlLn5mjHq5GKTdfQXY7eeBefSGFhw6zBB_4gqY7rTZPYJHzFtxtCUQuzxTI6kjMKXKSuo-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Dmitry Baryshkov <dbaryshkov@gmail.com>
Subject: Re: [PATCH] gpiolib: dump correct irq trigger type
Date: Thu, 14 Aug 2008 15:24:53 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <1217770206-6193-1-git-send-email-dbaryshkov@gmail.com>
In-Reply-To: <1217770206-6193-1-git-send-email-dbaryshkov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808141524.53853.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 03 August 2008, Dmitry Baryshkov wrote:
> Use desc->action->flags for dumping irq flags, it is populated with
> correct trigger type.

I'll NAK this ... the trigger type is actually a bit problematic,
it hasn't previously been maintained *anywhere* except possibly as
platform-specific code.  And if it were maintained, desc->status
would be the right place:  the flags for each action would otherwise
need to be updated.

However, given recent cleanups in handling of genirq triggering
I think it's time for me to submit a patch to correct that little
oversight.

- Dave


> Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
> Cc: David Brownell <dbrownell@users.sourceforge.net>
> ---
>  drivers/gpio/gpiolib.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index beaf6b3..a35d19d 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -2,6 +2,7 @@
>  #include <linux/module.h>
>  #include <linux/irq.h>
>  #include <linux/spinlock.h>
> +#include <linux/interrupt.h>
>  
>  #include <asm/gpio.h>
>  
> @@ -570,7 +571,7 @@ static void gpiolib_dbg_show(struct seq_file *s, struct gpio_chip *chip)
>  			if (irq >= 0 && desc->action) {
>  				char *trigger;
>  
> -				switch (desc->status & IRQ_TYPE_SENSE_MASK) {
> +				switch (desc->action->flags & IRQ_TYPE_SENSE_MASK) {
>  				case IRQ_TYPE_NONE:
>  					trigger = "(default)";
>  					break;
> -- 
> 1.5.6.3
> 


