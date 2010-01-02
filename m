Return-Path: <linux-kernel-owner+w=401wt.eu-S1752743Ab0ABPL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743Ab0ABPL5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 10:11:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609Ab0ABPL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 10:11:56 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:47502 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab0ABPLz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 10:11:55 -0500
From: Oliver Neukum <oliver@neukum.org>
To: =?utf-8?q?Bart=C5=82omiej_Zimo=C5=84?= <uzi18@o2.pl>
Subject: Re: [suspend/resume] Re: userspace notification from module
Date: Sat, 2 Jan 2010 16:11:52 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <686edb2c.6263643a.4b3f4a3b.b60b3@o2.pl> <4B3F5264.7000008@gmail.com> <58607309.1e2f721f.4b3f57c0.807d3@o2.pl>
In-Reply-To: <58607309.1e2f721f.4b3f57c0.807d3@o2.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201001021611.52672.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 2. Januar 2010 15:27:12 schrieb Bartłomiej Zimoń:
> > Register your pids to the kernel module, e.g. via ioctl, and if the
> > (intra-kernel) notification will be delivered to your module you just
> > send a signal to your registered processes via kill_proc_info(). Guess
> > this is at least better than polling a file or sth similar.
> > 
> > I guess netlink could be the "cleaner" solution, but with more overhead?!
> > 
> 
> This looks like more simple and could be good, after all i think about sending this 
> module here to add to kernel. So if this solution could be ok i will start to code this part.

This has all sorts of implications starting with fork() and going to passing
fds over sockets and so on. It is a very bad idea. Use a standard device
and all infrastructure for getting SIGIO is in place.

	Regards
		Oliver
