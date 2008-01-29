Return-Path: <linux-kernel-owner+w=401wt.eu-S1754948AbYA2Van@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948AbYA2Van (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 16:30:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752008AbYA2Vag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 16:30:36 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:52774 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbYA2Vaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 16:30:35 -0500
Date: Tue, 29 Jan 2008 22:30:34 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: monstr@monstr.eu
cc: linux-kernel@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au
Subject: Re: [PATCH 17/52] [microblaze] checksum support
In-Reply-To: <4b7d90fc1b9bcb3c0b1b308c6460390f7bdf3824.1201107832.git.monstr@monstr.eu>
Message-ID: <Pine.LNX.4.64.0801292228090.14907@fbirervta.pbzchgretzou.qr>
References: <1201187014-3979-1-git-send-email-monstr@monstr.eu>
 <dbff6b883dbcb108db53e5093994c473946e1240.1201107832.git.monstr@monstr.eu>
 <ac0947adfe718fcb4c0dc5f6f7ab64f8155541fb.1201107832.git.monstr@monstr.eu>
 <873c2bf1f67696aa11014886470f6ba46f04e8d2.1201107832.git.monstr@monstr.eu>
 <516d173b1789ea533431e8f5ad05751c6a353c88.1201107832.git.monstr@monstr.eu>
 <068508828aac6298b4cc65b0cd7b2737a61c466c.1201107832.git.monstr@monstr.eu>
 <010fc233f82a8f7a591c9f8315ae03f9951139aa.1201107832.git.monstr@monstr.eu>
 <68faaf69ea03196d4a56a263707355e7e7eb5c6a.1201107832.git.monstr@monstr.eu>
 <4b7d90fc1b9bcb3c0b1b308c6460390f7bdf3824.1201107832.git.monstr@monstr.eu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 24 2008 16:02, monstr@monstr.eu wrote:
>+
>+	/*
>+ * copy from fs while checksumming, otherwise like csum_partial
>+	 */
>+

That comment got messed up. Also, does any other CPU than x86
have a %ds and %fs register?

If it copies directly from user context, a __user annotation would be
helpful.

>+unsigned int
>+csum_partial_copy_from_user(const char *src, char *dst, int len, int sum,
>+								int *csum_err)
>+{
>+	if (csum_err)
>+		*csum_err = 0;
>+	memcpy(dst, src, len);
>+	return csum_partial(dst, len, sum);
>+}
>+
>+/*
>+ * copy from ds while checksumming, otherwise like csum_partial
>+ */

Ditto.

>+
>+unsigned int
>+csum_partial_copy(const char *src, char *dst, int len, int sum)
>+{
>+	memcpy(dst, src, len);
>+	return csum_partial(dst, len, sum);
>+}
>diff --git a/include/asm-microblaze/checksum.h b/include/asm-microblaze/checksum.h
>new file mode 100644
>index 0000000..4b37bb5
>--- /dev/null
>+++ b/include/asm-microblaze/checksum.h
