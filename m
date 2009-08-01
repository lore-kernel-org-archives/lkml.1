Return-Path: <linux-kernel-owner+w=401wt.eu-S1751814AbZHARhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814AbZHARhU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 13:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751382AbZHARhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 13:37:19 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:41121 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbZHARhS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 13:37:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=oAvvhRVn4XgmoQImX2oPO6hyixDaOuf2Ff+0bXI70a7rxFM3bzcPCFwdm2rYQV5p9H
         o6pLJlmXxo/gW7tuKSMt/hnOY3PUDQnKxiDddI8H0Q4f8Prx1yI/9OcobNgStEBKrw+K
         TUi76s515NqB28x2ZIhpcUgqX7Np6j12XBuFU=
MIME-Version: 1.0
Date: Sat, 1 Aug 2009 19:37:18 +0200
Message-ID: <9b06e8d20908011037m6b0f72cch154ed1e15bdc8938@mail.gmail.com>
Subject: Strange arch/mips/delay.c
From: =?ISO-8859-1?Q?Lo=EFc_Greni=E9?= <loic.grenie@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
       Ralf Baechle <ralf@linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  I could not compile for mips without something similar to the
following patch. As far as I can say __udelay and __ndelay
are costly nops (with __ndelay not compiling at all) without
the patch.

  At that point, it might be interesting to change
the 0x00000005uLL by 0x00000045uLL and the >> 32
by >> 36 (the precision is much better and the cost
should be the same -- obviously there is a slightly higher
risk of overlow).

    Thanks,

           Loïc Grenié

Signed-off-by: Loic Grenie <loic.grenie@gmail.com>

--- a/arch/mips/lib/delay.c
+++ b/arch/mips/lib/delay.c
@@ -43,7 +43,7 @@ void __udelay(unsigned long us)
 {
        unsigned int lpj = current_cpu_data.udelay_val;

-       __delay((us * 0x000010c7 * HZ * lpj) >> 32);
+       __delay((us * 0x000010c7uLL * HZ * lpj) >> 32);
 }
 EXPORT_SYMBOL(__udelay);

@@ -51,6 +51,6 @@ void __ndelay(unsigned long ns)
 {
        unsigned int lpj = current_cpu_data.udelay_val;

-       __delay((us * 0x00000005 * HZ * lpj) >> 32);
+       __delay((ns * 0x00000005uLL * HZ * lpj) >> 32);
 }
 EXPORT_SYMBOL(__ndelay);
