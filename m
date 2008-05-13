Return-Path: <linux-kernel-owner+w=401wt.eu-S1758136AbYEMSTI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758136AbYEMSTI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 14:19:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756043AbYEMSSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 14:18:53 -0400
Received: from bar.sig21.net ([88.198.146.85]:44429 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754831AbYEMSSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 14:18:52 -0400
Date: Tue, 13 May 2008 20:18:34 +0200
From: Johannes Stezenbach <js@linuxtv.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Oliver Endriss <o.endriss@gmx.de>, linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Andrew de Quincey <adq_dvb@lidskialf.net>
Subject: Re: [patch, 2.6.26-rc2] dvb: drivers/media/dvb/ttpci/fdump
	firmware build error fix
Message-ID: <20080513181834.GA29133@linuxtv.org>
References: <20080512101231.GA11755@elte.hu> <200805122218.15887@orion.escape-edv.de> <20080512204634.GA10620@linuxtv.org> <200805131633.55469@orion.escape-edv.de> <20080513152359.GA26952@linuxtv.org> <20080513163930.GB21678@elte.hu> <20080513164238.GB21877@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080513164238.GB21877@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Spam-21-Score: -4.7 (----)
X-Spam-21-Report: No, score=-4.7 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=-0.314,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 06:42:38PM +0200, Ingo Molnar wrote:
> 
> * Johannes Stezenbach <js@linuxtv.org> wrote:
> 
> > On Tue, May 13, 2008 at 04:33:54PM +0200, Oliver Endriss wrote:
> > > Johannes Stezenbach wrote:
> > > > You can put PREVENT_FIRMWARE_BUILD=y in your allrandom.config.
> > > 
> > > Sure. And without the patch you can simply add
> > > - STANDALONE=y or
> > > - DVB_AV7110_FIRMWARE=n
> > > to your allrandom.config. ;-)
> > 
> > It is desirable to have one generic "don't break the build because of 
> > missing firmware binaries" option, isn't it?
> 
> it's a bit confusing. PREVENT_FIRMWARE_BUILD=y is the 'weaker' option - 
> a driver might still be operational (with its default firmware), even if 
> no firmware is built. STANDALONE=y is the stronger option - if a driver 
> depends on that it means that the driver cannot be built (and used) at 
> all without a firmware file. To be on the safe side users who have no 
> firmware needs should set both options. (and that's the default as well)

Seems like I'm confused now...

  CONFIG_STANDALONE
    Prompt: Select only drivers that don't need compile-time external firmware

  PREVENT_FIRMWARE_BUILD
    Prompt: Prevent firmware from being built

I guess selecting either one should prevent the build issue
you got, so your patch is right. But I also was wrong on
the meaning of STANDALONE...
Now I wonder why PREVENT_FIRMWARE_BUILD exists at all.


Johannes
