Return-Path: <linux-kernel-owner+w=401wt.eu-S1759368AbYHaOJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759368AbYHaOJ5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 10:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756948AbYHaOJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 10:09:49 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:57105 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756913AbYHaOJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 10:09:48 -0400
Date: Sun, 31 Aug 2008 11:09:42 -0300
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: Gerhard Brauer <gerhard.brauer@web.de>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.{26.2,27-rc} oops on virtualbox
Message-ID: <20080831110942.7acaf82f@mandriva.com.br>
In-Reply-To: <20080831092923.GB4305@tux1.brauer.lan>
References: <20080826141851.GA5300@tux1.brauer.lan>
 <20080826145338.GA8601@Krystal>
 <20080826131354.356ae11d@doriath.conectiva>
 <20080826171822.GB14906@Krystal>
 <20080826150222.0cf1542c@doriath.conectiva>
 <20080826181558.GA16887@Krystal>
 <20080826203449.GD5300@tux1.brauer.lan>
 <20080827161346.35b48d75@doriath.conectiva>
 <20080827233328.GC25531@Krystal>
 <20080828103013.163730ee@doriath.conectiva>
 <20080831092923.GB4305@tux1.brauer.lan>
Organization: Mandriva
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.13.7; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, 31 Aug 2008 11:29:23 +0200
Gerhard Brauer <gerhard.brauer@web.de> escreveu:

| On Thu, Aug 28, 2008 at 10:30:13AM -0300, Luiz Fernando N. Capitulino wrote:
| > Em Wed, 27 Aug 2008 19:33:28 -0400
| > Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> escreveu:
| > | 
| > | Since this problem appears while we are using a simple memcpy (the
| > | text_poke_early version), but disappears when we disable interrupts for
| > | a longer period of this, I suspect a problem with irq disabling in
| > | Virtualbox.
| > | 
| > | We could try to add some nsleep() or msleep() calls within text_poke and
| > | text_poke_early before and after the code modificatoin to see if the
| > | problem disappears. If it does, then that would somewhat confirm the
| > | racy irq disable thesis.
| > 
| >  Well, a Ubuntu kernel guy has reported in the virtualbox's ticket[1]
| > that the oops doesn't happen if he puts a printk() in the crash site.
| > 
| >  The funny thing is that someone (who might be a virtualbox developer)
| > used the same race argument to say that this is a bug in the kernel.
| > 
| >  What concerns me though is that how can virtualbox be worth using
| > in the Linux community if it's probably not working for various distros
| > (currently Fedora, Ubuntu, Mandriva and ArchLinux).
| > 
| >  Thanks for the effort, guys.
| > 
| > [1] http://www.virtualbox.org/ticket/1875
| 
| Ok, some news from archlinux side:
| Our distribution kernel was upgraded from 2.6.26.2 to 2.6.26.3. With
| this upgrade to patchlevel .3 the "early oops"(freeing smp...) has gone.
| My virtual machines boots always fine with this, and i have one
| confirmation from a user about this.
| 
| Kernel upgrade does not solve the kernel panic during work with the VM,
| when there is heavy disk IO. I test and could reproduce this by untar 2
| big files in seperate dirs: bsdtar -x -f VirtualBox-1.6.2-OSE.tar.bz2.
| Doing this simultan crashed the VM always.
| SreenShot:
| http://users.archlinux.de/~gerbra/tmp/2008-08-31-110449_724x456_scrot.png
| 
| This heavy IO oops does not occur under 2.6.26.2 when using the
| "3-changes-patch" against alternatives.c, which we have tested in the
| other mails. There must be something irq related which fix this
| 3-changes-patch, and what was not fixed in 2.6.26.3
| On the other hand: I never have stressed a VM like this before
| researching for this problem. So it could also be that the heavy-IO
| problem way a total seperate problem from that we're talking about here.
| Doing my "normal" work now in VM (it's my devel VM for compiling and
| testing), until now i don't have had this IO oops.

 Mandriva kernel was 2.6.26.3 based at the time I started testing
this and all my last tests have been done on 2.6.27-rc4. I think it's
very unusual to have a change in a -stable kernel not present in the
latest -rc.

 Also note that CPU settings in the VM has a big influency in the
problem, so I'm pretty sure 2.6.26.3 doesn't fix the problem.


-- 
Luiz Fernando N. Capitulino
