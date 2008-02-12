Return-Path: <linux-kernel-owner+w=401wt.eu-S1763138AbYBLSE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763138AbYBLSE2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 13:04:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759414AbYBLSES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 13:04:18 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:59896 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758807AbYBLSEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 13:04:16 -0500
Subject: Re: [PATCH] drivers/base: export gpl (un)register_memory_notifier
From: Dave Hansen <haveblue@us.ibm.com>
To: Jan-Bernd Themann <ossthema@de.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>, linux-ppc <linuxppc-dev@ozlabs.org>,
       Thomas Klein <osstklei@de.ibm.com>,
       "Themann, Jan-Bernd" <themann@de.ibm.com>, Greg KH <greg@kroah.com>,
       Christoph Raisch <RAISCH@de.ibm.com>
In-Reply-To: <200802111724.12416.ossthema@de.ibm.com>
References: <200802111724.12416.ossthema@de.ibm.com>
Content-Type: text/plain
Date: Tue, 12 Feb 2008 10:04:09 -0800
Message-Id: <1202839449.11188.35.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-02-11 at 17:24 +0100, Jan-Bernd Themann wrote:
> Drivers like eHEA need memory notifiers in order to 
> update their internal DMA memory map when memory is added
> to or removed from the system.
> 
> Patch for eHEA memory hotplug support that uses these functions:
> http://www.spinics.net/lists/netdev/msg54484.html

This driver is broken pretty horribly.  It won't even compile for a
plain ppc64 kernel:

http://sr71.net/~dave/linux/ehea-is-broken.config

I know it's used for very specific hardware, but this is the symptom of
it not using the proper abstracted interfaces to the VM.

In file included from /home/dave/work/linux/2.6/23/linux-2.6.git/drivers/net/ehea/ehea_main.c:42:
/home/dave/work/linux/2.6/23/linux-2.6.git/drivers/net/ehea/ehea_qmr.h:44:14: warning: "SECTION_SIZE_BITS" is not defined
/home/dave/work/linux/2.6/23/linux-2.6.git/drivers/net/ehea/ehea_qmr.h:45:2: error: #error eHEA module cannot work if kernel sectionsize < ehea sectionsize
  CC      drivers/net/mii.o
make[4]: *** [drivers/net/ehea/ehea_main.o] Error 1
make[4]: *** Waiting for unfinished jobs....
  CC      drivers/net/ixgb/ixgb_param.o
In file included from /home/dave/work/linux/2.6/23/linux-2.6.git/drivers/net/ehea/ehea_qmr.c:32:
/home/dave/work/linux/2.6/23/linux-2.6.git/drivers/net/ehea/ehea_qmr.h:44:14: warning: "SECTION_SIZE_BITS" is not defined
/home/dave/work/linux/2.6/23/linux-2.6.git/drivers/net/ehea/ehea_qmr.h:45:2: error: #error eHEA module cannot work if kernel sectionsize < ehea sectionsize
/home/dave/work/linux/2.6/23/linux-2.6.git/drivers/net/ehea/ehea_qmr.c: In function 'ehea_create_busmap':
/home/dave/work/linux/2.6/23/linux-2.6.git/drivers/net/ehea/ehea_qmr.c:574: error: 'NR_MEM_SECTIONS' undeclared (first use in this function)
/home/dave/work/linux/2.6/23/linux-2.6.git/drivers/net/ehea/ehea_qmr.c:574: error: (Each undeclared identifier is reported only once
/home/dave/work/linux/2.6/23/linux-2.6.git/drivers/net/ehea/ehea_qmr.c:574: error: for each function it appears in.)
/home/dave/work/linux/2.6/23/linux-2.6.git/drivers/net/ehea/ehea_qmr.c:575: error: implicit declaration of function 'valid_section_nr'
/home/dave/work/linux/2.6/23/linux-2.6.git/drivers/net/ehea/ehea_qmr.c: In function 'ehea_map_vaddr':
/home/dave/work/linux/2.6/23/linux-2.6.git/drivers/net/ehea/ehea_qmr.c:606: error: 'SECTION_SIZE_BITS' undeclared (first use in this function)
/home/dave/work/linux/2.6/23/linux-2.6.git/drivers/net/ehea/ehea_qmr.c: In function 'ehea_reg_kernel_mr':
/home/dave/work/linux/2.6/23/linux-2.6.git/drivers/net/ehea/ehea_qmr.c:655: error: 'SECTION_SIZE_BITS' undeclared (first use in this function)

-- Dave

