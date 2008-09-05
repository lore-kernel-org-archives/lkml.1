Return-Path: <linux-kernel-owner+w=401wt.eu-S1753522AbYIETZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbYIETZw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 15:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751824AbYIETZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 15:25:44 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35949 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbYIETZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 15:25:44 -0400
Subject: Re: [2.6.27] overlapping early reservations [was: early exception
 - lockdep related?]
From: Peter Zijlstra <peterz@infradead.org>
To: Luca Tettamanti <kronos.it@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com,
       "H. Peter Anvin" <hpa@kernel.org>
In-Reply-To: <68676e00809051217h3da02a6bld4412b4a2ee3b728@mail.gmail.com>
References: <68676e00809051217h3da02a6bld4412b4a2ee3b728@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 05 Sep 2008 21:25:38 +0200
Message-Id: <1220642738.11202.21.camel@twins.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.91 (2.23.91-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-09-05 at 21:17 +0200, Luca Tettamanti wrote:
> On Thu, Sep 4, 2008 at 10:51 PM, Luca Tettamanti <kronos.it@gmail.com> wrote:
> > On Thu, Sep 4, 2008 at 4:25 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> >> Sadly your config just boots, albeit not to userspace due to missing
> >> drivers.
> >
> > Yes, I managed to boot it with qemu... I tried kgdb - without luck -
> > kernel dies too early.
> > I also managed to get a stack trace :D
> >
> > http://img151.imageshack.us/my.php?image=tracedm1.jpg
> >
> > It seems that lockdep is an innocent bystander... the kernel died with
> > panic() in __reserve_early, and then took another exception while
> > printing the panic (I guess).
> > Will add further debug stuff to see wtf is going on.
> 
> Hum, kernel says:
> 
> http://img177.imageshack.us/my.php?image=overlappingus2.jpg
> 
> Overlapping early reservations b98000-eff266 RAMDISK to 200000-d09cf7
> TEXT DATA BSS
> 
> It would appear that the initramfs is overlapping the kernel itself,
> is the boot loader (LILO) doing something stupid?

Suppose it is, lets ask hpa..

