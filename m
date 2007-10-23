Return-Path: <linux-kernel-owner+w=401wt.eu-S1753771AbXJWFRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771AbXJWFRW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 01:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751792AbXJWFRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 01:17:14 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:48286 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752047AbXJWFRN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 01:17:13 -0400
Date: Mon, 22 Oct 2007 22:16:42 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: James Morris <jmorris@namei.org>, Jan Engelhardt <jengelh@computergmbh.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: LSM conversion to static interface [revert patch]
Message-ID: <20071023051642.GA3908@sequoia.sous-sol.org>
References: <167451.96128.qm@web38607.mail.mud.yahoo.com> <alpine.LFD.0.999.0710171913270.26902@woody.linux-foundation.org> <200710192226.53233.agruen@suse.de> <alpine.LFD.0.999.0710191336250.26902@woody.linux-foundation.org> <Pine.LNX.4.64.0710201255170.1997@fbirervta.pbzchgretzou.qr> <Xine.LNX.4.64.0710210842540.551@us.intercode.com.au> <20071022210956.31f7bbcf@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071022210956.31f7bbcf@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Arjan van de Ven (arjan@infradead.org) wrote:
> On Sun, 21 Oct 2007 08:57:06 +1000 (EST)
> James Morris <jmorris@namei.org> wrote:
> 
> > On Sat, 20 Oct 2007, Jan Engelhardt wrote:
> > 
> > > >I'd like to note that I asked people who were actually affected,
> > > >and had examples of their real-world use to step forward and
> > > >explain their use, and that I explicitly mentioned that this is
> > > >something we can easily re-visit.
> > > >
> > > 
> > > I do have a pseudo LSM called "multiadm" at 
> > > http://freshmeat.net/p/multiadm/ , quoting:
> > > 
> > 
> > Based on Linus' criteria, this appears to be a case for reverting the 
> > static LSM patch.
> 
> I don't want to argue for or against the actual revert; however if Linus/James/Chris
> decide to do a revert, I've made a patch to do that below

Thanks Arjan.  I did not actually oppose making it non-modular, and
thought there was sufficient time for people to complain meaningfully
on that change.  I also think there's not a lot of value in the modular
interface, but it's very difficult to have rational discussions in this
area.

> (doing a full git revert is tricky since it gets mixed up with various other cleanup 
> patches; even inside the original patch. I've done the relevant pieces by hand via a 
> selective patch -R and compile-tested it). In addition I've made the modularity a 
> Kconfig option, since it's clearly something that is contested and thus is justified 
> as a user compile time choice; people who don't want this (out of paranoia or otherwise)
> can now decide to disable, while others who want to experiment or use out of tree 
> LSM modules, can select the KConfig option.
> 
> If it turns out that the above module becomes unmaintained and no longer usable, and no
> other useful cases show up, we can always garbage collect this code in the future; it's 
> now low-overhead anyway for those who care, due to the KConfig option.

Yes, and I think we can still improve performance although I can't see
anyway to help out the modular case, so I guess it will have to incur
the hit that's always been there.  I think your Kconfig option is a
decent compromise.

thanks,
-chris
