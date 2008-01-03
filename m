Return-Path: <linux-kernel-owner+w=401wt.eu-S1753205AbYACU3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbYACU3l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 15:29:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751622AbYACU3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 15:29:32 -0500
Received: from fmmailgate04.web.de ([217.72.192.242]:42496 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbYACU3c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 15:29:32 -0500
Date: Thu, 03 Jan 2008 21:29:30 +0100
Message-Id: <84315412@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: Miquel van Smoorenburg <miquels@cistron.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: serial console _after_ boot ? - was: Redirect kernel console
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX18sOor476mdzHe2q3mvhCLpuHHTeNLpAqPwYXsrb9LfEZ6ei
 2p9MNjElztUCKEsRrlWbm6RFuNCj0YwxlW47PjM9MhYlUVe/f8=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>i was wondering how to make kernel messages appear on /dev/ttyS0
>>without a reboot, i.e. kernelparam "console=ttyS0"
>>
>>The solution is simple... the following piece of code is inside
>>opensuse-10.3/src/sysvinit-2.86-115.src.rpm#showconsole-1.08.tar.bz2#showconsole-1.08/blogd.c
>>
>>    (void)ioctl(0, TIOCCONS, NULL);  /* Undo any current map if any */
>>    if (ioctl(pts, TIOCCONS, NULL) < 0)
>>        error("can not set console device to %s: %s\n", ptsname,
>>strerror(errno));
>>
>>so I suppose that's it. Write up a new program that calls the ioctl
>>on a tty, and you should be done. IOW:
>
>TIOCCONS only works for pseudo terminals.
>
>Besides, it only redirects stuff you send to /dev/console. It
>doesn't change what devices printk() prints to. Currently there
>is no way to change that on a running kernel.
>
>Mike.

too bad, but thanks for the info.
_______________________________________________________________________
Jetzt neu! Schützen Sie Ihren PC mit McAfee und WEB.DE. 30 Tage
kostenlos testen. http://www.pc-sicherheit.web.de/startseite/?mc=022220

