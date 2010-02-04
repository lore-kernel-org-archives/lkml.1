Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757033Ab0BDHle (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 02:41:34 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:53277 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755908Ab0BDHlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 02:41:32 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 4/6] improve sys_personality for compat architectures
Date: Thu, 4 Feb 2010 08:38:10 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: David Miller <davem@davemloft.net>, hch@lst.de, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       tony.luck@intel.com, ralf@linux-mips.org, kyle@mcmartin.ca,
       benh@kernel.crashing.org, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, tglx@linutronix.de, mingo@redhat.com,
       viro@zeniv.linux.org.uk
References: <201002021536.51928.arnd@arndb.de> <20100203.091309.52886984.davem@davemloft.net> <4B69D6BA.4030704@zytor.com>
In-Reply-To: <4B69D6BA.4030704@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002040838.10783.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19JcEocNyeu78QIOal6g/DOcKkVGz0u+FK+eGt
 wDLdN2atJRvuAR/O7vwbpIuOK7zLF6lEhHVaVTppBJ7uttk12p
 +t33c8gmYEaxDWrUdcUfQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 February 2010, H. Peter Anvin wrote:
> The x86 method of simply not bothering doesn't seem to have caused
> problems -- our compat (and noncompat) tasks happily return PER_LINUX32
> if that is the mode and we don't seem to have had complaints with it.
> If userspace ever had an issue with it -- and they might have, at one
> point in history libc used to call personality() during startup, which
> it doesn't seem to anymore -- they presumably have worked through it.
> 
> As such, I'm more than a little reluctant to change the current behavior.

I think it would be better to have a consistent behavior across
architectures, so /something/ should be changed. On x86, the unused
sys32_personality function can probable just be removed, if nothing
else.

If we can get everyone to agree with the x86 way of handling this,
we can also remove all the special cases for sys32_personality in the
other architectures.

	Arnd
