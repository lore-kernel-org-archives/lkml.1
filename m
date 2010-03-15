Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759755Ab0COHIN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 03:08:13 -0400
Received: from mx3.orcon.net.nz ([219.88.242.53]:44759 "EHLO mx3.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759741Ab0COHIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 03:08:12 -0400
Message-ID: <4B9DDCD8.4070902@orcon.net.nz>
Date: Mon, 15 Mar 2010 20:08:08 +1300
From: Michael Cree <mcree@orcon.net.nz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100121 Lightning/1.0b2pre Shredder/3.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-alpha@vger.kernel.org
Subject: Alpha:  Compilation error 2.6.34-rc1 git a3d3203e4b
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
X-DSPAM-Check: by mx3.orcon.net.nz on Mon, 15 Mar 2010 20:08:10 +1300
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Mon Mar 15 20:08:10 2010
X-DSPAM-Confidence: 0.6909
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compilation error while compiling latest kernel (commit a3d3203e4b) on 
Alpha:

   CC      init/do_mounts.o
In file included from 
/home/mjc/linux/linux-git/arch/alpha/include/asm/dma-mapping.h:13,
                  from include/linux/dma-mapping.h:103,
                  from 
/home/mjc/linux/linux-git/arch/alpha/include/asm/pci.h:7,
                  from include/linux/pci.h:1209,
                  from 
/home/mjc/linux/linux-git/arch/alpha/include/asm/core_tsunami.h:5,
                  from 
/home/mjc/linux/linux-git/arch/alpha/include/asm/io.h:229,
                  from include/linux/scatterlist.h:8,
                  from include/linux/sunrpc/xdr.h:15,
                  from include/linux/sunrpc/sched.h:17,
                  from include/linux/sunrpc/auth.h:14,
                  from include/linux/nfs_fs.h:47,
                  from init/do_mounts.c:19:
include/asm-generic/dma-mapping-common.h: In function ‘dma_map_sg_attrs’:
include/asm-generic/dma-mapping-common.h:49: error: implicit declaration 
of function ‘for_each_sg’
include/asm-generic/dma-mapping-common.h:50: error: expected ‘;’ before 
‘kmemcheck_mark_initialized’
make[1]: *** [init/do_mounts.o] Error 1

I note that for_each_sg is defined in include/linux/scatterlist.h, which 
arch/alpha/include/asm/dma-mapping.h attempts to load, however 
include/linux/scatterlist.h was the one that included (indirectly) 
arch/alpha/include/asm/dma-mapping.h.  There is therefore a complete 
loop of includes from include/linux/scatterlist.h back to itself.

Cheers
Michael.
