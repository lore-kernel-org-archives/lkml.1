Return-Path: <linux-kernel-owner+w=401wt.eu-S1751945AbZIROJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945AbZIROJu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 10:09:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751063AbZIROJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 10:09:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:35865 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbZIROJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 10:09:49 -0400
Date: Fri, 18 Sep 2009 16:09:44 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Greg Kroah-Hartmann <greg@kroah.com>
Subject: Re: [PATCH] Remove broken by design and by implementation devtmpfs
  maintenance disaster
Message-ID: <20090918160944.58e5c1f5@infradead.org>
In-Reply-To: <m1d45oxsrk.fsf@fess.ebiederm.org>
References: <m1y6oef08k.fsf@fess.ebiederm.org>
	<ac3eb2510909170503n1da43ea0u7c900f2f6f647fdc@mail.gmail.com>
	<m1d45oxsrk.fsf@fess.ebiederm.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Sep 2009 06:54:39 -0700
ebiederm@xmission.com (Eric W. Biederman) wrote:

> 
> > I don't understand. Udev applies the final policy including
> > permissions/ownership, just as before. There is no differrence. It's
> > just that you can bring up a box without complex userspace to
> > bootstrap /dev. And that's a big win on its own.
> 
> udev is too complex to use?  That sounds like a userspace bug.
> 
> This I guess is where I am baffled.   The argument for devtmpfs
> always seem to boil down to: udev sucks let's write some kernel
> code instead.
> 
> I have been trying to ask for a long time why we can't just fix
> udev to not suck. 
> 
> >  And things like
> > "modprobe loop; losetup /dev/loop0" will just work, which it doesn't
> > with todays async udev. Again, please make yourself familiar how
> > things work, and what the problems are.
> 
> I guess I don't understand why 
> modprobe loop; losetup /dev/loop0 is an interesting case.
> When you can just as easily do:
> modprobe loop; udevadm settle; losetup /dev/loop0.

frankly, modprobe should call the settle.
And not just this one, but we can use this to settle other things as
well... and then it can get an --async command line option for the
cases where you know you don't want to synchronize.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
