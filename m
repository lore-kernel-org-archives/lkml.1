Return-Path: <linux-kernel-owner+w=401wt.eu-S932484AbYBUNQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932484AbYBUNQZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 08:16:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756651AbYBUNQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 08:16:16 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:55104 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754507AbYBUNQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 08:16:15 -0500
Date: Thu, 21 Feb 2008 14:16:28 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, sam@ravnborg.org,
       linux-kbuild@vger.kernel.org
Subject: separate object directories: trap for user 
Message-ID: <20080221131628.GA5332@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I'm using separate object directories, but there's trap there which
catches me every now and then: 

(/data/l/linux are my sources, objects are in /data/l/b-linux)

Every now and then, I make a mistake and try to make kernel in source
directories... that does not work as expected:

pavel@amd:/data/l/linux$ time make
scripts/kconfig/conf -s arch/x86/Kconfig
***
*** You have not yet configured your kernel!
*** (missing kernel .config file)
***
*** Please run some configurator (e.g. "make oldconfig" or
*** "make menuconfig" or "make xconfig").
***
make[2]: *** [silentoldconfig] Error 1
make[1]: *** [silentoldconfig] Error 2
make: *** No rule to make target `include/config/auto.conf', needed by
`include/config/kernel.release'.  Stop.
0.55user 0.44system 8.15 (0m8.157s) elapsed 12.30%CPU
pavel@amd:/data/l/linux$

...but it has unexpected side effect of breaking build in object
directories:

pavel@amd:/data/l/b-linux$ time make
make -C /data/l/linux O=/data/l/b-linux/.
  Using /data/l/linux as source for kernel
  /data/l/linux is not clean, please run 'make mrproper'
  in the '/data/l/linux' directory.
make[2]: *** [prepare3] Error 1
make[1]: *** [sub-make] Error 2
make: *** [all] Error 2
0.24user 0.18system 5.03 (0m5.032s) elapsed 8.42%CPU
pavel@amd:/data/l/b-linux$

This is needed to fix the situation:

pavel@amd:/data/l/linux$ rmdir include/config/

Would it be possible to stop the oldconfig before it creates
include/config?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
