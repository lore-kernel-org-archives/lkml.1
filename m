Return-Path: <linux-kernel-owner+w=401wt.eu-S1754495AbZKHQKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495AbZKHQKE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 11:10:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752660AbZKHQKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 11:10:03 -0500
Received: from lo.gmane.org ([80.91.229.12]:54470 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040AbZKHQKB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 11:10:01 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Andres Salomon <dilinger@collabora.co.uk>
Subject: Re: i686 quirk for AMD Geode
Date: Sun, 8 Nov 2009 11:05:12 -0500
Message-ID: <20091108110512.3cfad100@mycelium.queued.net>
References: <20091106154911.29400@gmx.net>
	<20091106155937.11d95279@lxorguk.ukuu.org.uk>
	<20091106165731.26800@gmx.net>
	<20091106182218.43940287@lxorguk.ukuu.org.uk>
	<20091106200620.179910@gmx.net>
	<m3r5sbcl07.fsf@intrepid.localdomain>
	<20091107000559.166710@gmx.net>
	<40101cc30911070311u56035911l5eb50ac4abb73acc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: wireless.queued.net
In-Reply-To: <40101cc30911070311u56035911l5eb50ac4abb73acc@mail.gmail.com>
X-Newsreader: Claws Mail 3.7.3 (GTK+ 2.18.3; i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

See comment below.  BTW, how does this affect performance on LXs?
Do you have any hard numbers for common tasks?

On Sat, 7 Nov 2009 12:11:55 +0100
Matteo Croce <technoboy85@gmail.com> wrote:
[...]
> 
> --- a/arch/x86/kernel/Makefile	2009-11-06 15:06:52.246223989
> +0100 +++ b/arch/x86/kernel/Makefile	2009-11-06
> 15:07:04.294054613 +0100 @@ -89,7 +89,7 @@
>  obj-$(CONFIG_HPET_TIMER) 	+= hpet.o
> 
>  obj-$(CONFIG_K8_NB)		+= k8.o
> -obj-$(CONFIG_MGEODE_LX)		+= geode_32.o mfgpt_32.o
> +obj-$(CONFIG_MGEODE_LX)		+= geode_32.o mfgpt_32.o
> nopl_emu.o obj-$(CONFIG_DEBUG_RODATA_TEST)	+= test_rodata.o
>  obj-$(CONFIG_DEBUG_NX_TEST)	+= test_nx.o
> 
> --- a/arch/x86/kernel/cpu/amd.c	2009-11-06 15:06:52.254223805
> +0100 +++ b/arch/x86/kernel/cpu/amd.c	2009-11-06
> 15:07:04.294054613 +0100 @@ -138,8 +138,10 @@
>  	}
> 
>  	if (c->x86_model == 10) {
> -		/* AMD Geode LX is model 10 */
> -		/* placeholder for any needed mods */
> +		/* Geode only lacks the NOPL instruction to be i686,
> +		   but we can emulate it in the exception handler
> +		   and promote it to a class 6 cpu */
> +		boot_cpu_data.x86 = 6;
>  		return;
>  	}

If you're going to update this, you also need to make sure that you're
not breaking things that check it.  For example,
arch/x86/include/asm/geode.h has an is_geode_lx check that expects
boot_cpu_data.x86 to be 5.  Please be sure to update all these places
when creating a patch like this.


