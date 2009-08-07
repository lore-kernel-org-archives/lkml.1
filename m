Return-Path: <linux-kernel-owner+w=401wt.eu-S1757125AbZHGIqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757125AbZHGIqs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 04:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757033AbZHGIqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 04:46:47 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:46637 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811AbZHGIqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 04:46:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=uM3QByJfSt+7JzoCJZgeC12+vBW7TEf9Nmblx0hCFUiwtIHFdLiEjSch3LGdJJcGc8
         lfGxu6yFDSW2Wa4sGVd+G166NQgeIZo7ASR4x9q8nYar3zZdr9ZlROh64AMXERmN1RLC
         Jg//cKiYsla98o5siCXpdMMEAoqZEVNvmp6rA=
Date: Fri, 7 Aug 2009 11:47:57 +0300
From: Jarkko Nikula <jhnikula@gmail.com>
To: Peter Ujfalusi <peter.ujfalusi@nokia.com>
Cc: alsa-devel@alsa-project.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
       Tony Lindgren <tony@atomide.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH][2.6.31-rc5] ARM: OMAP: McBSP: Fix ASoC on
 OMAP1510 by fixing API of omap_mcbsp_start/stop
Message-Id: <20090807114757.0067a707.jhnikula@gmail.com>
In-Reply-To: <200908071130.54337.peter.ujfalusi@nokia.com>
References: <1249628387-7372-1-git-send-email-jhnikula@gmail.com>
	<200908071130.54337.peter.ujfalusi@nokia.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Aug 2009 11:30:54 +0300
Peter Ujfalusi <peter.ujfalusi@nokia.com> wrote:

> Looks nice, but I would have done it a bit differently...
> 
...
> > -void omap_mcbsp_start(unsigned int id);
> > -void omap_mcbsp_stop(unsigned int id);
> > +void omap_mcbsp_start(unsigned int id, int tx, int rx);
> > +void omap_mcbsp_stop(unsigned int id, int tx, int rx);
> 
> void omap_mcbsp_start(unsigned int id, int dir);
> void omap_mcbsp_stop(unsigned int id, int dir);
> 
Valid point and cleans up a bit the ALSA SoC part of the patch.
However I didn't want to limit this generic arch/arm/plat-omap/mcbsp.c
into audio use case only. My change still allows to start transmitter
and receiver exactly at the same time. Might be worth if the
generic McBSP driver is used for something else than audio.


-- 
Jarkko
