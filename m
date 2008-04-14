Return-Path: <linux-kernel-owner+w=401wt.eu-S1758690AbYDNBA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690AbYDNBA0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 21:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754353AbYDNBAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 21:00:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:49316 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709AbYDNBAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 21:00:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Davide Libenzi <davidel@xmailserver.org>
Subject: Re: [patch] F_GETPATH for linux
Date: Mon, 14 Apr 2008 03:00:05 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>
References: <Pine.LNX.4.64.0804131455030.12741@alien.or.mcafeemobile.com>
In-Reply-To: <Pine.LNX.4.64.0804131455030.12741@alien.or.mcafeemobile.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804140300.05719.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18tYm/O86lp2Js5Pg+3bVGhkowUI1KOHAQkv+Q
 iHRYsv6623A0jXU/7onySWYWpbMQl1cTTMZBGUqtbYM0ehpjpd
 ArhsEeoVSSy6pvKLU8jWw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 April 2008, Davide Libenzi wrote:
> I was working on some bsd/linux compatibility code, and I noticed that we 
> do not have F_GETPATH. I know we can readlink /proc/PID/fd/FD (that is 
> what I'm doing now, under #ifdef), but I gave a patch a shot anyway.
> Here it is, building but untested ...
 
I reviewed the code path for compat_sys_fcntl{,64} for this patch, looks
good in that respect.

> +error:
> +	free_page((unsigned long) buf);
> +	return size;
> +}
> +EXPORT_SYMBOL(fcntl_getpath);
> +

Procfs cannot be a module, and there are no other users of this function,
so why do you export it?

	Arnd <><
