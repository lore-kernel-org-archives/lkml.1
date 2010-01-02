Return-Path: <linux-kernel-owner+w=401wt.eu-S1752686Ab0ABO1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686Ab0ABO1P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 09:27:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570Ab0ABO1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 09:27:15 -0500
Received: from mailout1.go2.pl ([193.17.41.11]:43885 "EHLO mailout1.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752569Ab0ABO1O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 09:27:14 -0500
Subject: =?UTF-8?Q?[suspend/resume]_Re:_userspace_notification_from_module?=
From: =?UTF-8?Q?Bart=C5=82omiej_Zimo=C5=84?= <uzi18@o2.pl>
To: linux-kernel@vger.kernel.org
In-Reply-To: <4B3F5264.7000008@gmail.com>
References: <686edb2c.6263643a.4b3f4a3b.b60b3@o2.pl> <4B3F5264.7000008@gmail.com>
Mime-Version: 1.0
Message-ID: <58607309.1e2f721f.4b3f57c0.807d3@o2.pl>
Date: Sat, 02 Jan 2010 15:27:12 +0100
X-Originator: 83.12.131.34
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dnia 2 stycznia 2010 15:04 	Daniel Borkmann <danborkmann@googlemail.com> napisał(a):
> Hi Bartłomiej,
> 
> Bartłomiej Zimoń wrote:
> > Dnia 2 stycznia 2010 13:36 	Daniel Borkmann <llug.dan@googlemail.com> napisał(a):
> > I will explain more what i'm going to do.
> > The idea is simple. Kernel before suspend/resume sends notification to 
> > registered kernel objects. So i have written small module to register
> > there and want now pass these data to /dev/file. It is 1byte so not a big deal.
> > 
> > I'm searching now for notification about new byte in buffer, as it is almost 
> > clear for async: http://www.xml.com/ldd/chapter/book/ch05.html#t4
> > but for sync still haven't find.
> 
> This sounds very interesting... a "hack" could be the following:
> 
> Register your pids to the kernel module, e.g. via ioctl, and if the
> (intra-kernel) notification will be delivered to your module you just
> send a signal to your registered processes via kill_proc_info(). Guess
> this is at least better than polling a file or sth similar.
> 
> I guess netlink could be the "cleaner" solution, but with more overhead?!
> 

This looks like more simple and could be good, after all i think about sending this 
module here to add to kernel. So if this solution could be ok i will start to code this part.

Question is now what signal to choose to not terminate process and to be compatible 
with rest of Linux kernel?

Best regards
Bartłomiej Zimoń

