Return-Path: <linux-kernel-owner+w=401wt.eu-S1753999AbYIBQQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999AbYIBQQZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 12:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751248AbYIBQQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 12:16:17 -0400
Received: from iabervon.org ([66.92.72.58]:48418 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061AbYIBQQQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 12:16:16 -0400
Date: Tue, 2 Sep 2008 12:16:15 -0400 (EDT)
From: Daniel Barkalow <barkalow@iabervon.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
       Christopher Desjardins <cddesjardins@gmail.com>
Subject: Re: Lenovo 3000 N100 i8042 problems
In-Reply-To: <20080902083940.ZZRA012@mailhub.coreip.homeip.net>
Message-ID: <alpine.LNX.1.00.0809021200470.19665@iabervon.org>
References: <alpine.LNX.1.00.0808240148580.19665@iabervon.org> <Pine.LNX.4.64.0809020120130.29111@twin.jikos.cz> <alpine.LNX.1.00.0809012014280.19665@iabervon.org> <alpine.LNX.1.10.0809021121410.23448@jikos.suse.cz>
 <20080902083940.ZZRA012@mailhub.coreip.homeip.net>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Sep 2008, Dmitry Torokhov wrote:

> On Tue, Sep 02, 2008 at 11:23:25AM +0200, Jiri Kosina wrote:
> > 
> > so the product name both of System and Base Board are different, and 
> > apparently the systems differ. Dmitry, what fields would you propose to be 
> > put in the DMI matching here? I will do the patch then.
> > 
> 
> I guess we could use System's product name to differentiate between
> Cristopher's and Daniel's boards. Although I must admit it is the very
> first time when I see a box that behaves better with active mux. DOes
> Vista use active mux nowadays? Because if it is not then I bet there
> is (or shortly will be) a BIOS update fixing legacy mode on Daniel's
> box.

Mine's actually old (came with XP). It's still got the original BIOS 
(because I haven't found a way to upgrade the BIOS without reformatting my 
hard drive to include Windows), and I remember there being an upgrade 
available, but I don't think it had anything to do with keyboard/trackpad 
stuff.

In what way does active mux usually behave badly? It's possible that 
legacy mode only has a bug that doesn't matter to Windows, and active mux 
may have some of the usual problems but nothing I particularly noticed.

I noticed that, when my i8042 would stop working, it would generally have 
just delivered one mouse interrupt to CPU1 after never previously doing 
so. Perhaps there's some sort of deadlock in the Linux i8042 driver when 
both cores are unexpectedly getting interrupts from the two devices at 
once? I could understand there being a Linux bug only triggered by quirky 
hardware that only applies to legacy mode, which was just uncovered by 
this patch.

	-Daniel
*This .sig left intentionally blank*
