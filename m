Return-Path: <linux-kernel-owner+w=401wt.eu-S1756325AbZFTIVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325AbZFTIVf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 04:21:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756129AbZFTIVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 04:21:08 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:59811 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbZFTIVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 04:21:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [patch] ipc: unbreak 32-bit shmctl/semctl/msgctl
Date: Sat, 20 Jun 2009 08:20:56 +0000
User-Agent: KMail/1.11.2 (Linux/2.6.29; KDE/4.2.2; x86_64; ; )
Cc: Michal Simek <monstr@monstr.eu>, microblaze-uclinux@itee.uq.edu.au,
       LKML <linux-kernel@vger.kernel.org>,
       Remis Lima Baima <remis.developer@googlemail.com>
References: <cover.1245345894.git.arnd@arndb.de> <200906190031.17786.arnd@arndb.de> <20090620010939.GA3469@cmpxchg.org>
In-Reply-To: <20090620010939.GA3469@cmpxchg.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906200820.56707.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18Z0fYfMyYjpjExncZqIQWqlEhKyLjreEsIHvt
 Wjk1MIOhUy4EHaY80nGdSTxVHMtJjEB5DjCs9DOyo164geSiVJ
 5DkJuNT5ukCtiZi8Dcjyw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 20 June 2009 01:09:39 am Johannes Weiner wrote:
> 31a985f "ipc: use __ARCH_WANT_IPC_PARSE_VERSION in ipc/util.h" would
> choose the implementation of ipc_parse_version() based on a symbol
> defined in <asm/unistd.h>.
> 
> But it failed to also include this header and thus broke
> IPC_64-passing 32-bit userspace because the flag wasn't masked out
> properly anymore and the command not understood.
> 
> Include <linux/unistd.h> to give the architecture a chance to ask for
> the no-no-op ipc_parse_version().
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>

Obviously fixes the bug I introduced, sorry for the trouble and thanks
for fixing it!
