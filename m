Return-Path: <linux-kernel-owner+w=401wt.eu-S1760324AbYCEUuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760324AbYCEUuB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 15:50:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753739AbYCEUtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 15:49:47 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:47642 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759645AbYCEUtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 15:49:46 -0500
Date: Wed, 5 Mar 2008 21:49:45 +0100
From: Jan Hubicka <hubicka@ucw.cz>
To: Joe Buck <Joe.Buck@synopsys.COM>
Cc: Michael Matz <matz@suse.de>, Aurelien Jarno <aurelien@aurel32.net>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       gcc@gcc.gnu.org
Subject: Re: Linux doesn't follow x86/x86-64 ABI wrt direction flag
Message-ID: <20080305204945.GB14011@atrey.karlin.mff.cuni.cz>
References: <20080305153020.GA24631@volta.aurel32.net> <47CEC3AA.6080709@zytor.com> <20080305195834.GA17267@synopsys.com> <20080305202319.GA17053@volta.aurel32.net> <Pine.LNX.4.64.0803052133400.20583@wotan.suse.de> <20080305204234.GB17267@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080305204234.GB17267@synopsys.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Mar 05, 2008 at 09:38:13PM +0100, Michael Matz wrote:
> > Hi,
> > 
> > On Wed, 5 Mar 2008, Aurelien Jarno wrote:
> > 
> > > > So I think gcc at least needs an *option* to revert to the old behavior,
> > > > and there's a good argument to make it the default for now, at least for
> > > > x86/x86-64 on Linux.
> > > 
> > > And for other kernels. I tested OpenBSD 4.1, FreeBSD 6.3, NetBSD 4.0, 
> > > they have the same behaviour as Linux, that is they don't clear DF 
> > > before calling the signal handler.
> > 
> > Sigh.  We could perhaps insert a cld for all functions which can be 
> > recognized as possible signal handlers and call other unknown or string 
> > functions.  But it's probably even faster to emit cld in front of the 
> > inline copies of mem functions again :-(
> 
> Yes, if there are four kernels that get it "wrong", that effectively means
> that the ABI document doesn't describe reality and gcc has to adjust.

Kernels almost never follow ABI used by applications to last detail.
Linux kernel is disabling red zone and use kernel code model, yet the
ABI is not going to be adjusted for that.

This is resonably easy to fix on kernel side in signal handling, or by
removing std usage completely (I believe it is not performance win, but
some benchmarking would be needed to double check)

Honza
