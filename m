Return-Path: <linux-kernel-owner+w=401wt.eu-S1753294AbZFFAlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294AbZFFAlX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 20:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753018AbZFFAlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 20:41:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53292 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813AbZFFAlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 20:41:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 17/39] kbuild: fix header export when __ASSEMBLY__ is used
Date: Sat, 6 Jun 2009 00:41:07 +0000
User-Agent: KMail/1.11.2 (Linux/2.6.29; KDE/4.2.2; x86_64; ; )
Cc: "linux-kbuild" <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>
References: <20090605233720.GA13588@uranus.ravnborg.org> <1244245377-17441-17-git-send-email-sam@ravnborg.org>
In-Reply-To: <1244245377-17441-17-git-send-email-sam@ravnborg.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906060041.07600.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+Jh6w8j0ICP7axBnatP8AWIStwXGDV379VlyS
 gnfkwAsmcNgIciOFnRANNqxO5irMqiyKS09lUDiSaGoXrjgczG
 NWBH1TTPhsc9yaoaSQ6Ww==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 June 2009 11:42:35 pm Sam Ravnborg wrote:
> Because it does not know __ASSEMBLY__ it does not
> detect that htis is not for userspace.
> This caused too much code to be exported, and headers_check barfed
> over this code.
> 
> For arm this fixes following "make headers_check" warning:
> /usr/include/asm/hwcap.h:29: extern's make no sense in userspace

Are you sure that this is safe for all user space? If a user application
for instance includes asm/signal.h or asm/types.h from assembly (for
whatever reason), it now breaks.

I can't think of a good reason why anyone would do such a thing,
but it used to be possible.

	Arnd <><
