Return-Path: <linux-kernel-owner+w=401wt.eu-S1764269AbXJOWDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764269AbXJOWDx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 18:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755770AbXJOWDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 18:03:43 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:1816 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761162AbXJOWDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 18:03:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pVsBRZIBd+x75u2ZWVhdVgmEnkLPlxD/hWrXr00m4sVIJeJp4d7mxsQKjp3+bZBwjoVo+lOP5JMu/jHlSfdJax44+WtG19+yFUTntouvVsFZ8h+uCnOgbUB3P0b8u/7ppG1ZTS5wRLATLy27E5LzxMGcp6wrV1CejkcaubU9IGo=
Message-ID: <8bd0f97a0710151503u4b57dd4aoc4b50d936e17adb0@mail.gmail.com>
Date: Mon, 15 Oct 2007 18:03:35 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/3] Blackfin serial driver: this driver enable SPORTs on Blackfin emulate UART
Cc: "Bryan Wu" <bryan.wu@analog.com>, dmitry.torokhov@gmail.com,
       linux-input@atrey.karlin.mff.cuni.cz,
       linux-joystick@atrey.karlin.mff.cuni.cz, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071015133326.995a4f38.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1192098220-25828-1-git-send-email-bryan.wu@analog.com>
	 <1192098220-25828-4-git-send-email-bryan.wu@analog.com>
	 <20071015133326.995a4f38.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > +config SERIAL_BFIN_SPORT
> > +     tristate "Blackfin SPORT emulate UART (EXPERIMENTAL)"
> > +     depends on BFIN && EXPERIMENTAL
> > +     select SERIAL_CORE
> > +     help
> > +       Enble support SPORT emulate UART on Blackfin series.
>
> There's a typo there.  Also the text is pretty meaningless - I'd fix it up
> but I'm not sure what it's trying to tell us!

here it is in english ;)

This driver emulates a standard UART using the SPORT peripherals on a
Blackfin processor.

> > +     snprintf(buffer, 20, "%s rx", up->name);
> > +     retval = request_irq(up->rx_irq, sport_uart_rx_irq, IRQF_SAMPLE_RANDOM, buffer, up);
> > +     if (retval) {
> > +             printk(KERN_ERR "Unable to request interrupt %s\n", buffer);
> > +             return retval;
> > +     }
> > +
> > +     snprintf(buffer, 20, "%s tx", up->name);
> > +     retval = request_irq(up->tx_irq, sport_uart_tx_irq, IRQF_SAMPLE_RANDOM, buffer, up);
> > +     if (retval) {
> > +             printk(KERN_ERR "Unable to request interrupt %s\n", buffer);
> > +             goto fail1;
> > +     }
> > +
> > +     snprintf(buffer, 20, "%s err", up->name);
> > +     retval = request_irq(up->err_irq, sport_uart_err_irq, IRQF_SAMPLE_RANDOM, buffer, up);
> > +     if (retval) {
> > +             printk(KERN_ERR "Unable to request interrupt %s\n", buffer);
> > +             goto fail2;
> > +     }
>
> It is not a good idea to create files in /proc which have spaces in their
> names.  Yes, userspace _should_ be able to cope with that in all cases, but
> all software sucks, even including userspace ;)
>
> I'd suggest that we be defensive here, and avoid using spaces in filenames.

i'm not sure i follow ... these are the names given to request_irq()
which means this is what shows up in /proc/interrupts ... does this
function also create an actual file somewhere in /proc that i am not
aware of ?

the rest of the comments look good to me, thanks !
-mike
