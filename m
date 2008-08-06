Return-Path: <linux-kernel-owner+w=401wt.eu-S1762774AbYHFAS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762774AbYHFAS5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 20:18:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758080AbYHFASt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 20:18:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58815 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753727AbYHFASs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 20:18:48 -0400
Date: Wed, 6 Aug 2008 02:18:45 +0200
From: Karsten Keil <kkeil@suse.de>
To: Sean MacLennan <smaclennan@pikatech.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Karsten Keil <kkeil@suse.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "Andreas.Eversberg" <Andreas.Eversberg@versatel.de>,
       isdn4linux@listserv.isdn4linux.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] Fix remaining big endian issue of hfcmulti
Message-ID: <20080806001845.GA25470@pingi.kke.suse.de>
References: <20080802151532.DE017A3C09@pingi.kke.suse.de> <1217910588.24157.151.camel@pasglop> <20080805113111.GA6827@pingi.kke.suse.de> <1217941466.24157.190.camel@pasglop> <20080805172549.GA6052@pingi.kke.suse.de> <alpine.LFD.1.10.0808051140250.3257@nehalem.linux-foundation.org> <20080805210239.GB6052@pingi.kke.suse.de> <20080805172324.45853d98@lappy.seanm.ca> <alpine.LFD.1.10.0808051435260.3257@nehalem.linux-foundation.org> <20080805175937.49a5ba32@lappy.seanm.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080805175937.49a5ba32@lappy.seanm.ca>
Organization: SuSE Linux AG
X-Operating-System: Linux 2.6.16.54-0.2.5-smp x86_64
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2008 at 05:59:37PM -0400, Sean MacLennan wrote:
> On Tue, 5 Aug 2008 14:37:19 -0700 (PDT)
> "Linus Torvalds" <torvalds@linux-foundation.org> wrote:
> 
> > On Tue, 5 Aug 2008, Sean MacLennan wrote:
> > > 
> > > Why not select PIO or MMIO at config time?  
> > 
> > Umm. Then you can't run a generic driver that can do either. That's
> > the worst choice of all.
> 
> But do we really need a generic driver that can do either? Maybe for the
> current mISDN driver, but when you get to other chip ports, say the
> xhfc, you have to select the low level interface at compile time. Or I
> should say you currently have to select at config time.

For cards based on the HFC mulit chips we need runtime detection, since not
all card support both access methods and this is the only way how
distributions can support all cards.

For the xhfc this may be a differnt choice, to select the access method on
compile time, because the chip is mainly used for embedded systems, so it
do not need to have a generic driver, the kerne is usually configured
exactly for the hardware. On the other side, if you look into the xhfc
chip and documentation, it is not so different from the HFC 4/8S, so maybe
it would be possible to integrate it in hfcmulti as well.

And maybe here is a third way, to have a tristate CONFIG MEMIO,PIO,BOTH,
which could be imlemented in the none indirect call version without
overhead. I think I like this idea.

-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
