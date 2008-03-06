Return-Path: <linux-kernel-owner+w=401wt.eu-S934482AbYCFOGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934482AbYCFOGc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 09:06:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759439AbYCFOGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 09:06:23 -0500
Received: from dspnet.fr.eu.org ([213.186.44.138]:2649 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756107AbYCFOGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 09:06:22 -0500
Date: Thu, 6 Mar 2008 15:06:20 +0100
From: Olivier Galibert <galibert@pobox.com>
To: David Daney <ddaney@avtrex.com>
Cc: Michael Matz <matz@suse.de>, Joe Buck <Joe.Buck@synopsys.COM>,
       Jan Hubicka <hubicka@ucw.cz>, Aurelien Jarno <aurelien@aurel32.net>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       gcc@gcc.gnu.org
Subject: Re: RELEASE BLOCKER: Linux doesn't follow x86/x86-64 ABI wrt direction   flag
Message-ID: <20080306140620.GB5236@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	David Daney <ddaney@avtrex.com>, Michael Matz <matz@suse.de>,
	Joe Buck <Joe.Buck@synopsys.COM>, Jan Hubicka <hubicka@ucw.cz>,
	Aurelien Jarno <aurelien@aurel32.net>,
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
	gcc@gcc.gnu.org
References: <20080305195834.GA17267@synopsys.com> <20080305202319.GA17053@volta.aurel32.net> <Pine.LNX.4.64.0803052133400.20583@wotan.suse.de> <20080305204234.GB17267@synopsys.com> <20080305204945.GB14011@atrey.karlin.mff.cuni.cz> <Pine.LNX.4.64.0803052158270.20583@wotan.suse.de> <20080305212005.GC17267@synopsys.com> <Pine.LNX.4.64.0803052241170.20583@wotan.suse.de> <20080305231712.GC2649@dspnet.fr.eu.org> <47CF2B07.2050503@avtrex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47CF2B07.2050503@avtrex.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2008 at 03:21:43PM -0800, David Daney wrote:
> Olivier Galibert wrote:
> >On Wed, Mar 05, 2008 at 10:43:33PM +0100, Michael Matz wrote:
> >>FWIW I don't think it's a release blocker for 4.3.0.  The error is arcane 
> >>and happens seldomly if at all.  And only on unfixed kernels.  A program 
> >>needs to do std explicitely, which most don't do _and_ get hit by a 
> >>signal while begin in a std region.  This happens so seldom that it 
> >>didn't occur in building the next openSuSE 11.0, and it continually 
> >>builds packages with 4.3 since months.
> >
> >How would you know whether it has happened?
> >
> 
> The same way you do with other bugs: You would observe unexpected behavior.
>
> In this case probably either corrupted memory or a SIGSEGV.

So that probably means the programs you use for compiling packages
probably aren't hit.  Doesn't mean the packages you've compiled with
it aren't hit.  Compiling packages doesn't test what's in them at all.

It's extremely rare, no doubt about it.  It's just that it *yells*
security issue in the making.  It's not a source bug, i.e. not easily
reviewable.  It's related to signal handlers which are the mark of a
server and/or more failure-conscious program than usual.  It's obscure
(breaking a stringop, probably memset, or a not-paranoid-enough inline
asm in a signal handler through a running memmove in the main program,
oh my) but reasonably predictable for someone looking for an
exploitable flaw.

It's gcc's job to adapt to the realities of its running environment,
not the other way around.

  OG.

