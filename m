Return-Path: <linux-kernel-owner+w=401wt.eu-S1761837AbXE1JbK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761837AbXE1JbK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 05:31:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756172AbXE1Ja5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 05:30:57 -0400
Received: from wx-out-0506.google.com ([66.249.82.239]:21526 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755614AbXE1Ja4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 05:30:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:organization:to:subject:date:user-agent:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=KZkIy3ILbl8qNSPeJAfE/GUskxu+PwjtKZob+ea3TQKYX8RPhItUsQvqkTLn7T6qJ1G3Okc/79GAQQ7IUD+t3k9CkGuWRyk3giQtBCYuAGKRo+FcjWq4hnBL/uysS/sHDJQrXgtCaiI+xTl3eprZdRVNnsaPXvZM5fDpoBCvjr4=
From: Gene Heskett <gene.heskett@gmail.com>
Organization: Organization? very little
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: 2.6.22-rc3 scripts/kconfig/qconf arch/i386/Kconfig
Date: Mon, 28 May 2007 05:30:42 -0400
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200705280530.42562.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Up in the middle of the night, bored so I thought I'd build a new kernel 
2.6.22-rc3 before I got too far behind.

These errors were output after a make oldconfig had been done, followed by a 
make xconfig:

drivers/macintosh/Kconfig:116:warning: 'select' used by config 
symbol 'PMAC_APM_EMU' refers to undefined symbol 'SYS_SUPPORTS_APM_EMULATION'
drivers/net/Kconfig:2283:warning: 'select' used by config symbol 'UCC_GETH' 
refers to undefined symbol 'UCC_FAST'
drivers/input/keyboard/Kconfig:170:warning: 'select' used by config 
symbol 'KEYBOARD_ATARI' refers to undefined symbol 'ATARI_KBD_CORE'
drivers/input/mouse/Kconfig:182:warning: 'select' used by config 
symbol 'MOUSE_ATARI' refers to undefined symbol 'ATARI_KBD_CORE'

A make bzImage then spit this out:

scripts/kconfig/conf -s arch/i386/Kconfig
drivers/macintosh/Kconfig:116:warning: 'select' used by config 
symbol 'PMAC_APM_EMU' refers to undefined symbol 'SYS_SUPPORTS_APM_EMULATION'
drivers/net/Kconfig:2283:warning: 'select' used by config symbol 'UCC_GETH' 
refers to undefined symbol 'UCC_FAST'
drivers/input/keyboard/Kconfig:170:warning: 'select' used by config 
symbol 'KEYBOARD_ATARI' refers to undefined symbol 'ATARI_KBD_CORE'
drivers/input/mouse/Kconfig:182:warning: 'select' used by config 
symbol 'MOUSE_ATARI' refers to undefined symbol 'ATARI_KBD_CORE'

Other than the usual 'deprecated' suspects, the rest of the build proceeded 
nominally.  As did the reboot to it, and the first time install of the latest 
nvidia drivers from their .run file.

I purposely chose 'SLUB' and the new firewire stack.  SLUB bears watching I 
suppose, but how?

The firewire stack will get checked out later by my movie camera, a Sony 
TVR-460.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Life is like bein' on a mule team.  Unless you're the lead mule, all the
scenery looks about the same.
