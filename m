Return-Path: <linux-kernel-owner+w=401wt.eu-S1752063AbYLYMR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063AbYLYMR3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 07:17:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751787AbYLYMRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 07:17:21 -0500
Received: from ozlabs.org ([203.10.76.45]:33403 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751723AbYLYMRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 07:17:20 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: [RFC] boot parameter handling cleanup II
Date: Thu, 25 Dec 2008 22:47:12 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Yinghai Lu <yinghai@kernel.org>, Hugh Dickins <hugh@veritas.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Luck, Tony" <tony.luck@intel.com>
References: <Pine.LNX.4.64.0812230257440.27467@blonde.anvils> <86802c440812222152yd000009yf890f5cd303860e4@mail.gmail.com> <20081223143327.GF29151@elte.hu>
In-Reply-To: <20081223143327.GF29151@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812252247.12957.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Not much change since last time, just consolidated fixes aired here, esp.
 x86 early_param fixes thanks to Hugh and Yinghai.)

The following changes since commit 4a6908a3a050aacc9c3a2f36b276b46c0629ad91:    
  Linus Torvalds (1):                                                           
        Linux 2.6.28                                                            

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-boot-params.git master                                                                          

David Howells (2):
      param: Adapt MN10300 to the new parameter handling regime
      param: Adapt FRV to the new parameter handling regime    

Geert Uytterhoeven (1):
      m68k: Use asm/sections.h in kernel/setup.c

Rusty Russell (13):
      USB: Don't use __module_param_call; use core_param.
      x86: act on mem= and memmap= later in boot         
      x86: prepare noexec for being called earlier       
      x86: override_capabilities in early_identify_cpu   
      param: allow parse_args to work non-destructively. 
      param: put core_param in separate section          
      param: make sure charp isn't used as a core_param  
      param: arch_get_boot_command_line()                
      param: move core_param() parsing to before setup_arch.
      param: Call early_param earlier.                      
      param: combine core_param and early_param parsing.    
      param: don't use alloc_bootmem for saved_command_line 
      param: move banner printing to top of start_kernel.   

Yinghai Lu (1):
      x86: clean up setup_clear/force_cpu_cap handling

 arch/alpha/kernel/setup.c                  |   36 +++++++-----
 arch/arm/kernel/setup.c                    |   43 ++++++++------
 arch/avr32/kernel/setup.c                  |   15 ++---         
 arch/blackfin/kernel/setup.c               |   22 ++++----      
 arch/cris/kernel/setup.c                   |   29 +++++-----    
 arch/frv/kernel/setup.c                    |   50 ++++++----------
 arch/h8300/kernel/setup.c                  |   27 +++++----       
 arch/ia64/dig/setup.c                      |    2 +-              
 arch/ia64/hp/sim/hpsim_setup.c             |    2 +-              
 arch/ia64/include/asm/machvec.h            |    4 +-              
 arch/ia64/include/asm/paravirt.h           |    8 +-              
 arch/ia64/kernel/machvec.c                 |    8 ++-             
 arch/ia64/kernel/setup.c                   |   32 +++++-----      
 arch/ia64/sn/kernel/setup.c                |   13 ++--            
 arch/ia64/uv/kernel/setup.c                |    2 +-              
 arch/ia64/xen/xen_pv_ops.c                 |    2 +-              
 arch/m32r/kernel/setup.c                   |   16 +++---          
 arch/m68k/kernel/setup.c                   |   37 +++++++-----    
 arch/m68knommu/include/asm/machdep.h       |    2 +-              
 arch/m68knommu/kernel/setup.c              |   33 +++++-----      
 arch/m68knommu/platform/5206/config.c      |    2 +-              
 arch/m68knommu/platform/5206e/config.c     |   14 +++--           
 arch/m68knommu/platform/520x/config.c      |    2 +-              
 arch/m68knommu/platform/523x/config.c      |    2 +-              
 arch/m68knommu/platform/5249/config.c      |    2 +-              
 arch/m68knommu/platform/5272/config.c      |   23 ++++----        
 arch/m68knommu/platform/527x/config.c      |    2 +-              
 arch/m68knommu/platform/528x/config.c      |    2 +-              
 arch/m68knommu/platform/5307/config.c      |   13 +++-            
 arch/m68knommu/platform/532x/config.c      |   22 +++----         
 arch/m68knommu/platform/5407/config.c      |    2 +-              
 arch/m68knommu/platform/68328/config.c     |    2 +-              
 arch/m68knommu/platform/68328/head-pilot.S |    2 +-              
 arch/m68knommu/platform/68360/config.c     |    6 +-              
 arch/m68knommu/platform/68EZ328/config.c   |    4 +-              
 arch/m68knommu/platform/68VZ328/config.c   |   12 ++--            
 arch/mips/kernel/setup.c                   |   20 +++---          
 arch/mn10300/kernel/setup.c                |   61 ++++++++------------
 arch/parisc/kernel/setup.c                 |   32 +++++------         
 arch/powerpc/kernel/prom.c                 |    1 -                   
 arch/powerpc/kernel/setup_32.c             |   10 ++-                 
 arch/powerpc/kernel/setup_64.c             |   10 ++-                 
 arch/s390/kernel/setup.c                   |    8 +--                 
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
 arch/sparc/kernel/setup.c                  |   14 ++--
 arch/sparc64/kernel/setup.c                |   12 ++--
 arch/um/kernel/um_arch.c                   |   10 ++-
 arch/x86/include/asm/cpufeature.h          |    4 +-
 arch/x86/include/asm/processor.h           |    3 +-
 arch/x86/kernel/cpu/common.c               |   22 +++++--
 arch/x86/kernel/e820.c                     |   88 +++++++++++++++++----------
 arch/x86/kernel/setup.c                    |   41 ++++++-------
 arch/x86/mm/init_32.c                      |   11 ++-
 arch/xtensa/kernel/setup.c                 |   21 ++++---
 arch/xtensa/platforms/iss/setup.c          |    2 +-
 drivers/usb/core/usb.c                     |    8 ++-
 include/asm-generic/vmlinux.lds.h          |    3 +
 include/asm-xtensa/platform.h              |    5 +-
 include/linux/init.h                       |    5 +-
 include/linux/moduleparam.h                |   43 ++++++++++----
 init/main.c                                |   73 ++++++++++-------------
 kernel/kexec.c                             |    1 +
 kernel/module.c                            |    2 +-
 kernel/params.c                            |   74 ++++++++++++++++++-----
 82 files changed, 625 insertions(+), 518 deletions(-)
