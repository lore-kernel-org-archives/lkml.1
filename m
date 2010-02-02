Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614Ab0BBPKM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 10:10:12 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:51958 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560Ab0BBPKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 10:10:09 -0500
Date: Tue, 2 Feb 2010 16:10:06 +0100
From: Andreas Mohr <andi@lisas.de>
To: Oliver Neukum <oliver@neukum.org>
Cc: Clemens Ladisch <clemens@ladisch.de>, Andreas Mohr <andi@lisas.de>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>, linux-usb@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Sebastian Siewior <bigeasy@linutronix.de>, Greg KH <greg@kroah.com>,
       Luke -Jr <luke@dashjr.org>
Subject: Re: USB mass storage and ARM cache coherency
Message-ID: <20100202151006.GA3449@rhlx01.hs-esslingen.de>
References: <20100129185434.GH19501@one-eyed-alien.net> <20100202121116.GA24926@rhlx01.hs-esslingen.de> <4B6839E9.1040407@ladisch.de> <201002021552.19286.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201002021552.19286.oliver@neukum.org>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[added another __bzero coherency crash victim, see
http://lkml.org/lkml/2008/6/9/14 ]

On Tue, Feb 02, 2010 at 03:52:19PM +0100, Oliver Neukum wrote:
> Am Dienstag, 2. Februar 2010 15:42:49 schrieb Clemens Ladisch:
> > > Or... usb-audio? I should have verified that it is using bulk endpoints
> > > (and thus the patch applies to my case).
> > > usb-audio probably uses isochronous transfers, thus that would be
> > > an obvious reason why the patch didn't work for me.
> > 
> > snd-usb-audio indeed uses isochronous transfers, but those buffers are
> > never mapped into user space.  The intermediate vmalloc()ed buffer is,
> > however, and there was a bugfix for this recently.  Do you have these
> > patches in your tree?
> 
> Now that I think about it, several video drivers do map it to user space.

OK, then the urb loop needs to also handle isochronous pipes,
and IMHO we should have a generic helper for this instead of open-coding
it, since it probably needs to be done in a couple affected HCDs
(and, most importantly, only on affected architectures - which the helper
could handle transparently).

Clemens: no, both of these patches haven't been applied (yet!!),
many thanks for the notification!

Will apply both patches and the isochronous addition, hopefully that
improves things (will be painful to check which of these things managed to
fix it - in case it does! -, though). Nope, will apply step by step,
both patches, then isochronous as a last resort.

Andreas Mohr
