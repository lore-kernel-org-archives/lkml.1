Return-Path: <linux-kernel-owner+w=401wt.eu-S1758648AbZB0RBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758648AbZB0RBl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 12:01:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756510AbZB0RBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 12:01:34 -0500
Received: from mtagate7.de.ibm.com ([195.212.29.156]:48433 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756462AbZB0RBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 12:01:33 -0500
Date: Fri, 27 Feb 2009 18:01:05 +0100
From: Christof Schmitt <christof.schmitt@de.ibm.com>
To: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au
Subject: Command line parameter not passed to module in linux-next
Message-ID: <20090227170105.GA22304@schmichrtp.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The linux-next kernel does not pass charp parameters from the kernel
command line to modules:

# cat /proc/cmdline 
dasd=4d70-4d73 root=/dev/dasdc1 zfcp.device=0.0.181d,0x500507630310c562,0x401040C300000000 zfcp.dbfsize=4096  BOOT_IMAGE=0 

# cat /sys/module/zfcp/parameters/device 
<NULL>

It seems that this patches introduces the problem:
	commit 9f229de63cf02297c0e0fbaa8d74b962cceff435
	Author: Rusty Russell <rusty@rustcorp.com.au>
	Date:   Fri Feb 20 10:31:19 2009 +1100

	    param:fix-charp-sysfs-write

Reverting the patch on linux-next fixes the problem:

# cat /sys/module/zfcp/parameters/device 
0.0.181d,0x500507630310c562,0x401040C300000000

--
Christof Schmitt
