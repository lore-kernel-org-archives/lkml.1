Return-Path: <linux-kernel-owner+w=401wt.eu-S1759200AbYABAfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759200AbYABAfh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 19:35:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756242AbYABAf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 19:35:28 -0500
Received: from moutng.kundenserver.de ([212.227.126.183]:62497 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857AbYABAf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 19:35:27 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] [2.6.24] Add PPC nvram ioctls to compat_ioctl
Date: Wed, 2 Jan 2008 01:34:41 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Olof Johansson <olof@lixom.net>, paulus@samba.org,
       linux-kernel@vger.kernel.org
References: <20071231224558.GA16517@lixom.net>
In-Reply-To: <20071231224558.GA16517@lixom.net>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801020134.41761.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18O6ysTPTixBKJneQ5Nz5g6k5o3eHV1BMLeR+F
 hq+32EvR7w3T9LlvOeb5gyuYr/8lT3QNQGPWtosQ+TQw3Nqlph
 8QeQ9K78i3h3AYOhB2/8A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 31 December 2007, Olof Johansson wrote:
> Fix the following console warning when running 'nvsetenv', and makes
> setting of new variables work again:
> 
> ioctl32(nvsetenv:4022): Unknown cmd fd(3) cmd(20007043){t:'p';sz:0}
> arg(00000003) on /dev/nvram
> 
> That's the IOC_NVRAM_SYNC call.
> 
> 
> Signed-off-by: Olof Johansson <olof@lixom.net>
> 
> diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
> index e8b7c3a..7be6765 100644
> --- a/fs/compat_ioctl.c
> +++ b/fs/compat_ioctl.c

Please don't. I have this long-term plan of getting rid of fs/compat_ioctl.c,
the better answer is to convert arch/powerpc/kernel/nvram_64.c and
drivers/char/generic_nvram.c from the .ioctl file_operation to
.unlocked_ioctl/.compat_ioctl.

	Arnd <><
