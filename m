Return-Path: <linux-kernel-owner+w=401wt.eu-S1762684AbXKIPEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762684AbXKIPEq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 10:04:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760279AbXKIPEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 10:04:37 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:44991 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760067AbXKIPEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 10:04:36 -0500
Date: Fri, 9 Nov 2007 07:02:30 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Mark Lord <liml@rtr.ca>, Riki Oktarianto <rkoktarianto@gmail.com>,
       linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH] Add quirk to set AHCI mode on ICH boards
Message-ID: <20071109070230.73eb7be5@laptopd505.fenrus.org>
In-Reply-To: <20071109045748.GD25581@havoc.gtf.org>
References: <20071109020235.GA2031@ceren>
	<20071109023129.GA25581@havoc.gtf.org>
	<4733D421.7000505@rtr.ca>
	<20071109034622.GB25581@havoc.gtf.org>
	<4733E5A6.30808@rtr.ca>
	<20071109045748.GD25581@havoc.gtf.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Nov 2007 23:57:48 -0500
Jeff Garzik <jeff@garzik.org> wrote:

> On Thu, Nov 08, 2007 at 11:44:22PM -0500, Mark Lord wrote:
> > Jeff Garzik wrote:
> > >On Thu, Nov 08, 2007 at 10:29:37PM -0500, Mark Lord wrote:
> > >>And I might even privately patch my own kernels to map the ACHI
> > >>BAR in the cases where the BIOS didn't...
> > >
> > >The inability to do this in the general case is the main reason why
> > >AHCI was not unconditionally enabled, even in IDE mode, when it was
> > >originally added...  :/
> > ..
> > 
> > Yeah, that one's always puzzled me.
> > It's just software,  so why don't we do it?  In the PCI layer, that
> > is?
> 
> Ah, but it's not just software:  when trying to find bus address
> space for the BAR, we don't know if we are stomping on magic hardware
> resources the BIOS has conveniently failed to tell us about.
> 
> So while in all likelihood you will have no problem finding a
> suitable bus address to use, as a generalized rule it is a far more
> difficult proposition.
> 

another thing to test before doing this everywhere is suspend/resume.
This would use the hardware in a way the bios doesn't expect, and sadly
that kind of thing tends to royally b0rk the suspend/resume code often
(but of course not always).


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
