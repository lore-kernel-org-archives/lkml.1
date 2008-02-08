Return-Path: <linux-kernel-owner+w=401wt.eu-S1763633AbYBHUYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763633AbYBHUYW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 15:24:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761366AbYBHUYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 15:24:08 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:39672 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761473AbYBHUYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 15:24:06 -0500
To: zippel@linux-m68k.org
CC: miklos@szeredi.hu, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       sfrench@us.ibm.com, lachlan@sgi.com, jsipek@cs.sunysb.edu,
       rmk@arm.linux.org.uk, dhowells@redhat.com, raven@themaw.net,
       rathamahata@php4.ru, kkeil@suse.de, hpa@zytor.com, tytso@mit.edu,
       hirofumi@mail.parknet.co.jp, jdike@addtoit.com,
       mikulas@artax.karlin.mff.cuni.cz, wli@holomorphy.com,
       shaggy@austin.ibm.com, vandrove@vc.cvut.cz, Trond.Myklebust@netapp.com,
       jeffm@suse.com, paulus@samba.org, hugh@veritas.com, gorcunov@gmail.com,
       gregkh@suse.de
In-reply-to: <Pine.LNX.4.64.0802081849430.3378@scrub.home> (message from Roman
	Zippel on Fri, 8 Feb 2008 20:20:39 +0100 (CET))
Subject: Re: [patch 01/26] mount options: add documentation
References: <20080124193341.166753833@szeredi.hu> <20080124193416.379218079@szeredi.hu>
 <200801300254.06363.zippel@linux-m68k.org> <E1JK8wJ-0007aA-Tt@pomaz-ex.szeredi.hu> <Pine.LNX.4.64.0802081849430.3378@scrub.home>
Message-Id: <E1JNZky-0006lq-S7@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 08 Feb 2008 21:23:32 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Could also please explain why you want to go via user
> > > mounts. Other OS use a daemon for that, which e.g. can maintain
> > > access controls. How do you want to manage this?
> > 
> > The unprivileged mounts patches do contain a simple form of access
> > control.  I don't think anything more is needed, but of course, having
> > unprivileged mounts in the kernel does not prevent the use of a more
> > sophisticated access control daemon in userspace, if that becomes
> > necessary.
> 
> A "I don't think anything more is needed" lets go off all sorts of warning 
> lights. Most things start out simple, so IMO it's very worth it to check 
> where it might go to to know the limits beforehand. The main question here 
> is why should a kernel based solution be preferable over a daemon based 
> solution?

A daemon based solution would work for the "normal" case, where we
have a single mount namespace and a single /etc/mtab file, and we hope
it doesn't get too much out of sync with what is actually in the
kernel (on remount the mount options do get out of sync, but hey, we
seem to be able to live with that).

However, once you start using multiple namespaces, the daemon based
solution quickly becomes unusable, because you would need a separate
daemon for each namespace, and it would have to somehow keep track of
mount propagations in userspace (which is basically impossible), etc,
etc...

Does that answer your question?

Thanks,
Miklos
