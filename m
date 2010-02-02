Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449Ab0BBMLT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 07:11:19 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:58918 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907Ab0BBMLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 07:11:18 -0500
Date: Tue, 2 Feb 2010 13:11:16 +0100
From: Andreas Mohr <andi@lisas.de>
To: Oliver Neukum <oliver@neukum.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>, linux-usb@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Sebastian Siewior <bigeasy@linutronix.de>, Greg KH <greg@kroah.com>
Subject: Re: USB mass storage and ARM cache coherency
Message-ID: <20100202121116.GA24926@rhlx01.hs-esslingen.de>
References: <20100129185434.GH19501@one-eyed-alien.net> <201002021248.10994.oliver@neukum.org> <1265112072.12634.53.camel@pc1117.cambridge.arm.com> <201002021307.56991.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201002021307.56991.oliver@neukum.org>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Feb 02, 2010 at 01:07:56PM +0100, Oliver Neukum wrote:
> Am Dienstag, 2. Februar 2010 13:01:12 schrieb Catalin Marinas:
> > On Tue, 2010-02-02 at 11:48 +0000, Oliver Neukum wrote:
> > > Am Montag, 1. Februar 2010 18:29:14 schrieb Catalin Marinas:
> > > Is it correct to limit this to BULK pipes?
> > 
> > I'm not entirely sure. The flush_dcache_page() should only be called for
> > pages that may be mapped into user space (page cache pages). We don't
> > need this for control buffers. It was my impression that what's coming
> > from the mass storage layer intended for page cache pages has the
> > PIPE_BULK type (I may be wrong though).
> 
> For storage that is correct. But what about other sources of pages,
> for example iSCSI?

Or... usb-audio? I should have verified that it is using bulk endpoints
(and thus the patch applies to my case).
usb-audio probably uses isochronous transfers, thus that would be
an obvious reason why the patch didn't work for me.
(with some other reason possibly being BCM4710 issues, of course)

Andreas Mohr
