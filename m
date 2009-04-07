Return-Path: <linux-kernel-owner+w=401wt.eu-S1757798AbZDGQ75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757798AbZDGQ75 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 12:59:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753709AbZDGQ7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 12:59:40 -0400
Received: from www.tglx.de ([62.245.132.106]:37038 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753369AbZDGQ7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 12:59:39 -0400
Date: Tue, 7 Apr 2009 18:58:50 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Will Schmidt <will_schmidt@vnet.ibm.com>
Subject: Re: [Announce] 2.6.29.1-rt4
In-Reply-To: <1239123123.12637.9.camel@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0904071854480.21577@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>  <alpine.LFD.2.00.0902122353050.16972@localhost.localdomain>  <alpine.LFD.2.00.0902231854360.3523@localhost.localdomain>  <alpine.LFD.2.00.0902241849230.3523@localhost.localdomain> 
 <alpine.LFD.2.00.0902241856480.9135@localhost.localdomain>  <alpine.LFD.2.00.0903122013230.29264@localhost.localdomain>  <alpine.LFD.2.00.0903200014320.29264@localhost.localdomain>  <alpine.LFD.2.00.0903201832590.29264@localhost.localdomain> 
 <alpine.LFD.2.00.0903231723090.29264@localhost.localdomain>  <alpine.LFD.2.00.0903252154040.3397@localhost.localdomain>  <alpine.LFD.2.00.0904020155320.12916@localhost.localdomain>  <alpine.LFD.2.00.0904031918090.12916@localhost.localdomain> 
 <1238799852.3871.6.camel@localhost.localdomain>  <alpine.LFD.2.00.0904040628310.12916@localhost.localdomain>  <1238828273.15225.17.camel@localhost.localdomain>  <alpine.LFD.2.00.0904051552320.747@localhost.localdomain>  <1238968196.4995.15.camel@localhost.localdomain>
  <alpine.LFD.2.00.0904060001480.747@localhost.localdomain>  <1238973052.4995.29.camel@localhost.localdomain>  <alpine.LFD.2.00.0904062151020.21577@localhost.localdomain> <1239123123.12637.9.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fernando,

On Tue, 7 Apr 2009, Fernando Lopez-Lezcano wrote:

> On Mon, 2009-04-06 at 21:54 +0200, Thomas Gleixner wrote:
> > Fernando,
> > 
> > On Sun, 5 Apr 2009, Fernando Lopez-Lezcano wrote:
> > > > Hmm. Can you upload your full patch queue and the binary rpm so I can
> > > > give it a test ride ?
> > > 
> > > Sure, no problem. I just did a release to planetcore-testing repo (with
> > > a warning to the planetccrma list), you can find it here:
> > > 
> > > http://ccrma.stanford.edu/planetccrma/mirror/fedora/linux/planetcore/testing/10/i386/repoview/index.html
> > > http://ccrma.stanford.edu/planetccrma/mirror/fedora/linux/planetcore/testing/10/x86_64/repoview/index.html
> > > 
> > > (the one I have tested and hangs is the i386 PAE version)
> > > Source here:
> > > 
> > > http://ccrma.stanford.edu/planetccrma/mirror/fedora/linux/planetcore/testing/10/SRPMS/
> > > 
> > > (if you don't want to figure out the .src.rpm - I would not blame you -
> > > I can give you a list of the patches that were actually applied - of the
> > > ones that are included in the package)
> > 
> > No problem. I know how to distangle those beasts.
> > 
> > Still I have no reproducer yet. One of my 32bit test machines survived
> > a 200 cycle test w/o showing it.
> 
> Arghh, I don't know what it could be then. You mean 200 power cycles??
> Wow... it only takes one here. Thanks for testing. 

Does it trigger when you just boot up and the immediately shut down
w/o doing any work on it ?

Could you try whether the following triggers the bug as well: Boot up,
do work or whatever. Make sure your data is sycned to disk. :)

# echo 0 >/sys/devices/system/cpu/cpu1/online

If that does not trigger, then check whether it survives the
shutdown/reboot. If it does we look further.
 
> > Is there anything special what you run, load ... ?
> 
> Not that I can think of right now. This happens on 32 bit installs on
> both Fedora 9 and Fedora 10. Nothing special installed, of course I have
> the Planet CCRMA packages but they don't involve additional kernel
> modules or anything that (I think) deals with startup or shutdown. 

Can you provide the list of modules loaded ?

Thanks,

	tglx
