Return-Path: <linux-kernel-owner+w=401wt.eu-S1753216AbYI3IDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216AbYI3IDO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 04:03:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbYI3IC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 04:02:58 -0400
Received: from smtp3.ono.com ([62.42.230.176]:35077 "EHLO resmaa05.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751596AbYI3IC4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 04:02:56 -0400
Date: Tue, 30 Sep 2008 10:02:52 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Typo bug [Re: Linux 2.6.27-rc8]
Message-ID: <20080930100252.22bb4df5@werewolf.home>
In-Reply-To: <20080930075553.GB20241@elte.hu>
References: <alpine.LFD.2.00.0809291527460.3389@nehalem.linux-foundation.org>
	<20080930094346.307ef1e5@werewolf.home>
	<20080930075553.GB20241@elte.hu>
X-Mailer: Claws Mail 3.5.0cvs138 (GTK+ 2.14.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Sep 2008 09:55:53 +0200, Ingo Molnar <mingo@elte.hu> wrote:

> 
> * J.A. Magallón <jamagallon@ono.com> wrote:
> 
> > Hi....
> > 
> > On Mon, 29 Sep 2008 15:39:09 -0700 (PDT), Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > 
> > > 
> > > So yet another week, another -rc. This one should be the last one: we're 
> > > certainly not running out of regressions, but at the same time, at some 
> > > point I just have to pick some point, and on the whole the regressions 
> > > don't look _too_ scary. And -rc8 obviously does fix more of them.
> > > 
> > > Most of the changes since -rc7 are pretty small, and there aren't even a 
> > > whole lot of them. The shortlog (appended) is just a couple of pages, and 
> > > the diffstat is even smaller, but since the dirstat is a dense overview, 
> > > I'll just put that here instead:
> > > 
> > 
> > 
> > Dealing with my Aspire One setup, I found this (so obvious I don't 
> > send a patch:)
> > 
> > 
> > arch/x86/kernel/cpu/mtrr/main.c:
> > 
> > static int __init disable_mtrr_cleanup_setup(char *str)
> > {
> >     if (enable_mtrr_cleanup != -1)
> >         enable_mtrr_cleanup = 0;
> >     return 0;
> > }
> > early_param("disable_mtrr_cleanup", disable_mtrr_cleanup_setup);
> > 
> > static int __init enable_mtrr_cleanup_setup(char *str)
> > {
> >     if (enable_mtrr_cleanup != -1)
> >         enable_mtrr_cleanup = 1;
> >     return 0;
> > }
> > early_param("enble_mtrr_cleanup", enable_mtrr_cleanup_setup);
> >              ^^^^^^
> > 
> > Nice ;)
> 
> heh. Could you send a patch with a changelog please?
> 

Here it goes...I hope its right.

==================

Correct typo for 'enable_mtrr_cleanup' early boot param name.

Signed-off-by: J.A. Magallon <jamagallon@ono.com>

diff -p -up linux/arch/x86/kernel/cpu/mtrr/main.c.orig linux/arch/x86/kernel/cpu/mtrr/main.c
--- linux/arch/x86/kernel/cpu/mtrr/main.c.orig	2008-09-30 09:57:46.000000000 +0200
+++ linux/arch/x86/kernel/cpu/mtrr/main.c	2008-09-30 09:57:55.000000000 +0200
@@ -834,7 +834,7 @@ static int __init enable_mtrr_cleanup_se
 		enable_mtrr_cleanup = 1;
 	return 0;
 }
-early_param("enble_mtrr_cleanup", enable_mtrr_cleanup_setup);
+early_param("enable_mtrr_cleanup", enable_mtrr_cleanup_setup);
 
 struct var_mtrr_state {
 	unsigned long	range_startk;











-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2009.0 (Cooker) for i586
Linux 2.6.25-jam18 (gcc 4.3.1 20080626 (GCC) #1 SMP
