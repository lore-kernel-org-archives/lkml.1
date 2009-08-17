Return-Path: <linux-kernel-owner+w=401wt.eu-S932303AbZHQJYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303AbZHQJYf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 05:24:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932187AbZHQJYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 05:24:35 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:56222 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932165AbZHQJYe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 05:24:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=OlC91TUQ0bb+L0eEod1Nj2k4jvnnA35cqLTsrV7WYHODHvHcMGD73QvZV7L+ZAG91E
         N9r1e3eVFXyM0nK1DCO6HFCTvk9EMkcVcob94Bj39RCwobOznKb9RsgDAoIufIWX7hFw
         PslCiAWErmALw1EGSQsY1+0BBfHychmYhwOyU=
Date: Mon, 17 Aug 2009 12:26:05 +0300
From: Jarkko Nikula <jhnikula@gmail.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Peter Ujfalusi <peter.ujfalusi@nokia.com>,
       Tony Lindgren <tony@atomide.com>,
       "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3 v3] ASoC: OMAP: Enhance OMAP1510 DMA progress
 software counter
Message-Id: <20090817122605.0b240ea7.jhnikula@gmail.com>
In-Reply-To: <200908112144.30731.jkrzyszt@tis.icnet.pl>
References: <200908101050.08074.jkrzyszt@tis.icnet.pl>
	<200908110107.11485.jkrzyszt@tis.icnet.pl>
	<200908112144.30731.jkrzyszt@tis.icnet.pl>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Aug 2009 21:44:29 +0200
Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> wrote:

> Enhance period_index accuracy, particularly just before buffer rewind, by
> making use of DMA interrupt status flags in addition to simply counting up
> interrupts.
> 
> Changes since v2:
> > > > -   }
> > > > +   } else if (stat == OMAP_DMA_LAST_IRQ)
> > > > +           return;
> > >
> > > Is this test needed? This interrupt is set only for playback on
> > > omap1510 so this looks null-op.
> >
> > You're right, I have put it here before limiting the flag request to
> > playback on OMAP1510 only. So it can be omitted...
> 
> > > > +           omap_enable_dma_irq(prtd->dma_ch, OMAP_DMA_FRAME_IRQ |
> > > > +                                                   OMAP_DMA_LAST_IRQ);
> > >
> > > Indent OMAP_DMA_LAST_IRQ with tab(s) and spaces to the same column
> > > than OMAP_DMA_FRAME_IRQ. Looks nicer then.
> >
> > OK, will fix it.
> >
> > > Should the
> > > OMAP_DMA_BLOCK_IRQ to be set since it is handled in omap_pcm_dma_irq?
> >
> > This one is already requested from inside omap_request_dma() and used
> > inside omap1_dma_handle_ch() in addition to passing it to us.
> But for less confusion, it'll be better if requested from here too.
> 
I'm fine with this 3rd version. Probably Mark would like to have git
format-patch formatted version for avoiding manual commit log editing.

Acked-by: Jarkko Nikula <jhnikula@gmail.com>
