Return-Path: <linux-kernel-owner+w=401wt.eu-S1753331AbZI0Q6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331AbZI0Q6X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 12:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753183AbZI0Q6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 12:58:22 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:59460 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131AbZI0Q6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 12:58:22 -0400
From: arnd@arndb.de
To: Bernard Pidoux <bernard.pidoux@upmc.fr>
Subject: Re: 2.6.31.1 BUG #include <asm/bitsperlong.h>
Date: Sun, 27 Sep 2009 16:58:18 +0000
User-Agent: KMail/1.11.2 (Linux/2.6.29; KDE/4.2.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de
References: <4ABF4E36.4090703@upmc.fr>
In-Reply-To: <4ABF4E36.4090703@upmc.fr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200909271658.18646.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19tNwaqFGQEvZ/L7yGHpRu6ZLJmQ3QUhqh3XMZ
 sNAk3m2WKnVP6gtTtez3s+GR5bkZO4HQ7MmeiqsFojXVvRe/Ps
 x93Ehgv9T9J7GSc6llfwQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 September 2009 11:36:22 Bernard Pidoux wrote:
> gcc -Wall -Wstrict-prototypes -O2 -ggdb2 -funsigned-char  -D__LINUX__ -Wformat-security -D_FORTIFY_SOURCE=2 -DPROTOTYPES -I../lib -I/usr/src/linux/include -fstack-check -fstack-protector-all -c listen.c
> Dans le fichier inclus à partir de /usr/include/asm/types.h:4,
>           à partir de /usr/src/linux/include/linux/types.h:4,
>           à partir de /usr/src/linux/include/linux/if_ether.h:24,
>           à partir de /usr/include/net/ethernet.h:27,
>           à partir de listen.c:21:
> /usr/src/linux/include/asm-generic/int-ll64.h:11:29: erreur: asm/bitsperlong.h : Aucun fichier ou dossier de ce type
> listen.c: In function ‘main’:
> 

The problem is the '-I/usr/src/linux/include' part of the gcc command line.
See http://kernelnewbies.org/KernelHeaders for why this is wrong.
You should notify the maintainer of the package to fix this by removing
this option. The headers in /usr/include/ are sufficient to build user
code.

	Arnd <><
