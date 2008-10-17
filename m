Return-Path: <linux-kernel-owner+w=401wt.eu-S1757871AbYJQXGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757871AbYJQXGF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 19:06:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756546AbYJQXFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 19:05:47 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:59651 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757464AbYJQXFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 19:05:46 -0400
Date: Sat, 18 Oct 2008 01:05:30 +0200
From: Pavel Machek <pavel@suse.cz>
To: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>,
       Russell King <rmk@arm.linux.org.uk>, Dirk@Opfer-Online.de,
       arminlitzel@web.de, pavel.urban@ct.cz, Cyril Hrubis <metan@ucw.cz>,
       thommycheck@gmail.com, milan@ucw.cz
Subject: 2.6.27-git6: max1111_read_channel and corgi_ssp_ads7846_putget
	missing
Message-ID: <20081017230529.GB1467@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

2.6.27 compiled okay, rc6 gives:

  CHK     include/linux/version.h
make[1]: `include/asm-arm/mach-types.h' is up to date.
  CHK     include/linux/utsrelease.h
  CALL    scripts/checksyscalls.sh
<stdin>:1097:2: warning: #warning syscall fadvise64 not implemented
<stdin>:1265:2: warning: #warning syscall migrate_pages not implemented
<stdin>:1321:2: warning: #warning syscall pselect6 not implemented
<stdin>:1325:2: warning: #warning syscall ppoll not implemented
<stdin>:1365:2: warning: #warning syscall epoll_pwait not implemented
  CHK     include/linux/compile.h
  GEN     .version
  CHK     include/linux/compile.h
  UPD     include/linux/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
arch/arm/mach-pxa/built-in.o: In function `sharpsl_pm_pxa_read_max1111':
spitz_pm.c:(.text+0x3100): undefined reference to `max1111_read_channel'
drivers/built-in.o: In function `corgits_resume':
ledtrig-ide-disk.c:(.text+0x5f694): undefined reference to `corgi_ssp_ads7846_putget'
drivers/built-in.o: In function `corgits_suspend':
ledtrig-ide-disk.c:(.text+0x5f7a0): undefined reference to `corgi_ssp_ads7846_putget'
drivers/built-in.o: In function `sync_receive_data_send_cmd':
ledtrig-ide-disk.c:(.text+0x5f868): undefined reference to `corgi_ssp_ads7846_get'
ledtrig-ide-disk.c:(.text+0x5f884): undefined reference to `corgi_ssp_ads7846_put'
ledtrig-ide-disk.c:(.text+0x5f888): undefined reference to `corgi_ssp_ads7846_get'
ledtrig-ide-disk.c:(.text+0x5f8d4): undefined reference to `corgi_ssp_ads7846_put'
drivers/built-in.o: In function `ts_interrupt_main':
ledtrig-ide-disk.c:(.text+0x5f990): undefined reference to `corgi_ssp_ads7846_lock'
ledtrig-ide-disk.c:(.text+0x5fa68): undefined reference to `corgi_ssp_ads7846_put'
ledtrig-ide-disk.c:(.text+0x5fa6c): undefined reference to `corgi_ssp_ads7846_get'
ledtrig-ide-disk.c:(.text+0x5fa70): undefined reference to `corgi_ssp_ads7846_unlock'
drivers/built-in.o: In function `corgits_probe':
ledtrig-ide-disk.c:(.init.text+0x2a7c): undefined reference to `corgi_ssp_ads7846_putget'
ledtrig-ide-disk.c:(.init.text+0x2aac): undefined reference to `corgi_ssp_ads7846_putget'
ledtrig-ide-disk.c:(.init.text+0x2adc): undefined reference to `corgi_ssp_ads7846_putget'
ledtrig-ide-disk.c:(.init.text+0x2b0c): undefined reference to `corgi_ssp_ads7846_putget'
make: *** [.tmp_vmlinux1] Error 1

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
