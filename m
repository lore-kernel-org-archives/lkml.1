Return-Path: <linux-kernel-owner+w=401wt.eu-S934418AbYEULJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934418AbYEULJy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 07:09:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933879AbYEULJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 07:09:32 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35025 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933915AbYEULJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 07:09:30 -0400
Date: Wed, 21 May 2008 12:09:27 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Al Viro <viro@ftp.linux.org.uk>, torvalds@linux-foundation.org,
       geert@linux-m68k.org, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] provide out-of-line strcat() for m68k
Message-ID: <20080521110927.GO28946@ZenIV.linux.org.uk>
References: <E1JycsB-0000M9-36@ZenIV.linux.org.uk> <Pine.LNX.4.64.0805210531170.18184@localhost.localdomain> <20080521053012.GL28946@ZenIV.linux.org.uk> <Pine.LNX.4.64.0805211250180.19545@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805211250180.19545@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 12:53:34PM +0200, Roman Zippel wrote:
> Hi,
> 
> On Wed, 21 May 2008, Al Viro wrote:
> 
> > > It actually was strlen that was generated and not strcat.
> > 
> > Here it replaced strncat() with call of strcat() (gcc 4.0.1, FWIW).
> > And yes, I can show you init/main.s with
> > 	jbsr strcat	|
> > in it generated on kernel in b0rken range...
> 
> Please use a more recent compiler, 4.0 created too many problems on m68k, 
> which we only got under control with 4.1, so at least on m68k 4.0 is not 
> really supported.

Then it's worth mentioning in Documentation/Changes, IMO...  Anyway,
updating m68k toolchain is not a problem; I'll get around to it tonight.
I still think that out-of-line implementation is a good idea, if nothing
else it would prevent future crap of the same kind if some later version
decides that strlen(a) + strlen(b) can be proven to be less than size
argument of strncat(), etc.

Technically we _are_ in nasal daemon country with redefining str*, unless
we pass -ffreestanding; m68k doesn't, so we can't guarantee that new stuff
of that kind won't crop up.  IOW, it might be a good policy to have fallback
implementations of potentially affected primitives...
