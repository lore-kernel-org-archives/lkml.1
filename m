Return-Path: <linux-kernel-owner+w=401wt.eu-S1161024AbXCVLPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161024AbXCVLPa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 07:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161023AbXCVLPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 07:15:30 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:37869 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161024AbXCVLP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 07:15:29 -0400
Date: Thu, 22 Mar 2007 12:15:31 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Sam Ravnborg <sam@ravnborg.org>, David Miller <davem@davemloft.net>,
       randy.dunlap@oracle.com, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org
Subject: Re: BLK_DEV_MD with CONFIG_NET
Message-ID: <20070322111531.GT752@stusta.de>
References: <20070320200538.5270d636.randy.dunlap@oracle.com> <20070320.202621.74740974.davem@davemloft.net> <20070321120246.GB18195@uranus.ravnborg.org> <200703212330.24502.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200703212330.24502.arnd@arndb.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2007 at 11:30:24PM +0100, Arnd Bergmann wrote:
> On Wednesday 21 March 2007 13:02:46 Sam Ravnborg wrote:
> > > Anything which is every exported to modules, which ought to
> > > be the situation in this case, should be obj-y not lib-y
> > > right?
> >
> > That is also my understanding of lib-y - I should update makefiles.txt
> > to reflect this..
> 
> Strictly speaking, it could well be obj-m instead of obj-y if it
> is _only_ used by modules. OTOH, it makes the Makefile a lot simpler
> to not optimize for this case.

No, it is only used by modules only if CONFIG_BLK_DEV_MD=m and CONFIG_NET=n...

And except for some legacy drivers, there shouldn't be any module-only 
code in the kernel.

The solution is either obj-y or obj-$(CONFIG_CSUM_PARIAL).

> 	Arnd

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

