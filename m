Return-Path: <linux-kernel-owner+w=401wt.eu-S932266AbXCGLyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266AbXCGLyg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 06:54:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932367AbXCGLyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 06:54:36 -0500
Received: from merkurneu.hrz.uni-giessen.de ([134.176.2.3]:54535 "EHLO
	merkurneu.hrz.uni-giessen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932266AbXCGLyf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 06:54:35 -0500
From: Marc Dietrich <Marc.Dietrich@ap.physik.uni-giessen.de>
To: linux-kernel@vger.kernel.org
Subject: 2.6.21-rc2-mm2 fails does not compile
Date: Wed, 7 Mar 2007 12:53:53 +0100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703071254.03014.marc.dietrich@ap.physik.uni-giessen.de>
X-HRZ-JLUG-MailScanner-Information: Passed JLUG virus check
X-HRZ-JLUG-MailScanner: No virus found
X-MailScanner-From: marc.dietrich@ap.physik.uni-giessen.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

the fix "revert-optimize-and-simplify-get_cycles_sync" breaks the build:

  CC      arch/i386/kernel/asm-offsets.s
In file included from include/asm/timex.h:10,
                 from include/linux/timex.h:187,
                 from include/linux/sched.h:50,
                 from include/linux/utsname.h:35,
                 from include/asm/elf.h:12,
                 from include/linux/elf.h:7,
                 from include/linux/module.h:15,
                 from include/linux/crypto.h:21,
                 from arch/i386/kernel/asm-offsets.c:7:
include/asm/tsc.h: In function ‘get_cycles_sync’:
include/asm/tsc.h:45: warning: implicit declaration of 
function ‘alternative_io’
include/asm/tsc.h:46: error: called object ‘"=a"’ is not a function
include/asm/tsc.h:46: error: called object ‘"0"’ is not a function
include/asm/tsc.h:46: error: expected ‘)’ before ‘:’ token
make[1]: *** [arch/i386/kernel/asm-offsets.s] Error 1
make: *** [prepare0] Error 2


seems that alternative_io is only defined in the x86_64 case ...

what's the fix for the fix ?

Marc


-- 
	"Those who question our statements are traitors"
		 Lord Arthur Ponsonby, "Falsehood in Wartime: Propaganda Lies of the First 
World War", 1928
