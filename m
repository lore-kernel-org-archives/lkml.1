Return-Path: <linux-kernel-owner+w=401wt.eu-S1753557AbZIQU0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557AbZIQU0g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 16:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752919AbZIQU0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 16:26:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56912 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752787AbZIQU0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 16:26:33 -0400
Date: Thu, 17 Sep 2009 13:26:01 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Kay Sievers <kay.sievers@vrfy.org>
cc: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [bug] /etc/profile: line 30: /dev/null: Permission denied (Was:
  Re: [PATCH] Remove broken by design and by implementation devtmpfs 
 maintenance disaster)
In-Reply-To: <ac3eb2510909171218k4963fc7dv8fb7549007e511aa@mail.gmail.com>
Message-ID: <alpine.LFD.2.01.0909171322210.4950@localhost.localdomain>
References: <m1y6oef08k.fsf@fess.ebiederm.org> <20090917125759.GA4045@kroah.com>  <m1ab0tcwep.fsf@fess.ebiederm.org> <20090917185306.GA28635@elte.hu> <ac3eb2510909171218k4963fc7dv8fb7549007e511aa@mail.gmail.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 17 Sep 2009, Kay Sievers wrote:

> On Thu, Sep 17, 2009 at 20:53, Ingo Molnar <mingo@elte.hu> wrote:
> > I've reproduced a bug with the following .config options:
> >
> >  CONFIG_DEVTMPFS=y
> >  CONFIG_DEVTMPFS_MOUNT=y
> >
> > /dev/null and /dev/zero are not read/writable to ordinary users,
> > breaking normal bootup and login:
> 
> Udev should run long before some ordinary/non-root user can login, and
> apply the permissions as it always does. It's known to work on Fedora,
> SUSE, Ubuntu. What kind of system/environment/setup is that where you
> see this?

I don't know if this is what Ingo does, but I have a few machines where I 
don't run the distro-supplied 'initrd' at all, because it's easier to boot 
without it. The Fedora initrd doesn't allow me to sanely set root 
filesystem parameters without totally rewriting the initrd image, which 
I'm not interested in, for example (they'll take effect for the root 
initrd, not the final root).

That may be "not supported", but the point is, we want to make the kernel 
be as self-sufficient as possible, and the whole _point_ of this devtmpfs 
seemed to be to increase self-sufficiency rather than decrease it by 
requiring 'udev' to have run very very early.

If you have udev running really early, then what's the point of devtmpfs? 
You might as well just have udev and tmpfs.

So I suspect /dev/null and /dev/zero should be special - just make them 
have 0666 permissions. Because they really _are_ special, and no other 
permissions ever make sense for them.

		Linus
