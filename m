Return-Path: <linux-kernel-owner+w=401wt.eu-S1754102AbYGWC0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102AbYGWC0w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 22:26:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbYGWC0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 22:26:43 -0400
Received: from ozlabs.org ([203.10.76.45]:38743 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751729AbYGWC0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 22:26:43 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86: fix pte_flags() to only return flags, fix lguest (updated)
Date: Wed, 23 Jul 2008 10:59:20 +1000
User-Agent: KMail/1.9.9
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org
References: <200807221431.58991.rusty@rustcorp.com.au> <200807221540.47161.rusty@rustcorp.com.au> <20080722090432.GD2065@elte.hu>
In-Reply-To: <20080722090432.GD2065@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807231059.20810.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 July 2008 19:04:32 Ingo Molnar wrote:
> i'm wondering. My randconfig tests boot up an lguest enabled kernel
> every 30 minutes or so:
>
>  config-Mon_Jul_21_19_05_54_CEST_2008.good:CONFIG_LGUEST=y
>  config-Mon_Jul_21_19_43_13_CEST_2008.good:CONFIG_LGUEST=y
>  config-Mon_Jul_21_19_47_40_CEST_2008.good:CONFIG_LGUEST=y
>  config-Mon_Jul_21_20_37_41_CEST_2008.good:CONFIG_LGUEST=y
>  config-Mon_Jul_21_22_11_42_CEST_2008.good:CONFIG_LGUEST=y
>  config-Mon_Jul_21_22_16_59_CEST_2008.good:CONFIG_LGUEST=y
>  config-Mon_Jul_21_22_32_22_CEST_2008.good:CONFIG_LGUEST=y
>  config-Mon_Jul_21_23_25_55_CEST_2008.good:CONFIG_LGUEST=y
>  config-Mon_Jul_21_23_51_29_CEST_2008.good:CONFIG_LGUEST=y
>
> Would it be possible to have some really stupid lguest self-test which
> would complain spectacularly in the host kernel if it fails to reach
> some minimal user-space?
>
> Something that could be self-contained within a single bzImage. (i.e. it
> would contain a minimalistic image of some sort with a very minimalistic
> userspace component as well - or something like that)

Well, adding "make -C Documentation/lguest" to the build is a good start (this 
finds those "e820.h not longer includable from userspace" bugs).

Secondly, if you put the resulting Documentation/lguest/lguest somewhere on 
your booting test machine, it can just do something like

	./lguest 64 /boot/vmlinuz-`uname -r` | grep 'VFS: Unable to mount root'

Won't quite test userspace, but it's easy and will get the worst breakage.
If we want to be more ambitious, I'd suggest a tiny initrd with a 
statically-linked /hello_world to test userspace:

	./lguest --initrd=/boot/hello_world.initrd 64 /boot/vmlinuz-`uname -r` \
		rdinit=/hello_world | grep 'Hello world'

I can create one (and test the example) for you if you're interested?

Thanks,
Rusty.
