Return-Path: <linux-kernel-owner+w=401wt.eu-S1755843AbXJVS3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843AbXJVS3z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 14:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752531AbXJVS3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 14:29:48 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57335 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbXJVS3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 14:29:47 -0400
Subject: Re: [v4l-dvb-maintainer] DVB: BANDWIDTH_TO_KHZ strangeness
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Patrick Boettcher <patrick.boettcher@desy.de>
Cc: Adrian Bunk <bunk@kernel.org>,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0710221657450.21323@pub1.ifh.de>
References: <20071014175055.GJ4211@stusta.de>
	 <Pine.LNX.4.64.0710221657450.21323@pub1.ifh.de>
Content-Type: text/plain
Date: Mon, 22 Oct 2007 16:29:36 -0200
Message-Id: <1193077776.15350.22.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> I know that in the future the linux-dvb-API will also support other 
> bandwidths so I'm begging for mercy for those 3 things here to not get too 
> much out-of-sync with our internal code.

I don't see much problem on keeping this for a while. 

However, if not causing to much troubles for you to manage, I would to
this, instead:
#if 0
	/* Currently, DVB API allows only bandwidths starting from 5 GHz */
        factor = BANDWIDTH_TO_KHZ(ch->u.ofdm.bandwidth);
        if (factor >= 5000)
                factor = 1;
        else
                factor = 6;
#else
	factor = 6;
#endif

With the above code, gentree.pl scripts will automatically remove the
dead code from the Kernel, while keeping it defined at the development
environment.

If you want, you may also replace the #if 0 by something like:

#ifdef API_SUPPORTS_LOW_BANDWIDTH

In this case, by adding API_SUPPORTS_LOW_BANDWIDTH to gentree.pl, the
same effect of eliminating the dead code from kernel can be produced,
since gentree.pl is capable of evaluating cpp macros like the above to 0
(or 1) for the constants declared on a table inside its code.

-- 
Cheers,
Mauro

