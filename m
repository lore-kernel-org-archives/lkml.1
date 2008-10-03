Return-Path: <linux-kernel-owner+w=401wt.eu-S1754799AbYJCHlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799AbYJCHlt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 03:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754103AbYJCHll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 03:41:41 -0400
Received: from smtp.ono.com ([62.42.230.12]:64818 "EHLO resmaa02.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753779AbYJCHlk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 03:41:40 -0400
Date: Fri, 3 Oct 2008 09:41:37 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] x86: mtrr_cleanup try gran_size to less than 1M
Message-ID: <20081003094137.4a4e8d29@werewolf.home>
In-Reply-To: <20081003073727.GC4950@elte.hu>
References: <1222739652-17169-1-git-send-email-yhlu.kernel@gmail.com>
	<1222739652-17169-2-git-send-email-yhlu.kernel@gmail.com>
	<20081003003237.04469201@werewolf.home>
	<20081003073727.GC4950@elte.hu>
X-Mailer: Claws Mail 3.5.0cvs144 (GTK+ 2.14.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Oct 2008 09:37:27 +0200, Ingo Molnar <mingo@elte.hu> wrote:

> 
> * J.A. Magallón <jamagallon@ono.com> wrote:
> 
> > Also, on a 64 bit box with 4Gb, it gives this:
> > 
> > cicely:~# cat /proc/mtrr
> > reg00: base=0x00000000 (   0MB), size=4096MB: write-back, count=1
> > reg01: base=0x100000000 (4096MB), size=1024MB: write-back, count=1
> > reg02: base=0x140000000 (5120MB), size= 512MB: write-back, count=1
> > reg03: base=0x160000000 (5632MB), size= 256MB: write-back, count=1
> > reg04: base=0x80000000 (2048MB), size=2048MB: uncachable, count=1
> > 
> > Patch below cleans up formatting, with space for big bases and sizes (64 Gb).
> 
> applied to tip/x86/mtrr, thanks!
> 
> > +++ arch/x86/kernel/cpu/mtrr/if.c     2008-10-03 00:22:34.000000000 +0200
> > @@ -16,7 +16,7 @@
> >  static const char *const mtrr_strings[MTRR_NUM_TYPES] =
> >  {
> >      "uncachable",               /* 0 */
> > -    "write-combining",          /* 1 */
> > +    "write-combine",            /* 1 */
> 
> hm, maybe this bit could confuse versions of Xorg that modifies 
> /proc/mtrr - i.e. this could be part of the ABI towards user-space. 
> We'll see.
> 
> 	Ingo

Oops, it's not only used for messages, also for writes in /proc !!!

Forget this part.

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2009.0 (Cooker) for i586
Linux 2.6.25-jam18 (gcc 4.3.1 20080626 (GCC) #1 SMP
