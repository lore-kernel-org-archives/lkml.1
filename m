Return-Path: <linux-kernel-owner+w=401wt.eu-S1750719AbXCCXFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750719AbXCCXFj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 18:05:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750712AbXCCXFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 18:05:39 -0500
Received: from moutng.kundenserver.de ([212.227.126.179]:49922 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbXCCXFi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 18:05:38 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: bert hubert <bert.hubert@netherlabs.nl>
Subject: Re: [PATCH -mm 1/5] Blackfin: blackfin architecture patch update
Date: Sun, 4 Mar 2007 00:05:37 +0100
User-Agent: KMail/1.9.6
Cc: bryan.wu@analog.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <1172722480.5264.75.camel@roc-desktop> <200703032330.50116.arnd@arndb.de> <20070303225002.GB28961@outpost.ds9a.nl>
In-Reply-To: <20070303225002.GB28961@outpost.ds9a.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703040005.38189.arnd@arndb.de>
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:bf0b512fe2ff06b96d9695102898be39
X-Provags-ID2: V01U2FsdGVkX1/MgFKUI35l4Zu2REVGW4iiCiJa3wTTEoxoYU6
 HeK7TfMnzQqbdPczuuFMFuCtxcP5OpBBSXoUE1Y8WXorsh560u
 MXgQR9Q2Bm34ulIxrJ7VQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 March 2007 23:50:02 bert hubert wrote:
> >       for (;;)
> >               asm volatile ("idle");
>
> This looks remarkably like relax_cpu()

Actually not: cpu_relax() is defined as barrier(), it can't
call idle because that might make it sleep for a indefinite
amount of time (until the next interrupt, but only if they
are enabled).

Some nice architectures provide a hardware mechanism to do
cpu_relax, like going to low-power mode for a few microseconds,
but this one doesn't seem to have it.

	Arnd <><
