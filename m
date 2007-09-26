Return-Path: <linux-kernel-owner+w=401wt.eu-S1762011AbXIZUs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762011AbXIZUs5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 16:48:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754174AbXIZUsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 16:48:47 -0400
Received: from smtp.innovsys.com ([66.115.232.196]:11140 "EHLO
	mail.innovsys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757312AbXIZUsq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 16:48:46 -0400
X-Greylist: delayed 974 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Sep 2007 16:48:46 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH4/4] [POWERPC] Fix cpm_uart driver
Date: Wed, 26 Sep 2007 15:32:29 -0500
Message-ID: <DCEAAC0833DD314AB0B58112AD99B93B0368C44B@ismail.innsys.innovsys.com>
In-Reply-To: <46F8101E.1050000@freescale.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH4/4] [POWERPC] Fix cpm_uart driver
thread-index: Acf+4W7/x3/f0LryRDKaPTVPI/Sd5ABmm39g
References: <46F6C9DC.90008@scram.de> <46F7DE85.7000401@freescale.com><46F7EE95.1040509@scram.de> <46F80049.2030509@freescale.com><FF1A2486-BE77-49F8-99F3-B09B4EEAF50D@embeddedalley.com> <46F8101E.1050000@freescale.com>
From: "Rune Torgersen" <runet@innovsys.com>
To: "Scott Wood" <scottwood@freescale.com>,
       "Dan Malek" <dan@embeddedalley.com>
Cc: <linuxppc-embedded@ozlabs.org>, <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Scott Wood
> Maybe that's how it was, but the current code initializes it (more or
> less) directly with IMAP_ADDR, which also gets fed into ioremap.
> 
> One of the two has got to be wrong.

arch/ppc maps the immr area 1:1 into kernel memory, so ioremap and
physical are the same.
See arch/ppc/syslib/m8260_setup.c, line 208 (function m8260_map_io)

Here quoted:
arch/ppc/syslib/m8260_setup.c
196 /* Map the IMMR, plus anything else we can cover
197  * in that upper space according to the memory controller
198  * chip select mapping.  Grab another bunch of space
199  * below that for stuff we can't cover in the upper.
200  */
201 static void __init
202 m8260_map_io(void)
203 {
204         uint addr;
205
206         /* Map IMMR region to a 256MB BAT */
207         addr = (cpm2_immr != NULL) ? (uint)cpm2_immr : CPM_MAP_ADDR;
208         io_block_mapping(addr, addr, 0x10000000, _PAGE_IO);
209
210         /* Map I/O region to a 256MB BAT */
211         io_block_mapping(IO_VIRT_ADDR, IO_PHYS_ADDR, 0x10000000,
_PAGE_IO);
212 }
