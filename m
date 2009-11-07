Return-Path: <linux-kernel-owner+w=401wt.eu-S1751873AbZKGAGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873AbZKGAGA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 19:06:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751411AbZKGAF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 19:05:59 -0500
Received: from mail.gmx.net ([213.165.64.20]:44687 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750883AbZKGAF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 19:05:58 -0500
Cc: linux-kernel@vger.kernel.org, Matteo Croce <technoboy85@gmail.com>
Content-Type: text/plain; charset="iso-8859-1"
Date: Sat, 07 Nov 2009 01:05:59 +0100
From: "Martin Schleier" <drahemmaps@gmx.net>
In-Reply-To: <m3r5sbcl07.fsf@intrepid.localdomain>
Message-ID: <20091107000559.166710@gmx.net>
MIME-Version: 1.0
References: <20091106154911.29400@gmx.net>
	<20091106155937.11d95279@lxorguk.ukuu.org.uk>	<20091106165731.26800@gmx.net>
	<20091106182218.43940287@lxorguk.ukuu.org.uk>	<20091106200620.179910@gmx.net>
 <m3r5sbcl07.fsf@intrepid.localdomain>
Subject: Re: i686 quirk for AMD Geode
To: Krzysztof Halasa <khc@pm.waw.pl>
X-Authenticated: #35928486
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX19c/BAoMjxcpN2f2mH4Rtm84zz7KVz7LAUYEDD+3H
 le0+SjZshQSpbcrqtlvWWw4eOQntoJlyQx5g== 
Content-Transfer-Encoding: 8bit
X-GMX-UID: tM2ROncgZCEEWchDQW4htYV4IGhpZcYW
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sat, 07 Nov 2009 00:05:12 Krzystof Halasa
> "Martin Schleier" <drahemmaps@gmx.net> writes:
>On Fri, 6 Nov 2009 18:22:18 Alan Cox wrote:
> > > If it wasn't riddled with 19 errors (not bad for only 133 lines),
> > > I would have bothered to remove these irrelevant lines.
> > 
> > Checkpatch is just formatting - its just an aide nothing more.
> > It's not remotely useful to bother with them for stuff that is
> > basically sanely formatted until such point as someone is actually
> > sure the patch is worth going into the tree.
> >
> > the utility is called checkpatch and not checkstyle or 
> > checkformatting.
> > And there's a good reason behind this decision, because it does
> > more than just checking style.
> >
> > e.g:
> > - correct use of some blackfin hi/lo macros.
> > - if certain data structures are declared as const
> >   (struct seq_operations/file_operations)
> > - correct use of NR_CPUS is usually wrong
> > - complains about in_atomic() outside core kernel code
> > - warns about LINUX_VERSION_CODE, #if 0,
> >   volatile or deprecated functions.
> > - informs about needless kfree/usb_free_urb checks
> > - etc...
> >
> > and I'm sure that future modifications will add more
> >useful functionality _checks_ to many more _common pitfalls_ 
> >areas.
>
> Did the patch in question contain such problems?
the last point:
 - etc... =>

"WARNING: externs should be avoided in .c files
#56: FILE: arch/x86/kernel/nopl_emu.c:13:
+void do_invalid_op(struct pt_regs *regs, long error_code);" ?
(or do you think that this is a formatting issue?!)

a grep will give you a header file where it is defined:
"arch/x86/include/asm/traps.h"
dotraplinkage void do_invalid_op(struct pt_regs *, long);

anyway, in case we get more followers here. I put your question back 
in context of the original response. Because this discussion-branch was
not about arguing about nopl emulation, since - apparently - nothing
was/is wrong with the code itself.

Instead, we ended up here because of:

Fri, 6 Nov 2009 15:59:37 Alan Cox wrote:
"Secondly Ingo knows how to operate checkpatch and trivial style bits like
that are irrelevant to meaningful discussion about code."

And this is clearly not the case. It is the job of a Submitter
(as described in Documentations/SubmittingPatches section 4)
to check and test his patches with tools like checkpatch or sparse
before posting them.

After all this patch is going into /arch/x86 and not /drivers/staging
and this sort of "extern declaration" is prone to break one day when
void do_invalid_op(struct pt_regs *, long); declaration is modified.
-- 
GRATIS für alle GMX-Mitglieder: Die maxdome Movie-FLAT!
Jetzt freischalten unter http://portal.gmx.net/de/go/maxdome01
