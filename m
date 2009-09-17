Return-Path: <linux-kernel-owner+w=401wt.eu-S1752735AbZIQWkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735AbZIQWkt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 18:40:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750761AbZIQWkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 18:40:49 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52998 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750741AbZIQWks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 18:40:48 -0400
Date: Thu, 17 Sep 2009 23:41:44 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [bug] /etc/profile: line 30: /dev/null: Permission denied (Was:
  Re: [PATCH] Remove broken by design and by implementation devtmpfs 
 maintenance disaster)
Message-ID: <20090917234144.2f8eb1f2@lxorguk.ukuu.org.uk>
In-Reply-To: <ac3eb2510909171526ga51ecfag74af1a34a0437189@mail.gmail.com>
References: <m1y6oef08k.fsf@fess.ebiederm.org>
	<20090917125759.GA4045@kroah.com>
	<m1ab0tcwep.fsf@fess.ebiederm.org>
	<20090917185306.GA28635@elte.hu>
	<ac3eb2510909171218k4963fc7dv8fb7549007e511aa@mail.gmail.com>
	<alpine.LFD.2.01.0909171322210.4950@localhost.localdomain>
	<ac3eb2510909171526ga51ecfag74af1a34a0437189@mail.gmail.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That's true. I guess there are a few more devices that need special
> permissions. We could make that happen, so people could probably run a

I think this is misleading somewhat as were Ingo's init stuff to all run
as root then the permissions were fine. In other words it does what it
says on the tin (the real debate is whether it does it right)

You should only need /dev/null and /dev/zero to get sanity. The console
is opened by init and inherited. You might want to also fix the
permissions by default on /dev/tty as some scripts tend to get grumpy
without it. /dev/tty is a magic hook to the process group controlling tty
so has no real permissions impact being 0666.

The rest should essentially work out of the box - mount is done as root
to mount the real fs stuff so root only is ok, the console is inherited
so /dev/tty or just fd 0/1/2. Once you get to mingetty it will run as
root and permission manage the devices.

Alan
