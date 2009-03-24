Return-Path: <linux-kernel-owner+w=401wt.eu-S1756158AbZCXSkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158AbZCXSkG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 14:40:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754299AbZCXSjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 14:39:55 -0400
Received: from smtp131.sat.emailsrvr.com ([66.216.121.131]:36270 "EHLO
	smtp131.sat.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017AbZCXSjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 14:39:54 -0400
X-Greylist: delayed 516 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Mar 2009 14:39:54 EDT
From: "Christopher Harrer" <charrer@alacritech.com>
To: "'Lior Dotan'" <liodot@gmail.com>, <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>
References: <4992B7EE.8020601@gmail.com>
Subject: RE: [PATCH]  SLICOSS - use gfp_kernel where possible
Date: Tue, 24 Mar 2009 14:31:14 -0400
Message-ID: <019E07F7ABD24C5A9F79702ADD7F8230@exton.alacritech.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0004_01C9AC8D.305FF110"
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <4992B7EE.8020601@gmail.com>
Thread-Index: AcmMPMbrEGqCKe6uSRK9WNnzd3AKOggcciow
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_0004_01C9AC8D.305FF110
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

> -----Original Message-----
> From: Lior Dotan [mailto:liodot@gmail.com] 
> Sent: Wednesday, February 11, 2009 6:35 AM
> To: gregkh@suse.de
> Cc: Christopher Harrer; linux-kernel@vger.kernel.org
> Subject: [PATCH] SLICOSS - use gfp_kernel where possible
> 
> Use GFP_KERNEL instead of GFP_ATOMIC where possible.
> 
> Signed_off-by: Lior Dotan <liodot@gmail.com>
> 
> 
> 
Hi Greg,

In speaking with Lior, would it be possible to revert this patch?  It's
causing:

> Mar 24 11:50:31 linuxdev kernel: BUG: sleeping function called from 
> invalid context at mm/slub.c:1599 Mar 24 11:50:31 linuxdev kernel: 
> in_atomic(): 1, irqs_disabled(): 0, pid:
> 3251, name: avahi-daemon

Please let me know if you need any additional information or have any
questions.

Cheers,

Chris

------=_NextPart_000_0004_01C9AC8D.305FF110
Content-Type: application/octet-stream;
	name="slicoss-gfp-kernel.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="slicoss-gfp-kernel.patch"

diff -X /usr/src/linux/Documentation/dontdiff -purN =
a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
--- a/drivers/staging/slicoss/slicoss.c	2009-02-11 13:33:18.000000000 =
+0200
+++ b/drivers/staging/slicoss/slicoss.c	2009-02-11 13:32:53.000000000 =
+0200
@@ -1492,7 +1492,7 @@ static int slic_mcast_add_list(struct ad
 	}
=20
 	/* Doesn't already exist.  Allocate a structure to hold it */
-	mcaddr =3D kmalloc(sizeof(struct mcast_address), GFP_ATOMIC);
+	mcaddr =3D kmalloc(sizeof(struct mcast_address), GFP_KERNEL);
 	if (mcaddr =3D=3D NULL)
 		return 1;
=20
@@ -2648,7 +2648,7 @@ static int slic_card_init(struct sliccar
=20
 #if SLIC_DUMP_ENABLED
 	if (!card->dumpbuffer) {
-		card->dumpbuffer =3D kmalloc(DUMP_PAGE_SIZE, GFP_ATOMIC);
+		card->dumpbuffer =3D kmalloc(DUMP_PAGE_SIZE, GFP_KERNEL);
=20
 		ASSERT(card->dumpbuffer);
 		if (card->dumpbuffer =3D=3D NULL)
@@ -2667,7 +2667,7 @@ static int slic_card_init(struct sliccar
 	 *  Allocate COMMAND BUFFER
 	 */
 	if (!card->cmdbuffer) {
-		card->cmdbuffer =3D kmalloc(sizeof(struct dump_cmd), GFP_ATOMIC);
+		card->cmdbuffer =3D kmalloc(sizeof(struct dump_cmd), GFP_KERNEL);
=20
 		ASSERT(card->cmdbuffer);
 		if (card->cmdbuffer =3D=3D NULL)
@@ -2808,7 +2808,7 @@ static u32 slic_card_locate(struct adapt
 	}
 	if (!physcard) {
 		/* no structure allocated for this physical card yet */
-		physcard =3D kzalloc(sizeof(struct physcard), GFP_ATOMIC);
+		physcard =3D kzalloc(sizeof(struct physcard), GFP_KERNEL);
 		ASSERT(physcard);
=20
 		DBG_MSG

------=_NextPart_000_0004_01C9AC8D.305FF110--

