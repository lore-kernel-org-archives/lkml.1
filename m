Return-Path: <linux-kernel-owner+w=401wt.eu-S1752038Ab0ABVU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038Ab0ABVU6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 16:20:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821Ab0ABVU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 16:20:57 -0500
Received: from mailout1.go2.pl ([193.17.41.11]:46465 "EHLO mailout1.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810Ab0ABVU5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 16:20:57 -0500
Subject: =?UTF-8?Q?Re:_[suspend/resume]_Re:_userspace_notification_from_module?=
From: =?UTF-8?Q?Bart=C5=82omiej_Zimo=C5=84?= <uzi18@o2.pl>
To: =?UTF-8?Q?Andy_Walls?= <awalls@radix.net>,
       =?UTF-8?Q?Daniel_Borkmann?= <danborkmann@googlemail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <ddef1cf.2c9460e3.4b3f8fd5.c10cd@o2.pl>
References: <686edb2c.6263643a.4b3f4a3b.b60b3@o2.pl> <1262446824.3058.11.camel@palomino.walls.org> <6f52f5b81001020756i73fbb137if1af8ac8b306f6ba@mail.gmail.com> <ddef1cf.2c9460e3.4b3f8fd5.c10cd@o2.pl>
Mime-Version: 1.0
Message-ID: <3dddb933.4b66c78e.4b3fb8b7.288a6@o2.pl>
Date: Sat, 02 Jan 2010 22:20:55 +0100
X-Originator: 83.10.186.148
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dnia 2 stycznia 2010 19:26 	Bartłomiej Zimoń <uzi18@o2.pl> napisał(a):
> Dnia 2 stycznia 2010 16:56 	Daniel Borkmann <danborkmann@googlemail.com> napisał(a):
> > Hi Andy,
> > 
> > 2010/1/2 Andy Walls <awalls@radix.net>:
> > > Why not:
> > >
> > > a. write a module that implements a device node that supports poll(),
> > > and
> > >
> > > b. have a user space process select() on the fd for read or exception
> > > notification
> > >
> > > ?
> > 
> > This is, of course, another possible solution that is more "cleaner"
> > than the one with the signals.
> > Then, your userspace program would have another thread polling for the
> > device node. Question is which timeout would be appropriate to be "CPU
> > friendly" and to keep notification latency short?
> > 
> 
> Just need as fast as possible solution and on the other hand acceptable for kernel sources.
> Usually programs needs just to disconnect something or set one flag.
> Even if program will have no time for this it could be enough just to send this precious info.
> 

first draft: http://starowa.one.pl/~uzi/pld/pm-notify.c

# tail -f /var/log/kernel |grep pm-notify
Jan  2 21:37:19 topijna kernel: pm-notify: suspend prepare
Jan  2 21:38:18 topijna kernel: pm-notify: suspend prepare
Jan  2 21:39:05 topijna kernel: pm-notify: suspend prepare
Jan  2 21:43:38 topijna kernel: pm-notify: suspend prepare
Jan  2 21:51:31 topijna kernel: pm-notify: suspend prepare
Jan  2 21:53:59 topijna kernel: pm-notify: hibernation prepare

But dont know why have loop here:

$ hexdump /dev/test
0000000 0033 0000 0033 0000 0033 0000 0033 0000
*
31424480 0033 0000 0033 0000 0031 0000 0031 0000
31424490 0031 0000 0031 0000 0031 0000 0031 0000
*
$

Best regards.
Barłomiej Zimoń
PLD Linux, Kadu Team

