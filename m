Return-Path: <linux-kernel-owner+w=401wt.eu-S1755655AbYLIWUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655AbYLIWUx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 17:20:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755276AbYLIWUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 17:20:36 -0500
Received: from ozlabs.org ([203.10.76.45]:50649 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754899AbYLIWUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 17:20:32 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: setup_arch/arch_get_boot_command_line changes
Date: Wed, 10 Dec 2008 08:50:24 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-9-generic; KDE/4.1.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com,
       Richard Henderson <rth@twiddle.net>,
       Russell King <rmk@arm.linux.org.uk>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Bryan Wu <cooloney@kernel.org>, Mikael Starvik <starvik@axis.com>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Tony Luck <tony.luck@intel.com>,
       Hirokazu Takata <takata@linux-m32r.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Greg Ungerer <gerg@uclinux.org>, Ralf Baechle <ralf@linux-mips.org>,
       linux-parisc@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Paul Mundt <lethal@linux-sh.org>,
       "David S. Miller" <davem@davemloft.net>, Jeff Dike <jdike@addtoit.com>,
       Ingo Molnar <mingo@redhat.com>, Chris Zankel <chris@zankel.net>,
       Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812100850.26728.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, I've folded in all the fixes, thanks.  Git tree is here:

	git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-boot-params.git

Stephen, please include in linux-next.  Clearly this hits every arch.  I'll
try to avoid rebasing unless I've broken some arch horribly.

Thanks,
Rusty.

David Howells (2):
      param: Adapt MN10300 to the new parameter handling regime
      param: Adapt FRV to the new parameter handling regime    

Rusty Russell (10):
      USB: Don't use __module_param_call
      param: allow parse_args to work non-destructively.
      core_param: call these really, really early.      
      param: make sure charp isn't used as a core_param 
      param: arch_get_boot_command_line()               
      params: move core_param() parsing to before setup_arch.
      Call early_param earlier.                              
      param: combine core_param and early_param parsing.     
      params: don't use alloc_bootmem for saved_command_line 
      param: move banner printing to top of start_kernel.    

 arch/alpha/kernel/setup.c                  |   36 ++++++++-----
 arch/arm/kernel/setup.c                    |   43 +++++++++-------
 arch/avr32/kernel/setup.c                  |   15 ++---           
 arch/blackfin/kernel/setup.c               |   22 ++++----        
 arch/cris/kernel/setup.c                   |   29 +++++-----      
 arch/frv/kernel/setup.c                    |   50 +++++++-----------
 arch/h8300/kernel/setup.c                  |   27 +++++-----        
 arch/ia64/dig/setup.c                      |    2 +-                
 arch/ia64/hp/sim/hpsim_setup.c             |    2 +-                
 arch/ia64/include/asm/machvec.h            |    4 +-                
 arch/ia64/include/asm/paravirt.h           |    8 ++--              
 arch/ia64/kernel/machvec.c                 |    8 +++-              
 arch/ia64/kernel/setup.c                   |   32 ++++++------      
 arch/ia64/sn/kernel/setup.c                |   13 ++---             
 arch/ia64/uv/kernel/setup.c                |    2 +-                
 arch/ia64/xen/xen_pv_ops.c                 |    2 +-                
 arch/m32r/kernel/setup.c                   |   16 +++---            
 arch/m68k/kernel/setup.c                   |   27 ++++++----        
 arch/m68knommu/include/asm/machdep.h       |    2 +-                
 arch/m68knommu/kernel/setup.c              |   33 ++++++------      
 arch/m68knommu/platform/5206/config.c      |    2 +-                
 arch/m68knommu/platform/5206e/config.c     |   14 +++--             
 arch/m68knommu/platform/520x/config.c      |    2 +-                
 arch/m68knommu/platform/523x/config.c      |    2 +-                
 arch/m68knommu/platform/5249/config.c      |    2 +-                
 arch/m68knommu/platform/5272/config.c      |   23 ++++----          
 arch/m68knommu/platform/527x/config.c      |    2 +-                
 arch/m68knommu/platform/528x/config.c      |    2 +-                
 arch/m68knommu/platform/5307/config.c      |   13 +++--             
 arch/m68knommu/platform/532x/config.c      |   22 ++++----          
 arch/m68knommu/platform/5407/config.c      |    2 +-                
 arch/m68knommu/platform/68328/config.c     |    2 +-                
 arch/m68knommu/platform/68328/head-pilot.S |    2 +-                
 arch/m68knommu/platform/68360/config.c     |    6 ++-               
 arch/m68knommu/platform/68EZ328/config.c   |    4 +-                
 arch/m68knommu/platform/68VZ328/config.c   |   12 +++--             
 arch/mips/kernel/setup.c                   |   20 ++++----          
 arch/mn10300/kernel/setup.c                |   61 +++++++++-------------
 arch/parisc/kernel/setup.c                 |   30 +++++------           
 arch/powerpc/kernel/prom.c                 |    1 -                     
 arch/powerpc/kernel/setup_32.c             |   10 +++-                  
 arch/powerpc/kernel/setup_64.c             |    8 ++-                   
 arch/s390/kernel/setup.c                   |    8 +---                  
 arch/sh/boards/board-magicpanelr2.c        |    2 +-                    
 arch/sh/boards/board-sh7785lcr.c           |    2 +-
 arch/sh/boards/mach-dreamcast/setup.c      |    2 +-
 arch/sh/boards/mach-highlander/setup.c     |    2 +-
 arch/sh/boards/mach-hp6xx/setup.c          |    2 +-
 arch/sh/boards/mach-landisk/setup.c        |    2 +-
 arch/sh/boards/mach-microdev/setup.c       |    2 +-
 arch/sh/boards/mach-migor/setup.c          |    2 +-
 arch/sh/boards/mach-r2d/setup.c            |    2 +-
 arch/sh/boards/mach-sdk7780/setup.c        |    2 +-
 arch/sh/boards/mach-se/7343/setup.c        |    2 +-
 arch/sh/boards/mach-se/770x/setup.c        |    2 +-
 arch/sh/boards/mach-se/7721/setup.c        |    2 +-
 arch/sh/boards/mach-se/7722/setup.c        |    2 +-
 arch/sh/boards/mach-se/7780/setup.c        |    2 +-
 arch/sh/boards/mach-sh03/setup.c           |    2 +-
 arch/sh/boards/mach-sh7763rdp/setup.c      |    2 +-
 arch/sh/include/asm/machvec.h              |    2 +-
 arch/sh/kernel/setup.c                     |   28 +++++-----
 arch/sparc/kernel/setup.c                  |   14 +++---
 arch/sparc64/kernel/setup.c                |   12 ++--
 arch/um/kernel/um_arch.c                   |   10 +++-
 arch/x86/kernel/setup.c                    |   41 +++++++--------
 arch/xtensa/kernel/setup.c                 |   19 ++++---
 drivers/usb/core/usb.c                     |    8 ++-
 include/asm-generic/vmlinux.lds.h          |    3 +
 include/linux/init.h                       |    5 +-
 include/linux/moduleparam.h                |   43 ++++++++++++----
 init/main.c                                |   74 ++++++++++++--------------
 kernel/kexec.c                             |    1 +
 kernel/module.c                            |    2 +-
 kernel/params.c                            |   77 +++++++++++++++++++++------
 75 files changed, 535 insertions(+), 461 deletions(-)
