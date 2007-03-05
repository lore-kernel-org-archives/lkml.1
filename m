Return-Path: <linux-kernel-owner+w=401wt.eu-S933044AbXCEKbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933044AbXCEKbx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 05:31:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933045AbXCEKbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 05:31:53 -0500
Received: from zcars04f.nortel.com ([47.129.242.57]:38432 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933044AbXCEKbw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 05:31:52 -0500
X-Greylist: delayed 1080 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Mar 2007 05:31:51 EST
X-MimeOLE: Produced By Microsoft Exchange V6.5.7226.0
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [patch 1/1] ppc: Possible bug fix for FCC driver
Date: Mon, 5 Mar 2007 11:12:54 +0100
Message-ID: <00B1F4365DDBE745B091C67A1CCFCB43070CE21E@zctfhxm1>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch 1/1] ppc: Possible bug fix for FCC driver
Thread-Index: AcdfDtbC24HBg98sQZWoIfIKQy9fJg==
From: "Cedric Pontois" <cpontois@nortel.com>
To: <dmalek@jlc.net>, <leoli@freescale.com>
Cc: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cedric Pontois <cpontois@nortel.com>

We use a kernel 2.6.14 on PPC platform (MPC 8555). The FCC driver works
well with a 100Mbps link. But it doesn't with a 10Mbps link. To solve
it, I modified the GFMR register init: removed TCI bit and set CRC32 bit
instead of. 

       Developer's Certificate of Origin 1.1

        By making a contribution to this project, I certify that:

        (a) The contribution was created in whole or in part by me and I
            have the right to submit it under the open source license
            indicated in the file; or

        (b) The contribution is based upon previous work that, to the
best
            of my knowledge, is covered under an appropriate open source
            license and I have the right under that license to submit
that
            work with modifications, whether created in whole or in part
            by me, under the same open source license (unless I am
            permitted to submit under a different license), as indicated
            in the file; or

        (c) The contribution was provided directly to me by some other
            person who certified (a), (b) or (c) and I have not modified
            it.

	(d) I understand and agree that this project and the
contribution
	    are public and that a record of the contribution (including
all
	    personal information I submit with it, including my
sign-off) is
	    maintained indefinitely and may be redistributed consistent
with
	    this project or the open source license(s) involved.

	Signed-off-by: Cedric Pontois <cpontois@nortel.com>

------------------------------------------------------------------------
-----

diff -ruN pa-original/arch/ppc/8260_io/fcc_enet.c
pa-patched/arch/ppc/8260_io/fcc_enet.c
--- pa-original/arch/ppc/8260_io/fcc_enet.c	2007-03-02
14:57:07.000197000 +0100
+++ pa-patched/arch/ppc/8260_io/fcc_enet.c	2007-03-02
14:57:08.000038000 +0100
@@ -2232,7 +2232,7 @@
 
 	/* Set GFMR to enable Ethernet operating mode.
 	 */
-	fccp->fcc_gfmr = (FCC_GFMR_TCI | FCC_GFMR_MODE_ENET);
+	fccp->fcc_gfmr = (FCC_GFMR_TCRC_32 | FCC_GFMR_MODE_ENET);
 
 	/* Set sync/delimiters.
 	*/

------------------------------------------------------------------------
-----

"The author works for the Alcatel-Lucent group, who is solely
responsible for this email and its contents. All enquiries regarding
this email should be addressed to Alcatel-Lucent. Nortel has provided
the use of the nortel.com domain to Alcatel-Lucent in connection with
this email solely for the purpose of connectivity and Nortel has no
liability for the email or its contents.  Alcatel Lucent's web site is
http://www.alcatel-lucent.com"

