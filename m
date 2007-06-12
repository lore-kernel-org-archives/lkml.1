Return-Path: <linux-kernel-owner+w=401wt.eu-S1756934AbXFLRHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934AbXFLRHw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 13:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755077AbXFLRHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 13:07:45 -0400
Received: from raven.upol.cz ([158.194.120.4]:53676 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754828AbXFLRHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 13:07:45 -0400
Date: Tue, 12 Jun 2007 19:19:22 +0200
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>, kbuild-devel@lists.sourceforge.net
Subject: Re: [patch] kbuild: remember ARCH in the object directory
Message-ID: <20070612171922.GG7266@flower.upol.cz>
References: <200705090951.l499pa6G020397@shell0.pdx.osdl.net> <20070509204613.GA10336@uranus.ravnborg.org> <1178755780.7286.175.camel@localhost.localdomain> <E1HxjKu-0004G6-7d@flower> <20070611125903.GA3933@uranus.ravnborg.org> <E1Hy3fI-0001Tw-Fy@flower> <20070612091209.760b5225.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070612091209.760b5225.randy.dunlap@oracle.com>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2007 at 09:12:09AM -0700, Randy Dunlap wrote:
[]
> I did:
> 
> # build a linux-2.6.22-rc4-git4 kernel source tree & cd into it
> # mkdir BLD
> $ make ARCH=i386 O=BLD defconfig
> $ make -j4 O=BLD all >BLD/bld.out 2>&1
> 
> and it cried to me:
> 
>   GEN     /scsi/linsrc/linux-2.6.22-rc4-git4/BLD/Makefile
> scripts/kconfig/conf -s arch/x86_64/Kconfig
> #... many config warning lines
> *
> * Restart config...
> *
> *
> * Processor type and features
> *
> Subarchitecture Type
> > 1. PC-compatible (X86_PC)
>   2. Support for ScaleMP vSMP (X86_VSMP) (NEW)
> choice[1-2]: aborted!
> 
> Console input/output is redirected. Run 'make oldconfig' to update configuration.
> 
> make[3]: *** [silentoldconfig] Error 1
> make[2]: *** [silentoldconfig] Error 2
> make[1]: *** [include/config/auto.conf] Error 2
> make: *** [all] Error 2
> 
[] 

> What did I do wrong??

That Makefile is used only, if you are *in* that obj. directory.
Thus `cd BLD` is what you've forget.

There must be a better way to have this kind of choice be saved,
but it's chicken-and-egg issue from the kconfig POV.

As i'm always try to use separate obj. dir., i've made life easier
*in* it.
____
