Return-Path: <linux-kernel-owner+w=401wt.eu-S1763152AbYBBC5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763152AbYBBC5B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 21:57:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757601AbYBBC4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 21:56:54 -0500
Received: from senator.holtmann.net ([87.106.208.187]:41036 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107AbYBBC4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 21:56:53 -0500
Subject: Re: Build error on PowerPC
From: Marcel Holtmann <marcel@holtmann.org>
To: Olof Johansson <olof@lixom.net>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080201232741.GA7853@lixom.net>
References: <1201866279.6218.187.camel@violet>
	 <20080201232741.GA7853@lixom.net>
Content-Type: multipart/mixed; boundary="=-wiTT3sC9lAuhsB1SBgl6"
Date: Sat, 02 Feb 2008 03:57:07 +0100
Message-Id: <1201921027.15090.28.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-wiTT3sC9lAuhsB1SBgl6
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Olof,

> Please define what kernel version and what config you're trying to
> build.

it is the latest kernel for Linus' git and the config is kinda obviously
enabling the awacs.c driver. Anyway, the driver didn't make use of the
NVRAM call and thus removing that include is perfectly fine. Attached
patch fixes that issue.

> Also, please cc linuxppc-dev@ozlabs.org for powerpc issues.

To be quite honest, it is highly likely that I forget the next time.
Good that you read LKML :)

Regards

Marcel


--=-wiTT3sC9lAuhsB1SBgl6
Content-Disposition: attachment; filename=patch
Content-Type: text/plain; name=patch; charset=utf-8
Content-Transfer-Encoding: 8bit

[PATCH] Fix compilation of sound/ppc/awacs.c

Including of asm/nvram.h in the awacs.c driver is not needed and it
fixes the following compilation error:

  CC [M]  sound/ppc/awacs.o
In file included from sound/ppc/awacs.c:25:
include/asm/nvram.h:62: error: field ‘partition’ has incomplete type
make[2]: *** [sound/ppc/awacs.o] Error 1
make[1]: *** [sound/ppc] Error 2
make: *** [sound] Error 2

Signed-off-by: Marcel Holtmann <marcel@holtmann.org>

---
commit 5613f9f9aa321cf59915137cc611aea9fd95ed75
tree 3c55137ccc3d16e49b757a0e6135f32fb2086ae3
parent aa6299926950c8dfe2fea638276cad6def092bc9
author Marcel Holtmann <marcel@holtmann.org> Sat, 02 Feb 2008 03:52:23 +0100
committer Marcel Holtmann <marcel@holtmann.org> Sat, 02 Feb 2008 03:52:23 +0100

 sound/ppc/awacs.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/sound/ppc/awacs.c b/sound/ppc/awacs.c
index 8441e78..149c4aa 100644
--- a/sound/ppc/awacs.c
+++ b/sound/ppc/awacs.c
@@ -21,7 +21,6 @@
 
 
 #include <asm/io.h>
-#include <asm/nvram.h>
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/slab.h>

--=-wiTT3sC9lAuhsB1SBgl6--

