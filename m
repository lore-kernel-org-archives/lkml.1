Return-Path: <linux-kernel-owner+w=401wt.eu-S1757388AbZJBJUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388AbZJBJUb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 05:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757379AbZJBJUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 05:20:30 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52961 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757375AbZJBJU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 05:20:28 -0400
Date: Fri, 2 Oct 2009 11:20:25 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 06/34] don't use __devexit_p to wrap hal2_remove
Message-ID: <20091002092025.GB4442@pengutronix.de>
References: <20091001082607.GA2181@pengutronix.de> <1254385718-14254-6-git-send-email-u.kleine-koenig@pengutronix.de> <s5hy6nvik7o.wl%tiwai@suse.de> <20091001085355.GD2181@pengutronix.de> <s5hzl8agocf.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <s5hzl8agocf.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Oct 02, 2009 at 11:02:56AM +0200, Takashi Iwai wrote:
> At Thu, 1 Oct 2009 10:53:55 +0200,
> Uwe Kleine-König wrote:
> > 
> > On Thu, Oct 01, 2009 at 10:36:59AM +0200, Takashi Iwai wrote:
> > > At Thu,  1 Oct 2009 10:28:10 +0200,
> > > Uwe Kleine-König wrote:
> > > > 
> > > > The function hal2_remove is defined using __exit, so don't use __devexit_p
> > > > but __exit_p to wrap it.
> > > 
> > > I think it's the other way round.  We should replace __exit with __devexit.
> > > Ditto for sound/mips/sgio2audio.c.
> > Actually both ways are possible.  I choosed the alternative that doesn't
> > add bloat to the kernel.  The cost is that the device isn't hotplugable,
> > but you can still unload the module to unbind the driver.
> 
> Hm, is it really safe to set remove=NULL although the driver needs
> some work at unbinding?  It looks like that unbind is allowed no
> matter whether remove is NULL or not.  So, it would jus keeps stray
> resources, and it might conflict at the next bind.
I just tried that and you're right.  IMHO that's a bug.  Greg?

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
