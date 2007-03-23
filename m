Return-Path: <linux-kernel-owner+w=401wt.eu-S1752052AbXCWQ1I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052AbXCWQ1I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 12:27:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752059AbXCWQ1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 12:27:08 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:32840 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752052AbXCWQ1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 12:27:07 -0400
Date: Fri, 23 Mar 2007 17:27:09 +0100
From: Adrian Bunk <bunk@stusta.de>
To: David Brownell <david-b@pacbell.net>,
       linux-usb-devel@lists.sourceforge.net,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       Tino Keitel <tino.keitel@gmx.de>
Subject: Re: [linux-usb-devel] possible USB regression with 2.6.21-rc4: iPod doesn't work
Message-ID: <20070323162709.GK752@stusta.de>
References: <20070322085451.GB10598@dose.home.local> <Pine.LNX.4.44L0.0703221539440.4669-100000@iolanthe.rowland.org> <20070322195448.GA17521@dose.home.local> <200703221429.12029.david-b@pacbell.net> <20070322214653.GA6889@dose.home.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070322214653.GA6889@dose.home.local>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2007 at 10:46:53PM +0100, Tino Keitel wrote:
> On Thu, Mar 22, 2007 at 14:29:11 -0700, David Brownell wrote:
> > On Thursday 22 March 2007 12:54 pm, Tino Keitel wrote:
> > > On Thu, Mar 22, 2007 at 15:40:40 -0400, Alan Stern wrote:
> > > > 	  _Something_ is generating those overcurrent 
> > > > warnings, and it sure looks like a hardware malfunction.
> > > 
> > > But it works with 2.6.20.
> > 
> > So can you bisect to find what caused the problem?
> 
> I never did use git-bisect, but maybe I find the time next week.


Instructions for bisecting:


<--  snip  -->

# install git and cogito on your computer

# clone Linus' tree:
cg-clone \ 
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

# start bisecting:
cd linux-2.6
git bisect start
git bisect bad v2.6.21-rc4
git bisect good v2.6.20

# start round
cp /path/to/.config .
make oldconfig
make
# install kernel, check whether it's good or bad, then:
git bisect [bad|good]
# start next round


After at about 12 reboots, you'll have found the guilty commit
("...  is first bad commit").


More information on git bisecting:
  man git-bisect

<--  snip  -->


> Regards,
> Tino

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

