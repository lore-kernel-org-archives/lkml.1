Return-Path: <linux-kernel-owner+w=401wt.eu-S1754296AbZA0B70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296AbZA0B70 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 20:59:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbZA0B7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 20:59:19 -0500
Received: from rv-out-0506.google.com ([209.85.198.229]:19302 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbZA0B7S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 20:59:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=S5oZhHIYMjLOlkND4OQbWifDogTEpxku2099h737kHMrDwOIFaCgVp5eH1AH4MifE2
         wdV5HbRODsWwjcv56s4VBlsYU6sv2ViL3ftCIBeuYZcPcqq39M33zotFDNIUQh/zqaep
         0WSaWzZZ57cJs5Y15BcoGRzuG7XMVh3LDi5W0=
MIME-Version: 1.0
Date: Tue, 27 Jan 2009 09:59:17 +0800
Message-ID: <b6a2187b0901261759q67b09a95v530127254b807042@mail.gmail.com>
Subject: multiple definition of `debugfs_create_size_t' - please revert 
	8adb711f3668b034e7b956fac951ed08b53e0d55
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

The below commit cause this problem. Reverting it solved the problem.

arch/x86/mm/pat.o: In function `debugfs_create_size_t':
pat.c:(.text+0x0): multiple definition of `debugfs_create_size_t'
arch/x86/mm/pageattr.o:(.text+0x0): first defined here
make[1]: *** [arch/x86/mm/built-in.o] Error 1
make: *** [arch/x86/mm] Error 2


Thanks,
Jeff.


commit 8adb711f3668b034e7b956fac951ed08b53e0d55
Author: Inaky Perez-Gonzalez <inaky@linux.intel.com>
Date:   Tue Jan 20 12:17:28 2009 -0800

    debugfs: introduce stub for debugfs_create_size_t() when DEBUG_FS=n

    Toralf Förster <toralf.foerster@gmx.de> reported a build failure in
    the WiMAX stack when CONFIG_DEBUG_FS=n

    http://linuxwimax.org/pipermail/wimax/2009-January/000449.html

    This is due to debugfs_create_size_t() missing an stub that returns
    -ENODEV when the DEBUGFS subsystem is not configured in (like the rest
    of the debugfs API).

    This patch adds said stub.

    Reported-by: Toralf Förster <toralf.foerster@gmx.de>
    Signed-off-by: Inaky Perez-Gonzalez <inaky@linux.intel.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
