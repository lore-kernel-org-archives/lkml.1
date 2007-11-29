Return-Path: <linux-kernel-owner+w=401wt.eu-S1761472AbXK2A6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761472AbXK2A6R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 19:58:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753112AbXK2A6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 19:58:05 -0500
Received: from moutng.kundenserver.de ([212.227.126.188]:62066 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757285AbXK2A6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 19:58:04 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.24-rc3-mm2 - Build Failure on powerpc timerfd() undeclared
Date: Thu, 29 Nov 2007 01:57:51 +0100
User-Agent: KMail/1.9.6
Cc: linuxppc-dev@ozlabs.org, Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Michael Kerrisk <mtk-manpages@gmx.net>
References: <20071128034140.648383f0.akpm@linux-foundation.org> <200711281432.09178.arnd@arndb.de> <20071128104345.9474025e.akpm@linux-foundation.org>
In-Reply-To: <20071128104345.9474025e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711290157.52487.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18TSoKOQDgIRMS4a13UVRJYk9AxYafwM9pUSf6
 ROkYX0L5vru7EgDOEPcoc/2kygVrS7R0bBhgxiTb27rPLM0m/Z
 XvAv1cJy0/e2qoNzHlGmA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 November 2007 19:43:45 Andrew Morton wrote:
> > I guess all architectures except x86 are currently broken because they
> > reference the old sys_timerfd function.
>
> None of them were broken in my testing and I'm unsure why powerpc broke
> here.

PowerPC is unique in that it actually relies on the declarations
in include/{linux,asm}/syscalls.h to be present, because the
spu_syscall_table is generated from C code, not from assembly.
One reason why I did this was to be sure to find this exact
type of problem at compile-time, not at link time.

	Arnd <><
