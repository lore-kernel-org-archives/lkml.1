Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093Ab0CCLfX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 06:35:23 -0500
Received: from gw1.transmode.se ([213.115.205.20]:36315 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195Ab0CCLfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 06:35:22 -0500
In-Reply-To: <20100302234217.9eaa7c5e.akpm@linux-foundation.org>
References: <1267373163-10841-1-git-send-email-Joakim.Tjernlund@transmode.se>	<20100302145231.5f3f0fb0.akpm@linux-foundation.org>
	<OFA6036938.9580602E-ONC12576DB.00293497-C12576DB.0029B6AE@transmode.se> <20100302234217.9eaa7c5e.akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] inflate_fast: sout is already a short so ptr arith was off
 by one.
X-KeepSent: 983BCF5A:53EB692D-C12576DB:003F7289;
 type=4; name=$KeepSent
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
X-Mailer: Lotus Notes Release 8.5.1 September 28, 2009
Message-ID: <OF983BCF5A.53EB692D-ONC12576DB.003F7289-C12576DB.003FA53F@transmode.se>
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Wed, 3 Mar 2010 12:35:10 +0100
X-MIMETrack: Serialize by Router on sesr04/Transmode(Release 8.5.1|September 28, 2009) at
 2010-03-03 12:35:20
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote on 2010/03/03 08:42:17:
>
> On Wed, 3 Mar 2010 08:35:37 +0100 Joakim Tjernlund
> <joakim.tjernlund@transmode.se> wrote:
>
> > Andrew Morton <akpm@linux-foundation.org> wrote on 2010/03/02 23:52:31:
> > >
> > > redo the patch, add a changelog which helps non-inffast.c people
> > > understand what it does, then resend?
> >
> > Not old, too new actually. You are sitting on a patch from me named
> >  zlib: Make new optimized inflate endian independent
> > that was deferred to 2.6.34.
> > This patch is on top of that one.
>
> oh, I missed that.
>
> > What should I do now?
>
> Resending is never wrong ;)

How about this then(on top of zlib: Make new optimized inflate endian independent):

>From b3d08e29130e0368d4c8eede568c4c7ac4df66ae Mon Sep 17 00:00:00 2001
From: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Date: Mon, 15 Feb 2010 17:51:58 +0100
Subject: [PATCH 1/2] inflate_fast: sout is already a short so ptr arith was off by one.

inflate_fast() can do either POST INC or PRE INC on its
pointers walking the memory to decompress. Default is
PRE INC.
The sout pointer offset was miscalculated in one case as
the calculation assumed sout was a char *
This breaks inflate_fast() iff configured to do POST INC.

Signed-off-by: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
---
 lib/zlib_inflate/inffast.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/zlib_inflate/inffast.c b/lib/zlib_inflate/inffast.c
index fa62fc7..2c13ecc 100644
--- a/lib/zlib_inflate/inffast.c
+++ b/lib/zlib_inflate/inffast.c
@@ -286,7 +286,7 @@ void inflate_fast(z_streamp strm, unsigned start)
 		    } else { /* dist == 1 or dist == 2 */
 			unsigned short pat16;

-			pat16 = *(sout-2+2*OFF);
+			pat16 = *(sout-1+OFF);
 			if (dist == 1) {
 				union uu mm;
 				/* copy one char pattern to both bytes */
--
1.6.4.4


