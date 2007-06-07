Return-Path: <linux-kernel-owner+w=401wt.eu-S937508AbXFGXV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937508AbXFGXV5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 19:21:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933332AbXFGXVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 19:21:48 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:56737 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933605AbXFGXVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 19:21:47 -0400
Date: Fri, 8 Jun 2007 01:21:52 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, jcm@jonmasters.org
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Jesper Juhl <jesper.juhl@gmail.com>, Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@osdl.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.03
Message-ID: <20070607232152.GU5500@stusta.de>
References: <0a25fd03117c678f17006c5fcefaaed0@pinky> <9a8748490706060205y1fc8e354p4af7426fd76dd816@mail.gmail.com> <Pine.LNX.4.64.0706071622280.8762@fbirervta.pbzchgretzou.qr> <20070607193413.GR5500@stusta.de> <20070607232248.332edee8@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070607232248.332edee8@the-village.bc.nu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2007 at 11:22:48PM +0100, Alan Cox wrote:
> On Thu, 7 Jun 2007 21:34:13 +0200
> Adrian Bunk <bunk@stusta.de> wrote:
> 
> > On Thu, Jun 07, 2007 at 04:28:20PM +0200, Jan Engelhardt wrote:
> > > 
> > > On Jun 6 2007 11:05, Jesper Juhl wrote:
> > > >
> > > > - Source files should be 7bit ASCII
> > > 
> > > Nah. Think of....
> > > 
> > > MODULE_AUTHOR("J. Ørsted <jorsted@foobar.com>");
> > >...
> > 
> > NO!
> > 
> > Code must be 7bit ASCII.
> > This includes everything that gets into the kernel image.
> 
> Disagree Adrian
> 
> For quoted strings you want to include Unicode where appropriate, and the
> names of people happens to be highly appropriate. Trashing non US names
> is just rude, and in many cases extremely problematic because losing
> accent marks totally changes the meaning of the word and the
> pronunciation of the name.
> 
> Now anyone who puts UTF-8 in the driver name or module options should get
> a lot of NAKs but putting it in the Author name is precisely where it is
> appropriate and correct. I suspect Author names are almost the only case
> where this is appropriate and/or neccessary.

I added a MODULE_AUTHOR("J. Ørsted <jorsted@foobar.com>") into the "raw" 
module:

# echo $LANG
C
# modinfo --version
module-init-tools version 3.3-pre11
# modinfo raw
filename:       /lib/modules/2.6.21.2/kernel/drivers/char/raw.ko
author:         J. Ã
                    ^ the cursor hangs here


So for implementing your proposal, we have to:
- get module-init-tools fixed and
- document that 2.6.23 (or whichever will be the first kernel to support 
  UTF-8 in MODULE_AUTHOR) will require updated module-init-tools.


Oh, and when you are anyway planning to break older userspace, can you 
remove the obsolete "raw" driver at the same time?  ;-)


> Alan

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

