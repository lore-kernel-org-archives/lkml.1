Return-Path: <linux-kernel-owner+w=401wt.eu-S1754196AbYIBUTL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbYIBUTL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 16:19:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752233AbYIBUS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 16:18:56 -0400
Received: from www.tglx.de ([62.245.132.106]:60676 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150AbYIBUSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 16:18:55 -0400
Date: Tue, 2 Sep 2008 22:18:25 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
cc: herton@mandriva.com.br, linux-kernel@vger.kernel.org
Subject: Re: 2.6.27-rc5 doesn't boot on a Pavilion laptop
In-Reply-To: <20080902163532.436f8fbd@doriath.conectiva>
Message-ID: <alpine.LFD.1.10.0809022208320.3243@apollo.tec.linutronix.de>
References: <20080902163532.436f8fbd@doriath.conectiva>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luiz,

On Tue, 2 Sep 2008, Luiz Fernando N. Capitulino wrote:
> 
>  I have a HP Pavilion dv6000 laptop here which doesn't boot with
> latest Linus tree (2.6.27-rc5).
> 
>  The last lines I see on the screen are:
> 
> """
> hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
> hpet0: 3 32-bit timers, 25 000000 Hz
> """

Sigh. I'm getting sick of that :)
 

>  Then I bisected and git says that the culprit is:
> 
> """
> commit aa276e1cafb3ce9d01d1e837bcd67e92616013ac
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Mon Jun 9 19:15:00 2008 +0200
> 
>     x86, clockevents: add C1E aware idle function

Not surprising :)

>  Now, what puzzles me though is that if you do:
> 
> $ git checkout -b bla aa276e1cafb3ce9d01d1e837bcd67e92616013ac
> 
>  and edit the Makefile you will see that it is a 2.6.26-rc4
> kernel! When I saw this I thought 'wth? git bisect went backwards?'
> (I specified 2.6.26 as good and 2.6.27-rc1 as bad).

That's because the commit happened in the x86 git tree after
2.6.26-rc4. In fact you checked out the branch of the x86 git tree
where the commit happened.

>  I don't know if this is known (it should be) but it seems that you
> have changed the Makefile during the merge of that commit... But
> I'm quite sure that this commit has been introduced in 2.6.27-rc1.

Yes, it was merged into Linus tree after 2.6.26 and before
2.6.27-rc1. That's how git works. It keeps track from which point a
particular commit descended. If you look at the git tree with gitk,
then you will see the various points where a particular branch was
split off from Linus tree and when it was merged back.

Nothing to worry about.
 
>  I would try to revert it from current Linus' tree to see if it
> really fix the problem but turns out that it will take some time
> to work on the conflicts.

Don't do that. We really need to find out what the root cause of this
HPET wreckage on those AMD machine is. The commit in question _IS_ the
alleged culprit, but the root cause is something different.

>  I'm attaching the 2.6.26.3 (Mandriva kernel) and 2.6.27-rc5 (with
> hpet=disable) dmesg files.
> 
>  Also, this _seems_ to be the same as reported in:
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=11191

Yup.
 
>  But I'm still compiling the kernel with the appropriate config
> options to confirm this.
> 
>  Please, let me know if there's anything else I can do to
> help you debug this.

Can you please disable CONFIG_HPET ?

Thanks,

	tglx
