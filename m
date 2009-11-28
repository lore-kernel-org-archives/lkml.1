Return-Path: <linux-kernel-owner+w=401wt.eu-S1752606AbZK1QsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbZK1QsR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 11:48:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752256AbZK1QsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 11:48:16 -0500
Received: from isilmar.linta.de ([213.133.102.198]:60685 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752120AbZK1QsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 11:48:16 -0500
Date: Sat, 28 Nov 2009 17:48:19 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Komuro <komurojun-mbn@nifty.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       x86@kernel.org, linux-pcmcia@lists.infradead.org,
       linux-kernel@vger.kernel.org
Cc: Peter Stuge <peter@stuge.se>
Subject: Re: Re: ioports 0x100-0x3af and iomem 0xd000-0xdffff, 0xa0000000-0xa0ffffff -- safe to use on x86 for pcmcia?
Message-ID: <20091128164819.GB9797@isilmar.linta.de>
Mail-Followup-To: Komuro <komurojun-mbn@nifty.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, x86@kernel.org,
	linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
	Peter Stuge <peter@stuge.se>
References: <20091124213723.GA22689@comet.dominikbrodowski.net> <20091124231653.30084.qmail@stuge.se> <20091124213723.GA22689@comet.dominikbrodowski.net> <20091125113622.5b1218b0@lxorguk.ukuu.org.uk> <20091124231653.30084.qmail@stuge.se> <20091124213723.GA22689@comet.dominikbrodowski.net> <10200001.47511259150210534.komurojun-mbn@nifty.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091124231653.30084.qmail@stuge.se> <20091125113622.5b1218b0@lxorguk.ukuu.org.uk> <10200001.47511259150210534.komurojun-mbn@nifty.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Wed, Nov 25, 2009 at 08:56:50PM +0900, Komuro wrote:
> > Do you think it would be safe to enable these areas by (kernel) default on
> > x86? Of course, other entries in /proc/io{mem,ports} would be honoured, there
> > would be a boot option to disable this feature, and some tests are run on the
> > iomem and ioport resource areas.
> 
> The problem you have is that you change the ordering.
> 
> If you load the ne2k ISA driver before pcmcia (as occurs now because of
> it being done from user space) the resources get claimed first. If you do
> it the other way around and test then merely reading an I/O register
> mapped to an NE2K or most NE2K clones crashes the machine.

... and even adding a late_initcall() has its problems.

> Are there any modern systems where the PCI based autoconfig is
> insufficient, or is this just ancient stuff  ?

I'm not familiar with embedded stuff, but usually PCI-based autoconfig
should be sufficient nowadays. Therefore, the only workable way seems to be
an optional module parameter

rsrc_nonstatic.include_io=0x100,0x3af,0x3e0,0x4ff,0x800,0x820,0xc00,0xcf7,0xa00,0xaff
rsrc_nonstatic.include_mem=0xc0000,0xfffff,0xa0000000,0xa0ffffff,0x60000000,0x60ffffff

or something like that. Thanks for the input!

Best,
	Dominik
