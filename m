Return-Path: <linux-kernel-owner+w=401wt.eu-S1757517AbXFLSJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517AbXFLSJH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 14:09:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755379AbXFLSIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 14:08:55 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:59894 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755205AbXFLSIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 14:08:55 -0400
Date: Tue, 12 Jun 2007 20:09:57 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>, kbuild-devel@lists.sourceforge.net
Subject: Re: [patch] kbuild: remember ARCH in the object directory
Message-ID: <20070612180957.GD15329@uranus.ravnborg.org>
References: <200705090951.l499pa6G020397@shell0.pdx.osdl.net> <20070509204613.GA10336@uranus.ravnborg.org> <1178755780.7286.175.camel@localhost.localdomain> <E1HxjKu-0004G6-7d@flower> <20070611125903.GA3933@uranus.ravnborg.org> <E1Hy3fI-0001Tw-Fy@flower> <20070612091209.760b5225.randy.dunlap@oracle.com> <20070612171922.GG7266@flower.upol.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070612171922.GG7266@flower.upol.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2007 at 07:19:22PM +0200, Oleg Verych wrote:
> On Tue, Jun 12, 2007 at 09:12:09AM -0700, Randy Dunlap wrote:
> []
> > I did:
> > 
> > # build a linux-2.6.22-rc4-git4 kernel source tree & cd into it
> > # mkdir BLD
> > $ make ARCH=i386 O=BLD defconfig
> > $ make -j4 O=BLD all >BLD/bld.out 2>&1
> > 
> > and it cried to me:
> > 
> >   GEN     /scsi/linsrc/linux-2.6.22-rc4-git4/BLD/Makefile
> > scripts/kconfig/conf -s arch/x86_64/Kconfig
> > #... many config warning lines
> > *
> > * Restart config...
> > *
> > *
> > * Processor type and features
> > *
> > Subarchitecture Type
> > > 1. PC-compatible (X86_PC)
> >   2. Support for ScaleMP vSMP (X86_VSMP) (NEW)
> > choice[1-2]: aborted!
> > 
> > Console input/output is redirected. Run 'make oldconfig' to update configuration.
> > 
> > make[3]: *** [silentoldconfig] Error 1
> > make[2]: *** [silentoldconfig] Error 2
> > make[1]: *** [include/config/auto.conf] Error 2
> > make: *** [all] Error 2
> > 
> [] 
> 
> > What did I do wrong??
> 
> That Makefile is used only, if you are *in* that obj. directory.
> Thus `cd BLD` is what you've forget.
> 
> There must be a better way to have this kind of choice be saved,
> but it's chicken-and-egg issue from the kconfig POV.
> 
> As i'm always try to use separate obj. dir., i've made life easier
> *in* it.

I fully agree with the intent of the patch.
But it fails exactly because it introduce different behaviour
dependent of actual usage.

For non O= build ARCH is not saved and does not work
For make O= it does not work
For make in the output dir it works
For external modules it does not work

This will greatly confuse people.

If we go the "save important parts of the config" I prefer
something along the suggestion by hpa with a config file.
The config file should though be named along the lines
of Kbuild.config and the syntax should be future proof.
I like the syntax of the .git/config file and
it should be along these lines.

And the bahavior should be exactly the same for all uses
listed above.

	Sam
