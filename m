Return-Path: <linux-kernel-owner+w=401wt.eu-S1755938AbYKPXH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938AbYKPXH2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 18:07:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753910AbYKPXHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 18:07:15 -0500
Received: from smtp3.ono.com ([62.42.230.176]:48510 "EHLO resmaa06.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753832AbYKPXHO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 18:07:14 -0500
Date: Mon, 17 Nov 2008 00:07:11 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: sata-nv and 790i
Message-ID: <20081117000711.2de5f9e8@werewolf.home>
In-Reply-To: <491FB988.50601@kernel.org>
References: <20081115004722.5158e125@werewolf.home>
	<491FB988.50601@kernel.org>
X-Mailer: Claws Mail 3.6.1cvs25 (GTK+ 2.14.4; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Nov 2008 15:11:20 +0900, Tejun Heo <tj@kernel.org> wrote:

> J.A. Magallón wrote:
> > Hi all...
> > 
> > I recently put my hands on a system with an ASUS P5N64 WS Pro mobo:
> > 
> > http://www.asus.com/products.aspx?l1=3&l2=11&l3=653&l4=0&model=2182&modelmenu=1
> > 
> > It has a nForce 790i Ultra SLI chipset, the part for the SATA controller
> > is MCP55.
> > 
> > The problem is that linux seems to fail to read the hard drive on boot.
> > I will explain.
> > 
> > I have tried to install both CentOS 5.2 and Mandriva 2009.0.
> > For CentOS (has a 2.6.18 kernel), the install seems ok, but when I reboot
> > into the just intalled system the kernel hangs just after printing
> > the name of the initrd. Mandriva (2.6.27-rc8) just hungs half the install process.
> > Live versions of both hang on boot saying they can not find the root
> > device.
> > 
> > I have found some messages in the net about the MCP55 in that board not
> > being completeley suppported as AHCI in sata_nv, and that some other
> > boards work puttin the SATA controller in 'compatible' mode (with
> > loss of performance).
> > But I can't find any setting in the P5N64 to put SATA in Compat mode.
> > 
> > Can I do this via some kernel parameters ?
> > Somabody has this board working ? Do current kernels have better support
> > for this chipset ?
> 
> All three flavors of sata_nv's - generic (yours), nf2/3 and ck804 - had
> various detection problems from 2.6.27-rc1.  The problem was that their
> hardresets all worked differently.  2.6.27-rc1 started to favor
> hardresets over softresets and exposed this problem.  While trying to
> fix the problem, because all three flavors unexpectedly showed different
> hardreset behaviors, there were some mistakes.  A proper fix is included
> in upstream and is queued for -stable.  Sorry about the mess.
> 

Thanks for the info. Just a couple more questions (I have to say to our
sysdamins if it can be done or not... :) ).

The point on hardresets clarifies the Mandriva case, where I have an 27-rc8
kernel. But what about the CentOS case ? If problems begun with rc1,
what happens with plain 2.6.18 ? It just doesn't have support for that
controller ? But installer works...

Is this the patch in question:

http://marc.info/?l=linux-kernel&m=122584322811935&w=2
http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=commitdiff;h=814eb57e1799337d9fbb68f5d838afa507dc014e;hp=7bee179aa2a63087ff80bdd7dcb8bd6da209f359

So I suppose that 2.6.27.5 includes this fix.
Can I guess if a kernel would work looking for this code in the source ?

With this info, I can presume that current Mandriva Cooker would work
(it has a .5 kernel), and could check if CentOS people have backported
it in its updates...or do it myself (some CentOS people listening ...? ).
I probably need to install CentOS, its the 'officially supported' distro in
our department.

TIA

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2009.1 (Cooker) for x86_64
Linux 2.6.27.5-desktop-1mnb (gcc 4.3.2 (GCC) #1 Sun Nov
