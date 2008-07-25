Return-Path: <linux-kernel-owner+w=401wt.eu-S1754824AbYGYB4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824AbYGYB4A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 21:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752840AbYGYBzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 21:55:53 -0400
Received: from ozlabs.org ([203.10.76.45]:50350 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752658AbYGYBzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 21:55:52 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86: fix pte_flags() to only return flags, fix lguest (updated)
Date: Fri, 25 Jul 2008 11:55:49 +1000
User-Agent: KMail/1.9.9
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org
References: <200807221431.58991.rusty@rustcorp.com.au> <200807231059.20810.rusty@rustcorp.com.au> <20080724113122.GB23262@elte.hu>
In-Reply-To: <20080724113122.GB23262@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807251155.49606.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 July 2008 21:31:22 Ingo Molnar wrote:
> * Rusty Russell <rusty@rustcorp.com.au> wrote:
> > On Tuesday 22 July 2008 19:04:32 Ingo Molnar wrote:
> > > i'm wondering. My randconfig tests boot up an lguest enabled kernel
> > > every 30 minutes or so:
> > >
> > >  config-Mon_Jul_21_19_05_54_CEST_2008.good:CONFIG_LGUEST=y
> > >  config-Mon_Jul_21_19_43_13_CEST_2008.good:CONFIG_LGUEST=y
> > >  config-Mon_Jul_21_19_47_40_CEST_2008.good:CONFIG_LGUEST=y
> > >  config-Mon_Jul_21_20_37_41_CEST_2008.good:CONFIG_LGUEST=y
> > >  config-Mon_Jul_21_22_11_42_CEST_2008.good:CONFIG_LGUEST=y
> > >  config-Mon_Jul_21_22_16_59_CEST_2008.good:CONFIG_LGUEST=y
> > >  config-Mon_Jul_21_22_32_22_CEST_2008.good:CONFIG_LGUEST=y
> > >  config-Mon_Jul_21_23_25_55_CEST_2008.good:CONFIG_LGUEST=y
> > >  config-Mon_Jul_21_23_51_29_CEST_2008.good:CONFIG_LGUEST=y
> > >
> > > Would it be possible to have some really stupid lguest self-test which
> > > would complain spectacularly in the host kernel if it fails to reach
> > > some minimal user-space?
> > >
> > > Something that could be self-contained within a single bzImage. (i.e.
> > > it would contain a minimalistic image of some sort with a very
> > > minimalistic userspace component as well - or something like that)
> >
> > Well, adding "make -C Documentation/lguest" to the build is a good start
> > (this finds those "e820.h not longer includable from userspace" bugs).
> >
> > Secondly, if you put the resulting Documentation/lguest/lguest somewhere
> > on your booting test machine, it can just do something like
> >
> > 	./lguest 64 /boot/vmlinuz-`uname -r` | grep 'VFS: Unable to mount root'
>
> stupid question: what's the easiest way to filter out the case where
> there's not sufficient kernel support in the bzImage to actually run
> lguest?
>
> I.e. if i extend the "is this bzImage working fine" check with the above
> lguest bootup test - with the expectation of it getting down to the
> "VFS: Unable to mount root" message [success case], how do i filter out
> the case where it doesnt get to that message not due to some lguest
> breakage, but because there's not enough lguest support there.

Easiest to check config: CONFIG_LGUEST and CONFIG_LGUEST_GUEST.

Well, there may be no host-for-lguest support, modular or builtin.  "modprobe 
lg" to be sure, then if lguest says: "lguest: Failed to open /dev/lguest: No 
such file or directory" your host doesn't support it.

If there's no guest support, it's trickier.  The boot will fail in some 
non-obvious way depending on config options....

> > I can create one (and test the example) for you if you're interested?
>
> that would be great ...

OK, added to TODO.

Rusty.
