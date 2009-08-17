Return-Path: <linux-kernel-owner+w=401wt.eu-S1757569AbZHQJR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569AbZHQJR3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 05:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757553AbZHQJR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 05:17:29 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:60311 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757528AbZHQJR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 05:17:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=H2FVYLPyUODdQH1BmnKGvRgIl//vl8sbSTBJ+QQMvLH/6UM3QSWmPdgIiEIFZXAi0/
         XefG2XwzhBMhIWlJM0uam4WrSjYwpkqsiYfqjQfd/nuwyzZ+odsNvDAUmbO23a1qU4tJ
         9ZX6VtiliwqzOaO3YBW0/xWifkc+/Wnol2JfI=
Date: Mon, 17 Aug 2009 12:18:58 +0300
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
Subject: Re: [RFC][PATCH 2/3] ASoC: OMAP: Make use of DMA channel self
 linking on OMAP1510
Message-Id: <20090817121858.fe80fb95.jhnikula@gmail.com>
In-Reply-To: <200908101050.05314.jkrzyszt@tis.icnet.pl>
References: <200908101050.05314.jkrzyszt@tis.icnet.pl>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Aug 2009 10:50:04 +0200
Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> wrote:

> Use newly implemented DMA channel self linking on OMAP1510 like on other OMAP
> models. Remove unnecessary DMA transfer restart from interrupt handler
> routine.
> 
> The interrupt routine used to maintain a period index, originally needed for
> counting up periods up to a full buffer in order to restart the DMA transfer.
> For some time, this counter is also used as a replacement for hardware DMA
> progress counter that has been found unusable on OMAP1510 in case of playback.
> Thus, the period index calculation cannot be omitted completely. However, the
> accuracy of this counter can still suffer from missing DMA interrupts.
> 
> In order to work correctly, it requires patch 1 from this series also applied:
> [RFC][PATCH 1/3] ARM: OMAP: DMA: Add support for DMA channel self linking on OMAP1510
> 
> Created against linux-2.6.31-rc5.
> 
> Tested on Amstrad Delta.
> 
> Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
> 
Nice to see code to be more uniform across the OMAP's. Note this
depends on patch 1 which touches the arch/arm/plat-omap/dma.c.

Acked-by: Jarkko Nikula <jhnikula@gmail.com>
