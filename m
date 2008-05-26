Return-Path: <linux-kernel-owner+w=401wt.eu-S1755876AbYEZQfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876AbYEZQfg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 12:35:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753630AbYEZQf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 12:35:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:32997 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534AbYEZQf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 12:35:26 -0400
Date: Mon, 26 May 2008 13:34:57 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Andy Walls <awalls@radix.net>, Douglas Landgraf <dougsland@gmail.com>
Cc: Alan Cox <alan@redhat.com>, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] video4linux: Push down the BKL
Message-ID: <20080526133457.6f892af9@gaivota>
In-Reply-To: <20080523090919.GA31575@devserv.devel.redhat.com>
References: <20080522223700.2f103a14@core>
	<1211508484.3273.86.camel@palomino.walls.org>
	<20080523090919.GA31575@devserv.devel.redhat.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 May 2008 05:09:19 -0400
Alan Cox <alan@redhat.com> wrote:

> On Thu, May 22, 2008 at 10:08:04PM -0400, Andy Walls wrote:
> > Could someone give me a brief education as to what elements of
> > cx18/ivtv_v4l2_do_ioctl() would be forcing the use of the BKL for these
> > drivers' ioctls?   I'm assuming it's not the
> > mutex_un/lock(&....->serialize_lock) and that the answer's not in the
> > diff.
> 
> As it stood previous for historical reasons the kernel called the driver
> ioctl method already holding the big kernel lock. That lock effectively
> serialized a lot of ioctl processing and also serializes against module
> loading and registration/open for the most part. If all the resources you
> are working on within the ioctl handler are driver owned as is likely with
> a video capture driver, and you have sufficient locking of your own you can
> drop the lock.
> 
> video_usercopy currently also uses the BKL so you might want to copy a
> version to video_usercopy_unlocked() without that.

In the specific case of ivtv and cx18, I think that the better would be to
convert it first to video_ioctl2. Then, remove the BKL, with a
video_ioctl2_unlocked version.

Douglas already did an experimental patch converting ivtv to video_ioctl2 and
sent to Hans. It needs testing, since he doesn't have any ivtv board. It should
be trivial to port this to cx18, since both drivers have similar structures.

Douglas,

Could you send this patch to the ML for people to review and for Andy to port
it to cx18?

Cheers,
Mauro
