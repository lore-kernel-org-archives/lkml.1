Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933433Ab0BEXSY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 18:18:24 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:36334 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757629Ab0BEXSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 18:18:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=WitTYsw9jJSP23eb1F+F9V0yIDrRPYnvvgWysKMy2deB+MX4NMP2w4yEYGqaJNXtfc
         oIZLDxbPzS7kAryrTUQzfEa2It3g9yWpQKU767eYXCGlKklKj9ANbYqHJtHt4mXpk9Wn
         cglyNS6HqUz76zE+8n1HqwRAFWN44NouXTDUI=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: "stanley.miao" <stanley.miao@windriver.com>,
       Vitaly Wool <vitalywool@gmail.com>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: NAND: fixes
Date: Sat,  6 Feb 2010 01:18:03 +0200
Message-Id: <1265411890-9156-1-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is part of my patcheset that touches the nand subsystem

Stanley, patch #2 should now cover attempts to write outside the oob.

Also I did another (don't know if less or more evil) approach to bad block testing.
Now check_bad always takes the controller locks and selects the chip. Thus it is
possible to use read_oob/write_oob.
This however changes behavier of the nand_erase_nand to deny erases if any block within
the range is bad. Also it selects/releases the chip once per erase block.
This is done in patch #5. Patch #6 is ported to that change.

Patches 1-3 are pure fixes.

Best regards,
	Maxim Levitsky

