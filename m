Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507Ab0BBPe6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 10:34:58 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:55577 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756409Ab0BBPey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 10:34:54 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andreas Mohr <andi@lisas.de>
Cc: Oliver Neukum <oliver@neukum.org>, Clemens Ladisch <clemens@ladisch.de>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>, linux-usb@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Sebastian Siewior <bigeasy@linutronix.de>, Greg KH <greg@kroah.com>,
       Luke -Jr <luke@dashjr.org>
In-Reply-To: <20100202151006.GA3449@rhlx01.hs-esslingen.de>
References: <20100129185434.GH19501@one-eyed-alien.net>
	 <20100202121116.GA24926@rhlx01.hs-esslingen.de>
	 <4B6839E9.1040407@ladisch.de> <201002021552.19286.oliver@neukum.org>
	 <20100202151006.GA3449@rhlx01.hs-esslingen.de>
Content-Type: text/plain
Organization: ARM Ltd
Date: Tue, 02 Feb 2010 15:34:27 +0000
Message-Id: <1265124867.12634.86.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Feb 2010 15:34:28.0623 (UTC) FILETIME=[3526E9F0:01CAA41D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-02 at 15:10 +0000, Andreas Mohr wrote:
> [added another __bzero coherency crash victim, see
> http://lkml.org/lkml/2008/6/9/14 ]
> 
> On Tue, Feb 02, 2010 at 03:52:19PM +0100, Oliver Neukum wrote:
> > Am Dienstag, 2. Februar 2010 15:42:49 schrieb Clemens Ladisch:
> > > > Or... usb-audio? I should have verified that it is using bulk endpoints
> > > > (and thus the patch applies to my case).
> > > > usb-audio probably uses isochronous transfers, thus that would be
> > > > an obvious reason why the patch didn't work for me.
> > >
> > > snd-usb-audio indeed uses isochronous transfers, but those buffers are
> > > never mapped into user space.  The intermediate vmalloc()ed buffer is,
> > > however, and there was a bugfix for this recently.  Do you have these
> > > patches in your tree?
> >
> > Now that I think about it, several video drivers do map it to user space.
> 
> OK, then the urb loop needs to also handle isochronous pipes,
> and IMHO we should have a generic helper for this instead of open-coding
> it, since it probably needs to be done in a couple affected HCDs
> (and, most importantly, only on affected architectures - which the helper
> could handle transparently).

I'm planning to send a proposal to linux-arch for a flush_dcache_range()
function.

-- 
Catalin

