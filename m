Return-Path: <linux-kernel-owner+w=401wt.eu-S1753878AbZHGQGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878AbZHGQGi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 12:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753751AbZHGQGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 12:06:38 -0400
Received: from mail-yw0-f177.google.com ([209.85.211.177]:51721 "EHLO
	mail-yw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523AbZHGQGh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 12:06:37 -0400
MIME-Version: 1.0
In-Reply-To: <4A7C4D6C.6050101@nortel.com>
References: <20090805171513.GA10443@kroah.com> <200908070703.40706.a1426z@gawab.com> 
	<20090807042544.GA24299@kroah.com> <200908070804.08156.a1426z@gawab.com> 
	<20090807052015.GA24615@kroah.com> <4A7C4D6C.6050101@nortel.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 7 Aug 2009 18:06:15 +0200
Message-ID: <ac3eb2510908070906v147e07a3h86b266ffc2224b08@mail.gmail.com>
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based 
	/dev
To: Chris Friesen <cfriesen@nortel.com>
Cc: Greg KH <greg@kroah.com>, Al Boldi <a1426z@gawab.com>,
       Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, Jan Blunck <jblunck@suse.de>,
       gregkh@suse.de, Harald Hoyer <harald@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 7, 2009 at 17:51, Chris Friesen<cfriesen@nortel.com> wrote:
> Greg KH wrote:
>> On Fri, Aug 07, 2009 at 08:04:08AM +0300, Al Boldi wrote:
>
>>> The question is, how fast can devtmpfs get the device list from the kernel on
>>> bootup?  How much faster than udev?  How much slower than static /dev?
>>
>> It's much faster than udev, and is equivalent to a static /dev with the
>> exception that the group and permission settings that you are used to.
>> udev then needs to come along and make those settings, but that's so
>> frickin fast it's amazing.
>
> Earlier in the thread you indicated a 0.5sec speedup over udev.  Is that
> really considered "much faster"?

The kernel boots up and mounts the root filesystem in less than a
second these days. :)

> I do agree that it makes sense to do this, but more from an elegance
> view than a performance one.

That's right. The possible speedups are mainly a side-effect of the
simplicity we get by having the kernel providing us the the nodes
without having hard userspace synchronization points early at bootup.

The init=/bin/sh with a fully working and correctly, regarding the
dynamic major/minor numbers, populated /dev is alone reason enough to
do that, I think.

Also things like "modprobe loop; losetup /dev/loop0" will just work,
which do not work reliably today without waiting for userspace to
create the nodes.

Kay
