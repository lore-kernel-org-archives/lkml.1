Return-Path: <linux-kernel-owner+w=401wt.eu-S1422683AbXBURAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422683AbXBURAh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 12:00:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422690AbXBURAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 12:00:37 -0500
Received: from ftp.linux-mips.org ([194.74.144.162]:41981 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422683AbXBURAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 12:00:37 -0500
Date: Wed, 21 Feb 2007 17:00:32 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Alan <alan@lxorguk.ukuu.org.uk>
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 2.6.21-rc1] serial: serial_txx9 driver update
Message-ID: <20070221170032.GA3036@linux-mips.org>
References: <20070222.003142.106263613.anemo@mba.ocn.ne.jp> <20070221164826.61d0b5ea@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070221164826.61d0b5ea@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 21, 2007 at 04:48:26PM +0000, Alan wrote:

> Given this costs 1uS in a path that is not performance critical is it
> worth putting the #ifdef/#endif in instead of having one set of code that
> works for all ?
> 
> > +	while (sio_in(up, TXX9_SIFCR) & TXX9_SIFCR_SWRST)
> > +		;
> 
> Suppose it doesn't clear ? Should also use cpu_relax() in busy loops
> so any processor variant with power management can do the right thing.

Right now we don't have much that we could do in cpu_relax() on MIPS.
The average CPU core makes extensive use of clock gating to the point
where there are few powersaving knobs left in the core.  Of course I'm
also ignoring things outside the CPU core and clockscaling for which
cpu_relax() would simply be the wrong place.

Of course this driver in rare instances might run on an x86 CPU ...

  Ralf
