Return-Path: <linux-kernel-owner+w=401wt.eu-S1752047AbZFYJ4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047AbZFYJ4e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 05:56:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751411AbZFYJ41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 05:56:27 -0400
Received: from senator.holtmann.net ([87.106.208.187]:38640 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbZFYJ40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 05:56:26 -0400
Subject: Re: [PATCH 1/6] staging: android: binder: Remove some funny &&
 usage
From: Marcel Holtmann <marcel@holtmann.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Daniel Walker <dwalker@fifo99.com>,
       Linus Walleij <linus.ml.walleij@gmail.com>,
       Brian Swetland <swetland@google.com>,
       Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org,
       hackbod@android.com
In-Reply-To: <20090625091519.23bc42ff@lxorguk.ukuu.org.uk>
References: <1244832678-30329-1-git-send-email-dwalker@fifo99.com>
	 <1245254936.5982.261.camel@desktop> <4A391A54.7000109@goop.org>
	 <d6200be20906171426n71979124i4b359b6f4fc35d7e@mail.gmail.com>
	 <1245274308.5982.268.camel@desktop>
	 <a55d774e0906191220i7280fe77qb724037fb92fab86@mail.gmail.com>
	 <1245451983.32124.25.camel@desktop>
	 <d6200be20906191713n161d4281u1f43804e675e29ac@mail.gmail.com>
	 <1245849223.32124.112.camel@desktop>
	 <a55d774e0906241514w761f86fva294784583cdd8a4@mail.gmail.com>
	 <63386a3d0906241701o720fa667t662b9e3d4f080397@mail.gmail.com>
	 <1245889219.32124.280.camel@desktop>
	 <20090625091519.23bc42ff@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Thu, 25 Jun 2009 11:56:30 +0200
Message-Id: <1245923790.12994.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

> > > What I really want to know, is how this relates to the vmsplice() and
> > > other zero-copy buffer passing schemes already in the kernel. I was
> > > sort of dreaming that D-Bus and other IPC could be accelerated on
> > > top of that.
> > 
> > Marcel had mentioned earlier in this thread that D-Bus could be
> > accelerated with shared memory or moving the dbus-daemon into the
> > kernel. splice() and vmplice() seem like fairly robust system calls. I
> > would think they could be used also ..
> 
> Except for very large amounts of data what makes you think zero copy
> buffer passing will be fast ? TLB shootdowns are expensive and they scale
> horribly badly with threaded apps on multiprocessor systems ?

there is always the problem if we have really stupidly written apps that
just copy megabyte of data from one app to the other. These just need
fixing and Lennart posted patches to integrate file descriptor passing
into the D-Bus protocol which will make it more versatile. And for most
cases it will be just good enough to move file descriptors around. Then
having the possibility to pass bigger data blobs without too many
penalties would be an extra bonus.

Regards

Marcel


