Return-Path: <linux-kernel-owner+w=401wt.eu-S1758317AbZCAU40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758317AbZCAU40 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 15:56:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754455AbZCAU4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 15:56:17 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:11175 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489AbZCAU4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 15:56:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sNp/rCQgkIntAvehvLgueEXmFywe7t3qr8tV48xY0QtDUmtmipo5A+/wJQ8oTs8ez9
         9POTZRvf4C9KIQdOrYck2nLzBykXCB7pWQaVLNLhOhVt7qN5IzRiAavXWzXlvtJu0A3J
         ZFtHi7gNolMXAxUhku9IhrElicC53Txm9hJHQ=
Date: Mon, 2 Mar 2009 00:02:58 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, torvalds@osdl.org
Subject: Re: No more Intel HDA soundcard
Message-ID: <20090301210258.GA7368@x200.localdomain>
References: <20090228184412.GA2333@x200.localdomain> <s5hwsb9r29o.wl%tiwai@suse.de> <20090301104138.GA2341@x200.localdomain> <s5hprh1m1mf.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hprh1m1mf.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 01, 2009 at 09:25:44PM +0100, Takashi Iwai wrote:
> At Sun, 1 Mar 2009 13:41:38 +0300,
> Alexey Dobriyan wrote:
> > 
> > On Sun, Mar 01, 2009 at 11:00:35AM +0100, Takashi Iwai wrote:
> > > At Sat, 28 Feb 2009 21:44:12 +0300,
> > > Alexey Dobriyan wrote:
> > > > 
> > > > The following commit results in soundcard detection failing with -EBUSY
> > > > 
> > > > commit 34c25350acfc792747e861d1e36874abf7e73255
> > > > Author: Takashi Iwai <tiwai@suse.de>
> > > > Date:   Tue Oct 28 11:38:58 2008 +0100
> > > > 
> > > >     ALSA: hda - Remove old codec-probe limitation
> > > >     
> > > >     Removed the old workaround to avoid the non-existing codec slot.
> > > >     The current code should work without that workaround.  If any,
> > > >     we can add a quirk table.
> > > >     
> > > >     Signed-off-by: Takashi Iwai <tiwai@suse.de>
> > > > 
> > > > I fixed up this (and got sound back) but suspect the following is not right.
> > > > 
> > > > --- a/sound/pci/hda/hda_intel.c
> > > > +++ b/sound/pci/hda/hda_intel.c
> > > > @@ -1224,6 +1224,7 @@ static void azx_stop_chip(struct azx *chip);
> > > >  
> > > >  /* number of codec slots for each chipset: 0 = default slots (i.e. 4) */
> > > >  static unsigned int azx_max_codecs[AZX_NUM_DRIVERS] __devinitdata = {
> > > > +	[AZX_DRIVER_ICH] = 3,
> > > >  	[AZX_DRIVER_TERA] = 1,
> > > >  };
> > > 
> > > Right, it's no good solution as you expected ;)
> > > The problem is that your patch will disable the all HDMI devices that are
> > > newly supported on 2.6.29.
> > > 
> > > Is your machine Toshiba X200, found in bug 12735 ??
> > > 	http://bugzilla.kernel.org/show_bug.cgi?id=12735
> > > 
> > > If yes, could you try the patch below?
> > > 
> > > Also, it'd be helpful if you can try sound git tree (master branch):
> > >     git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6.git
> > > that contains the very latest driver.  This should work as is.
> > 
> > Sound works as is, alsamixer refuses to start with
> 
> Is this the result of what?
> 
> Could you check whether the patch for 2.6.29 works at first?

Patch works fine.

> Then, try sound git tree (without the patch), and give alsa-info output
> after probe_only=1 option.

With git tree, sound works, alsamixer refuses to start.
