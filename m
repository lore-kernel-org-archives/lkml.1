Return-Path: <linux-kernel-owner+w=401wt.eu-S1753519AbXIPSIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519AbXIPSIS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 14:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbXIPSIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 14:08:10 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:38124 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526AbXIPSIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 14:08:09 -0400
Date: Sun, 16 Sep 2007 20:09:30 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Matej Laitl <strohel@gmail.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] menuconfig: distinguish between selected-by-another options and comments
Message-ID: <20070916180930.GA9455@uranus.ravnborg.org>
References: <200709152004.11930.strohel@gmail.com> <20070916111708.GA7362@uranus.ravnborg.org> <Pine.LNX.4.64.0709161908050.1817@scrub.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709161908050.1817@scrub.home>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 16, 2007 at 07:10:06PM +0200, Roman Zippel wrote:
> Hi,
> 
> On Sun, 16 Sep 2007, Sam Ravnborg wrote:
> 
> > But can you take a look at distingushing between non-selectable options
> > due to dependency issues and seleted-by symbols.
> 
> Do you have an example in mind? If a symbol is not changable, but still 
> visible, a select is usually involved.

On i86_64 (but I think the arch does not matter).
make defconfig
make menuconfig

At top-level menu I see:
--- Enable the block layer  --->

In block/Kconfig we have:
menuconfig BLOCK
       bool "Enable the block layer" if EMBEDDED
       default y

If EMBEDDED == n then we see the above.
And this was my first experience with this patch - and it
took me some thoughts to realise it was the "if EMBEDDED" part
that made it look like -*-

So maybe not something we see in many places but it is
there in the top-level menu.

	Sam
