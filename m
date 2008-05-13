Return-Path: <linux-kernel-owner+w=401wt.eu-S1760494AbYENAPG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760494AbYENAPG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 20:15:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756762AbYENAO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 20:14:56 -0400
Received: from mail.gmx.net ([213.165.64.20]:50719 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756727AbYENAOz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 20:14:55 -0400
X-Authenticated: #476490
X-Provags-ID: V01U2FsdGVkX1/iHF4PwCziGCu2BodZskkkkEm9kOGabTgqEO9ywT
	cjS722CDsrd5Rs
From: Oliver Endriss <o.endriss@gmx.de>
Organization: ESCAPE GmbH EDV-Loesungen
To: Johannes Stezenbach <js@linuxtv.org>
Subject: Re: [patch, 2.6.26-rc2] dvb: drivers/media/dvb/ttpci/fdump firmware build error fix
Date: Wed, 14 May 2008 01:49:47 +0200
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Andrew de Quincey <adq_dvb@lidskialf.net>
References: <20080512101231.GA11755@elte.hu> <20080513164238.GB21877@elte.hu> <20080513181834.GA29133@linuxtv.org>
In-Reply-To: <20080513181834.GA29133@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805140149.48569@orion.escape-edv.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Stezenbach wrote:
> On Tue, May 13, 2008 at 06:42:38PM +0200, Ingo Molnar wrote:
> > 
> > * Johannes Stezenbach <js@linuxtv.org> wrote:
> > 
> > > On Tue, May 13, 2008 at 04:33:54PM +0200, Oliver Endriss wrote:
> > > > Johannes Stezenbach wrote:
> > > > > You can put PREVENT_FIRMWARE_BUILD=y in your allrandom.config.
> > > > 
> > > > Sure. And without the patch you can simply add
> > > > - STANDALONE=y or
> > > > - DVB_AV7110_FIRMWARE=n
> > > > to your allrandom.config. ;-)
> > > 
> > > It is desirable to have one generic "don't break the build because of 
> > > missing firmware binaries" option, isn't it?
> > 
> > it's a bit confusing. PREVENT_FIRMWARE_BUILD=y is the 'weaker' option - 
> > a driver might still be operational (with its default firmware), even if 
> > no firmware is built. STANDALONE=y is the stronger option - if a driver 
> > depends on that it means that the driver cannot be built (and used) at 
> > all without a firmware file. To be on the safe side users who have no 
> > firmware needs should set both options. (and that's the default as well)
> 
> Seems like I'm confused now...
> 
>   CONFIG_STANDALONE
>     Prompt: Select only drivers that don't need compile-time external firmware
> 
>   PREVENT_FIRMWARE_BUILD
>     Prompt: Prevent firmware from being built

After reading the text again I still think that my understanding is
correct [1].

CONFIG_STANDALONE disables drivers which require a firmware file at
compile-time. av7110 with DVB_AV7110_FIRMWARE=y is this kind of driver.

PREVENT_FIRMWARE_BUILD controls building (= compiling) the firmware from
source. As we do not ship the source of the av7110 firmware, this option
does not apply.

So everything should be fine 'as is'.

CU
Oliver

Notes:
[1] Of course, I am open to corrections from the kbuild gurus. ;-)

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
----------------------------------------------------------------
