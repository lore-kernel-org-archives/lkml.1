Return-Path: <linux-kernel-owner+w=401wt.eu-S1756643AbYAOTQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643AbYAOTQb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 14:16:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300AbYAOTQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 14:16:22 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:42495 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077AbYAOTQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 14:16:21 -0500
Date: Tue, 15 Jan 2008 20:16:23 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Adrian Bunk <adrian.bunk@movial.fi>,
       Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, phil.el@wanadoo.fr,
       oprofile-list@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: Fwd: Re: [2.6.24 patch] restore ARMv6 OProfile support
Message-ID: <20080115191623.GA19694@uranus.ravnborg.org>
References: <20071228195841.GA3945@flint.arm.linux.org.uk> <20080115104526.GA32067@flint.arm.linux.org.uk> <alpine.LFD.1.00.0801150811250.2806@woody.linux-foundation.org> <20080115173701.GB8375@Krystal> <alpine.LFD.1.00.0801151051120.2806@woody.linux-foundation.org> <20080115190719.GA12236@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080115190719.GA12236@Krystal>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2008 at 02:07:20PM -0500, Mathieu Desnoyers wrote:
> * Linus Torvalds (torvalds@linux-foundation.org) wrote:
> > 
> > 
> > On Tue, 15 Jan 2008, Mathieu Desnoyers wrote:
> > > 
> > > Well, it goes along the lines of the patch I suggested as a reply to
> > > Adrian, with these differences :
> > > 
> > > - I still source the kernel/Kconfig.instrumentation file.
> > > - I put back the missing OPROFILE options directly in arch/arm/Kconfig
> > > 
> > > Then end result is the same as your patch, but without the code
> > > duplication.
> > 
> > No it's not.
> > 
> > Now the config variables may all be there, but the UI for the *menu* 
> > system is broken (ie all the ARM profiling config options are now outside 
> > the profiling menu).
> > 
> > Is that menu really needed? I dunno. But since it exists, it should be 
> > correct.
> > 
> > 		Linus
> 
> There is an "instrumentation menu removal" patchset I've submitted to
> Andrew for the next release cycle that moves the instrumentation menu
> content into General setup (I did this following your advice).
> 
> Furthermore, on ARM, the OPROFILE_ARMV6, OPROFILE_MPCORE and
> OPROFILE_ARM11_CORE are all "bool , default y" (equivalent to the
> preferred def_bool y). Unless I am grossly mistaken, this is not
> supposed to show up in the menus; it's just selected when the
> dependencies are met.

This was the patch:
+if OPROFILE
+
+config OPROFILE_ARMV6
+	def_bool y
+	depends on CPU_V6 && !SMP
+	select OPROFILE_ARM11_CORE
+
+config OPROFILE_MPCORE
+	def_bool y
+	depends on CPU_V6 && SMP
+	select OPROFILE_ARM11_CORE
+
+config OPROFILE_ARM11_CORE
+	bool
+
+endif

And none of these has a prompt defined so they do not show up
as a menu.
It is very easy to test if you have the patch applied.
No cross toolchin is needed - just do:
make ARCH=arm menuconfig

	Sam
