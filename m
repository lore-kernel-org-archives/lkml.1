Return-Path: <linux-kernel-owner+w=401wt.eu-S1751823AbZJXCTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823AbZJXCTf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 22:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751641AbZJXCTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 22:19:35 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:45163 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbZJXCTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 22:19:34 -0400
Date: Fri, 23 Oct 2009 21:19:30 -0500
From: David Fries <david@fries.net>
To: linux-kernel@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, jbohac@jikos.cz
Subject: [Bug 14310] [bisected] 2.6.31 regression sis5513 PIO Mode 0 hang
Message-ID: <20091024021930.GZ21612@spacedout.fries.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Fri, 23 Oct 2009 21:19:32 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Forwarded message from bugzilla-daemon@bugzilla.kernel.org -----
http://bugzilla.kernel.org/show_bug.cgi?id=14310

--- Comment #3 from Jiri Bohac <jbohac@jikos.cz>  2009-10-23 18:32:03 ---
I can still reproduce this on 2.6.31.5, where the
e13ee546bb06453939014c7b854e77fb643fd6f1 fix is included. Reverting
6029336426a2b43e4bc6f4a84be8789a047d139e helps.

Without reverting 6029336426a2b43e4bc6f4a84be8789a047d139e the system hangs on
"ide-cd driver 5.00", but sometimes I also get {DriveReady SeekComplete Error}
errors on hda before the hang -- never seen them without 
6029336426a2b43e4bc6f4a84be8789a047d139e.

A few interesting lines of output before the hang: (hand-copied, no serial
console here)

hda: ST38421A <strange_nonASCII_triangle_character_here> , ATA DISK drive
hdc: LTN5269, ATAPI CD/DVD-ROM drive
hdc: tPIO > 2, assuming tPIO=2
hdc: tPIO > 2, assuming tPIO=2
..
..
<hda seek errors>
..
possibly failed opcode: 0xc6
hda: lost interrupt
hda: 
<hda seek error>
possibly failed opcode: 0x20
 unknown patrition table
ide-cd driver 5.00
<hang>

I don't have regular access to this machine, but if help is needed, I can
arrange access to the machine.

Can we re-open this bug?

-- 
----- End forwarded message -----
