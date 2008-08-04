Return-Path: <linux-kernel-owner+w=401wt.eu-S1758421AbYHDBTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758421AbYHDBTn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 21:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753255AbYHDBTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 21:19:34 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57364
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752817AbYHDBTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 21:19:33 -0400
Date: Sun, 03 Aug 2008 18:19:34 -0700 (PDT)
Message-Id: <20080803.181934.262275514.davem@davemloft.net>
To: a.beregalov@gmail.com
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: sparc64: build failure at sys_sparc32.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <a4423d670807290138p4a666337id74fe1fa637932e4@mail.gmail.com>
References: <20080729065914.GA30878@orion>
	<20080729.001256.203097603.davem@davemloft.net>
	<a4423d670807290138p4a666337id74fe1fa637932e4@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Alexander Beregalov" <a.beregalov@gmail.com>
Date: Tue, 29 Jul 2008 12:38:38 +0400

> 2008/7/29 David Miller <davem@davemloft.net>:
> > From: Alexander Beregalov <a.beregalov@gmail.com>
> > Date: Tue, 29 Jul 2008 10:59:14 +0400
> >
> >> I am testing build using randconfig.
> >>
> >> arch/sparc64/kernel/sys_sparc32.c: In function 'sys32_chown16':
> >> arch/sparc64/kernel/sys_sparc32.c:63: error: implicit declaration of
> >> function 'low2highuid'
> >> arch/sparc64/kernel/sys_sparc32.c:63: error: implicit declaration of
> >> function 'low2highgid'
> >> arch/sparc64/kernel/sys_sparc32.c: In function 'sys32_getresuid16':
> >> arch/sparc64/kernel/sys_sparc32.c:106: error: implicit declaration of
> >> function 'high2lowuid'
> >> arch/sparc64/kernel/sys_sparc32.c: In function 'sys32_getresgid16':
> >> arch/sparc64/kernel/sys_sparc32.c:123: error: implicit declaration of
> >> function 'high2lowgid'
> >>
> >> These functions are defined in linux/highuid.h only if CONFIG_UID16 is enabled.
> >
> > Thanks, what kernel version is this?
> 
> It is current by default - .27-rc1. These files were not touched for a
> long time.
> But, OK, I will mention the kernel version every time.

This is basically setup to fail.

If SPARC64 && COMPAT this option should always be set.  But it's
left as an option the user can still disable in this case down
in init/Kconfig.

This can be triggered very likely on other platforms too.

Can someone take a look at fixing this properly?  Make it something
that is selected on necessary platforms, for example.
