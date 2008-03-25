Return-Path: <linux-kernel-owner+w=401wt.eu-S1759377AbYCYSp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759377AbYCYSp5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 14:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757670AbYCYSpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 14:45:39 -0400
Received: from postfix2-g20.free.fr ([212.27.60.43]:56951 "EHLO
	postfix2-g20.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757484AbYCYSpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 14:45:38 -0400
Date: Tue, 25 Mar 2008 19:43:06 +0100
From: Emmanuel Florac <eflorac@intellique.com>
To: linux-kernel@vger.kernel.org
Subject: RAID-1 performance under 2.4 and 2.6
Message-ID: <20080325194306.4ac71ff2@galadriel.home>
Organization: Intellique
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I post there because I couldn't find any information about this
elsewhere : on the same hardware ( Athlon X2 3500+, 512MB RAM, 2x400 GB
Hitachi SATA2 hard drives ) the 2.4 Linux software RAID-1 (tested 2.4.32
and 2.4.36.2, slightly patched to recognize the hardware :p) is way
faster than 2.6 ( tested 2.6.17.13, 2.6.18.8, 2.6.22.16, 2.6.24.3)
especially for writes. I actually made the test on several different
machines (same hard drives though) and it remained consistent across
the board, with /mountpoint a software RAID-1.
Actually checking disk activity with iostat or vmstat shows clearly a
cache effect much more pronounced on 2.4 (i.e. writing goes on much
longer in the background) but it doesn't really account for the
difference. I've also tested it thru NFS from another machine (Giga
ethernet network):

dd if=/dev/zero of=/mountpoint/testfile bs=1M count=1024

kernel        2.4       2.6        2.4 thru NFS   2.6 thru NFS

write        90 MB/s    65 MB/s      70 MB/s       45 MB/s
read         90 MB/s    80 MB/s      75 MB/s       65 MB/s

Duh. That's terrible. Does it mean I should stick to  (heavily
patched...) 2.4 for my file servers or... ? :)

-- 
--------------------------------------------------
Emmanuel Florac               www.intellique.com   
--------------------------------------------------
