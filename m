Return-Path: <linux-kernel-owner+w=401wt.eu-S1753600AbYACSOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600AbYACSOy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 13:14:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752036AbYACSOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 13:14:46 -0500
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4612 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbYACSOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 13:14:45 -0500
X-Greylist: delayed 1180 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jan 2008 13:14:44 EST
From: "Miquel van Smoorenburg" <miquels@cistron.nl>
Subject: Re: serial console _after_ boot ? - was: Redirect kernel console
References: <83531397@web.de> <Pine.LNX.4.64.0801031423070.26693@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: mikevs@n2o.xs4all.nl (Miquel van Smoorenburg)
Date: 03 Jan 2008 17:55:02 GMT
Message-ID: <477d2176$0$85788$e4fe514c@news.xs4all.nl>
X-Trace: 1199382902 news.xs4all.nl 85788 [::ffff:194.109.0.112]:45221
X-Complaints-To: abuse@xs4all.nl
In-Reply-To: <Pine.LNX.4.64.0801031423070.26693@fbirervta.pbzchgretzou.qr>
To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In article <Pine.LNX.4.64.0801031423070.26693@fbirervta.pbzchgretzou.qr>,
Jan Engelhardt  <jengelh@computergmbh.de> wrote:
>
>On Jan 3 2008 13:43, devzero@web.de wrote:
>>
>>hi !
>>
>>i was wondering how to make kernel messages appear on /dev/ttyS0
>without a reboot, i.e. kernelparam "console=ttyS0"
>
>The solution is simple... the following piece of code is inside
>opensuse-10.3/src/sysvinit-2.86-115.src.rpm#showconsole-1.08.tar.bz2#showconsole-1.08/blogd.c
>
>    (void)ioctl(0, TIOCCONS, NULL);  /* Undo any current map if any */
>    if (ioctl(pts, TIOCCONS, NULL) < 0)
>        error("can not set console device to %s: %s\n", ptsname,
>strerror(errno));
>
>so I suppose that's it. Write up a new program that calls the ioctl
>on a tty, and you should be done. IOW:

TIOCCONS only works for pseudo terminals.

Besides, it only redirects stuff you send to /dev/console. It
doesn't change what devices printk() prints to. Currently there
is no way to change that on a running kernel.

Mike.
