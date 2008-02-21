Return-Path: <linux-kernel-owner+w=401wt.eu-S1761720AbYBUPS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761720AbYBUPS3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 10:18:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753061AbYBUPST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 10:18:19 -0500
Received: from mx2.compro.net ([216.54.166.4]:30997 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753236AbYBUPSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 10:18:18 -0500
X-IronPort-AV: E=Sophos;i="4.25,386,1199682000"; 
   d="scan'208";a="1739087"
Message-ID: <47BD9588.9080803@compro.net>
Date: Thu, 21 Feb 2008 10:15:20 -0500
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: linux-scsi@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: New 2.6.24.2 SG_IO SCSI problems
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I seem to have run into some sort of regression in the SG_IO interface of 2.6.24.2. 
I have an application that up until 2.6.24 worked fine. The 2.6.23.16 kernel works fine.

During reads I get these kernel messages. Writes and other functions _seem_ OK. Actually basic
reads  are working. Its with large BC reads using an io_vec list that the problem shows up.

Feb 21 09:27:51 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 09:27:51 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 09:27:51 harley kernel: sg[0] - Addr 0x06256100 : Length 256
Feb 21 09:27:51 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 09:27:51 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 09:27:51 harley kernel: sg[0] - Addr 0x06256100 : Length 256
Feb 21 09:27:51 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 09:27:51 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 09:27:51 harley kernel: sg[0] - Addr 0x06256100 : Length 256
Feb 21 09:27:51 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 09:27:51 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 09:27:51 harley kernel: sg[0] - Addr 0x06256100 : Length 256
.
.
.
.
.
.

The status elements of the sg_io_hdr_t structure used in the application returns
 status = 0x0 msg_status 0x0 host_status = 0x7 driver_status = 0x0

The hardware in use on this particular machine is an simple Adaptec AHA-2930CU talking to an old
IMPRIMIS 94601-15 1.2GB disk drive.

Again, all this works fine with the 2.6.23.11 kernel

Any help would be appreciated

Regards
Mark Hounschell

