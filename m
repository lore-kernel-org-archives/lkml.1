Return-Path: <linux-kernel-owner+w=401wt.eu-S1763624AbXGJS2D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763624AbXGJS2D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 14:28:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760173AbXGJS1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 14:27:53 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:5787 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbXGJS1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 14:27:52 -0400
Date: Tue, 10 Jul 2007 20:27:51 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       andi@firstfloor.org, akpm@linux-foundation.org
Subject: Re: [x86 setup 17/33] A20 handling code
In-Reply-To: <11840377211519-git-send-email-hpa@zytor.com>
Message-ID: <Pine.LNX.4.64.0707102025390.11053@fbirervta.pbzchgretzou.qr>
References: <11840359321823-git-send-email-hpa@zytor.com>
 <11840360383913-git-send-email-hpa@zytor.com> <11840361432207-git-send-email-hpa@zytor.com>
 <11840362483663-git-send-email-hpa@zytor.com> <11840363531039-git-send-email-hpa@zytor.com>
 <11840364593068-git-send-email-hpa@zytor.com> <1184036564610-git-send-email-hpa@zytor.com>
 <11840366692770-git-send-email-hpa@zytor.com> <11840367741994-git-send-email-hpa@zytor.com>
 <11840368791603-git-send-email-hpa@zytor.com> <11840369841576-git-send-email-hpa@zytor.com>
 <11840370903975-git-send-email-hpa@zytor.com> <11840371953778-git-send-email-hpa@zytor.com>
 <11840373002601-git-send-email-hpa@zytor.com> <11840374052662-git-send-email-hpa@zytor.com>
 <1184037510289-git-send-email-hpa@zytor.com> <11840376162370-git-send-email-hpa@zytor.com>
 <11840377211519-git-send-email-hpa@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 9 2007 19:51, H. Peter Anvin wrote:

>+		status = inb(0x64);
>+		if (status & 1) {
>+			/* Read and discard input data */
>+			io_delay();
>+			(void)inb(0x60);

Is the (void) cast needed for some obscure reason? Let's hope inb _is_ declared
as volatile. (Minus the volatile flames.

>+		} else if (!(status & 2)) {
>+			/* Buffers empty, finished! */
>+			return 0;
>+		}
>+	}
>+
>+	return -1;
>+}
>+
>+
>+#define A20_TEST_ADDR	(4*0x80)
>+#define A20_TEST_SHORT  32
>+#define A20_TEST_LONG	2097152	/* 2^21 */

Maybe...?
#define A20_TEST_LONG (1 << 21)

>+/* Quick test to see if A20 is already enabled */
>+static int a20_test_short(void)
>+{
>+	return a20_test(A20_TEST_SHORT);
>+}
>+
>+/* Longer test that actually waits for A20 to come on line; this
>+   is useful when dealing with the KBC or other slow external circuitry. */
>+static int a20_test_long(void)
>+{
>+	return a20_test(A20_TEST_LONG);
>+}

To me looks like some of these (or other functions) could return bool.



	Jan
-- 
