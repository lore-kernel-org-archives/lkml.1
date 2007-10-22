Return-Path: <linux-kernel-owner+w=401wt.eu-S1752587AbXJVQa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587AbXJVQa1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 12:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbXJVQaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 12:30:19 -0400
Received: from znsun1.ifh.de ([141.34.1.16]:57366 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681AbXJVQaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 12:30:18 -0400
X-Greylist: delayed 4731 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Oct 2007 12:30:17 EDT
Date: Mon, 22 Oct 2007 17:10:07 +0200 (CEST)
From: Patrick Boettcher <patrick.boettcher@desy.de>
X-X-Sender: pboettch@pub1.ifh.de
To: Adrian Bunk <bunk@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [v4l-dvb-maintainer] DVB: BANDWIDTH_TO_KHZ strangeness
In-Reply-To: <20071014175055.GJ4211@stusta.de>
Message-ID: <Pine.LNX.4.64.0710221657450.21323@pub1.ifh.de>
References: <20071014175055.GJ4211@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: ALL_TRUSTED,AWL,BAYES_00
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This coverity checker is great. He even finds all the things which are 
there because I'm lazy ;) .

The dibXXXX-drivers are all generated from our internal drivers to have at 
least something for Linux. Because of no time there is no dedicated 
source for the kernel but just the processed one.

The particular issue here is, that the internal architecture supports a 
variable bandwidth while the linux-dvb architecture only has 3 fixed 
values. 

I know that in the future the linux-dvb-API will also support other 
bandwidths so I'm begging for mercy for those 3 things here to not get too 
much out-of-sync with our internal code.

thanks,
Patrick.

On Sun, 14 Oct 2007, Adrian Bunk wrote:
> drivers/media/dvb/frontends/dibx000_common.h contains:
> 
> <--  snip  -->
> 
> ...
> #define BANDWIDTH_TO_KHZ(v) ( (v) == BANDWIDTH_8_MHZ  ? 8000 : \
>                              (v) == BANDWIDTH_7_MHZ  ? 7000 : \
>                              (v) == BANDWIDTH_6_MHZ  ? 6000 : 8000 )
> ...
> 
> <--  snip  -->
> 
> 
> Commit b6884a17fc70e979ef34e4b5560988b522bb50a0 added to both of 
> drivers/media/dvb/frontends/dib7000{m,p}.c:
> 
> <--  snip  -->
> 
> ...
>         factor = BANDWIDTH_TO_KHZ(ch->u.ofdm.bandwidth);
>         if (factor >= 5000)
>                 factor = 1;
>         else
>                 factor = 6;
> ...
> 
> <--  snip  -->
> 
> 
> factor < 5000 is obviously never possible.
> 
> drivers/media/dvb/frontends/dib0070.c contains a similar assumption that 
> BANDWIDTH_TO_KHZ() could result in values other than {6,7,8}000
> (I haven't checked whether there are more such assumptions in other 
> places).
> 
> Spotted by the Coverity checker.
> 
> 
> cu
> Adrian
> 
> -- 
> 
>        "Is there not promise of rain?" Ling Tan asked suddenly out
>         of the darkness. There had been need of rain for many days.
>        "Only a promise," Lao Er said.
>                                        Pearl S. Buck - Dragon Seed
> 
> 
> _______________________________________________
> v4l-dvb-maintainer mailing list
> v4l-dvb-maintainer@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/v4l-dvb-maintainer
> 

