Return-Path: <linux-kernel-owner+w=401wt.eu-S1765161AbYBMGYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765161AbYBMGYT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 01:24:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753119AbYBMGYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 01:24:11 -0500
Received: from sj-iport-1.cisco.com ([171.71.176.70]:17862 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823AbYBMGYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 01:24:09 -0500
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>
Subject: Strange hang on ia64 with CONFIG_PRINTK_TIME=y
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 12 Feb 2008 22:24:05 -0800
Message-ID: <adazlu5tlve.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 13 Feb 2008 06:24:06.0279 (UTC) FILETIME=[08E11970:01C86E09]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm seeing a strange hang with current git (head 96b5a46e) on an ia64
box -- an Intel SDV with 2 dual core hyperthreaded Itanium 2 CPUs (so
8 logical CPUs to the kernel).  It hangs without printing anything
("Uncompressing Linux... done" from ELILO is the last thing I see) if
I have CONFIG_PRINTK_TIME=y; it works fine with CONFIG_PRINTK_TIME=n.

The really strange thing is that I have bisected this down to 326e96b9
("printk: revert ktime_get() timestamps"), and verified that if revert
this one patch on top of my current git tree, then the kernel boots
fine with CONFIG_PRINTK_TIME=y.  The strange thing is that I have also
checked that the real v2.6.24 kernel boots fine on this system, and as
far as I can tell, 2.6.24 didn't have the commit that 326e96b9 reverts
(19ef9309), so there is some interaction with another patch that made
19ef9309 necessary on my system.

Any good idea how to debug this, given that the broken kernels don't
give any output at all?

Thanks,
  Roland
