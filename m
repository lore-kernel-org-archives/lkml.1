Return-Path: <linux-kernel-owner+w=401wt.eu-S1757607AbYA0MvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757607AbYA0MvX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 07:51:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753250AbYA0MvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 07:51:14 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:47488 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098AbYA0MvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 07:51:14 -0500
Date: Sun, 27 Jan 2008 13:51:12 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: monstr@monstr.eu
cc: linux-kernel@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au
Subject: Re: [PATCH 12/52] [microblaze] lmb support
In-Reply-To: <873c2bf1f67696aa11014886470f6ba46f04e8d2.1201107832.git.monstr@monstr.eu>
Message-ID: <Pine.LNX.4.64.0801271347500.1185@fbirervta.pbzchgretzou.qr>
References: <1201187014-3979-1-git-send-email-monstr@monstr.eu>
 <dbff6b883dbcb108db53e5093994c473946e1240.1201107832.git.monstr@monstr.eu>
 <ac0947adfe718fcb4c0dc5f6f7ab64f8155541fb.1201107832.git.monstr@monstr.eu>
 <873c2bf1f67696aa11014886470f6ba46f04e8d2.1201107832.git.monstr@monstr.eu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 24 2008 16:02, monstr@monstr.eu wrote:
>+
>+#define DEBUG
>+
>+#ifdef DEBUG
>+#define DBG(fmt...) printk(fmt)
>+#else
>+#define DBG(fmt...)
>+#endif

Phew, don't reinvent the wheel - use the existing pr_debug() instead.


>+static unsigned long __init lmb_addrs_overlap(unsigned long base1,
>+		unsigned long size1, unsigned long base2, unsigned long size2)
>+{
>+	return ((base1 < (base2+size2)) && (base2 < (base1+size1)));
	return base1 < base2 + size2 && base2 < base1 + size1;
>+}

Operator precedence makes it possible; you could omit a lot of () in the code.
(Also try checkpatch.pl to get to know of other style 'errors')
