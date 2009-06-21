Return-Path: <linux-kernel-owner+w=401wt.eu-S1753422AbZFUMJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422AbZFUMJx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 08:09:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752124AbZFUMJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 08:09:46 -0400
Received: from senator.holtmann.net ([87.106.208.187]:54261 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbZFUMJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 08:09:45 -0400
Subject: Re: [PATCH 1/6] staging: android: binder: Remove some funny &&
 usage
From: Marcel Holtmann <marcel@holtmann.org>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       Brian Swetland <swetland@google.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org,
       hackbod@android.com
In-Reply-To: <1245458940.32124.45.camel@desktop>
References: <1244832678-30329-1-git-send-email-dwalker@fifo99.com>
	 <4A380494.6030506@goop.org> <1245249469.5982.251.camel@desktop>
	 <4A390B9A.40806@goop.org> <1245254936.5982.261.camel@desktop>
	 <4A391A54.7000109@goop.org>
	 <d6200be20906171426n71979124i4b359b6f4fc35d7e@mail.gmail.com>
	 <1245274308.5982.268.camel@desktop>
	 <a55d774e0906191220i7280fe77qb724037fb92fab86@mail.gmail.com>
	 <1245451983.32124.25.camel@desktop>
	 <d6200be20906191713n161d4281u1f43804e675e29ac@mail.gmail.com>
	 <1245458940.32124.45.camel@desktop>
Content-Type: text/plain
Date: Sun, 21 Jun 2009 14:09:36 +0200
Message-Id: <1245586176.15367.62.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

> > > Also are there any userspace test cases
> > > that Google used to test the performance of this interface. Or test
> > > cases to compare the binder with something like sockets, or any other
> > > type of IPC?
> > >
> > > If Google believes the binder is the right solution for IPC, how was
> > > that conclusion formed?
> > >
> > > Daniel
> > 
> > These are mostly questions for the framework team. The binder driver
> > is there to support our user space code. At some point we used the
> > driver from www.open-binder.org, but we ran into, and fixed, a lot of
> > bugs (especially when processes died), so we determined it would be
> > faster to rewrite the driver from scratch.
> 
> Most of these questions related to the fact that I don't think an
> interface like this just slips into the kernel as a driver. Since it's
> IPC, it's totally generic, and it's not part of a standard (i.e. POSIX),
> we need to have some better and more specific information about it (or
> atleast I do). 

at this point of time we are using D-Bus quite successfully for mostly
every userspace application. And embedded devices like Nokia 810 or even
the new Palm Pre seems to be very happy with it. Even the Android
platform contains D-Bus support (even though limited for BlueZ).

The only downside with D-Bus right now is that you can't really copy
large amount of data over its IPC. And that is purely for performance
reason and memory constraints. However it is actually an implementation
detail since D-Bus as of now uses Unix sockets underneath. Switching to
shared memory or implementing dbus-daemon as AF_DBUS inside the kernel
would solve these.

For the problem of not being able to pass file descriptors over D-Bus we
have patches that are currently under review and are most likely to get
merged for the next release. This would also remove the limitation of
the direct data communication since you could just give the file
descriptor of the data plane to the other process.

> If for instance the main reason for Google using this interface is cause
> a large number of android people once worked at Palm or BeOS, that's not
> reason enough for it to go into the kernel. Or if this binder interface
> really fits well with Java or C++ people and they just love it, that's
> not really acceptable either..

It is a Google only thing. Everybody else uses D-Bus and is actually
happy with it.

Regards

Marcel


