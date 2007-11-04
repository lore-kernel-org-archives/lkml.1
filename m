Return-Path: <linux-kernel-owner+w=401wt.eu-S1758635AbXKDO4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758635AbXKDO4R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 09:56:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755946AbXKDO4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 09:56:00 -0500
Received: from hobbit.corpit.ru ([81.13.94.6]:24479 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755892AbXKDOz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 09:55:59 -0500
Message-ID: <472DDD78.7040002@msgid.tls.msk.ru>
Date: Sun, 04 Nov 2007 17:55:52 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Icedove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: 2.6.23.1: mdadm/raid5 hung/d-state
References: <Pine.LNX.4.64.0711040658180.30831@p34.internal.lan> <472DBF8C.2060508@msgid.tls.msk.ru> <Pine.LNX.4.64.0711040750020.3956@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0711040750020.3956@p34.internal.lan>
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
> On Sun, 4 Nov 2007, Michael Tokarev wrote:
[]
>> The next time you come across something like that, do a SysRq-T dump and
>> post that.  It shows a stack trace of all processes - and in particular,
>> where exactly each task is stuck.

> Yes I got it before I rebooted, ran that and then dmesg > file.
> 
> Here it is:
> 
> [1172609.665902]  ffffffff80747dc0 ffffffff80747dc0 ffffffff80747dc0 ffffffff80744d80
> [1172609.668768]  ffffffff80747dc0 ffff81015c3aa918 ffff810091c899b4 ffff810091c899a8

That's only partial list.  All the kernel threads - which are most important
in this context - aren't shown.  You ran out of dmesg buffer, and the most
interesting entries was at the beginning.  If your /var/log partition is
working, the stuff should be in /var/log/kern.log or equivalent.  If it's
not working, there is a way to capture the info still, by stopping syslogd,
cat'ing /proc/kmsg to some tmpfs file and scp'ing it elsewhere.

/mjt
