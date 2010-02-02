Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab0BBOsL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 09:48:11 -0500
Received: from smtprelay02.ispgateway.de ([80.67.31.29]:36122 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab0BBOsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 09:48:07 -0500
X-Greylist: delayed 310 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Feb 2010 09:48:07 EST
Message-ID: <4B6839E9.1040407@ladisch.de>
Date: Tue, 02 Feb 2010 15:42:49 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Andreas Mohr <andi@lisas.de>
CC: Oliver Neukum <oliver@neukum.org>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>, linux-usb@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Sebastian Siewior <bigeasy@linutronix.de>, Greg KH <greg@kroah.com>
Subject: Re: USB mass storage and ARM cache coherency
References: <20100129185434.GH19501@one-eyed-alien.net> <201002021248.10994.oliver@neukum.org> <1265112072.12634.53.camel@pc1117.cambridge.arm.com> <201002021307.56991.oliver@neukum.org> <20100202121116.GA24926@rhlx01.hs-esslingen.de>
In-Reply-To: <20100202121116.GA24926@rhlx01.hs-esslingen.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-usb@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Mohr wrote:
> On Tue, Feb 02, 2010 at 01:07:56PM +0100, Oliver Neukum wrote:
> > Am Dienstag, 2. Februar 2010 13:01:12 schrieb Catalin Marinas:
> > > On Tue, 2010-02-02 at 11:48 +0000, Oliver Neukum wrote:
> > > > Am Montag, 1. Februar 2010 18:29:14 schrieb Catalin Marinas:
> > > > Is it correct to limit this to BULK pipes?
> > > 
> > > I'm not entirely sure. The flush_dcache_page() should only be called for
> > > pages that may be mapped into user space (page cache pages). We don't
> > > need this for control buffers. It was my impression that what's coming
> > > from the mass storage layer intended for page cache pages has the
> > > PIPE_BULK type (I may be wrong though).
> > 
> > For storage that is correct. But what about other sources of pages,
> > for example iSCSI?
> 
> Or... usb-audio? I should have verified that it is using bulk endpoints
> (and thus the patch applies to my case).
> usb-audio probably uses isochronous transfers, thus that would be
> an obvious reason why the patch didn't work for me.

snd-usb-audio indeed uses isochronous transfers, but those buffers are
never mapped into user space.  The intermediate vmalloc()ed buffer is,
however, and there was a bugfix for this recently.  Do you have these
patches in your tree?
http://git.kernel.org/?p=linux/kernel/git/tiwai/sound-2.6.git;a=commit;h=3e879d7bac705be4813a0ec9560cbe31db4b269f
http://git.kernel.org/?p=linux/kernel/git/tiwai/sound-2.6.git;a=commit;h=c32d977b8157bf67cdf47729ce7dd054a26eb534


Best regards,
Clemens
