Return-Path: <linux-kernel-owner+w=401wt.eu-S1753952AbYG3RwF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbYG3RwF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 13:52:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754936AbYG3Rvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 13:51:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38044 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754373AbYG3Rvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 13:51:42 -0400
Date: Wed, 30 Jul 2008 19:51:38 +0200
From: Karsten Keil <kkeil@suse.de>
To: David Woodhouse <dwmw2@infradead.org>
Cc: isdn4linux@listserv.isdn4linux.de, Marcel Holtmann <marcel@holtmann.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mISDN cleanup user interface
Message-ID: <20080730175138.GA12800@pingi.kke.suse.de>
References: <20080729195637.GB25929@pingi.kke.suse.de> <1217362946.27925.137.camel@pmac.infradead.org> <1217365330.417.8.camel@californication> <1217409211.27925.177.camel@pmac.infradead.org> <20080730163314.GB9491@pingi.kke.suse.de> <1217437021.3454.8.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217437021.3454.8.camel@pmac.infradead.org>
Organization: SuSE Linux AG
X-Operating-System: Linux 2.6.16.54-0.2.5-smp x86_64
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2008 at 05:57:01PM +0100, David Woodhouse wrote:
> On Wed, 2008-07-30 at 18:33 +0200, Karsten Keil wrote:
> > What about this implementation ?
> 
> Looks a lot saner... although it does seem to confirm my earlier
> suspicion that you're not even _using_ the fact that it's a bitmap at
> all. You set the bits for the present channels at init time, which are
> always contiguous, and you never seem to change them them later -- why
> couldn't you do this with a simple 'number of channels' integer?

No it is not contineous on different PRI line setups (E1,T1 ...)
e.g a E1 has the D-channel on channel 15 position, so this bit is not set
then. My idea was, that with such a bitmap, applictions do not need to know
anything about the different channel layouts, it can use the map as base to assign
or validate a channel numbers.

> 
> Are you later intending to use the bitmap to mark them as busy/free?
> 

Yes exactely, and this was the reason why the original code (which used one u_long
only as channelmap) already used the bit operators, since for a channel allocator
you should be atomic, but since we are now allow 127 channels we need proper
locking for the busy/free map anyways and so we do not need atomic operation
here.

-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
