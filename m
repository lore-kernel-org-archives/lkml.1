Return-Path: <linux-kernel-owner+w=401wt.eu-S1758661AbZCZOyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758661AbZCZOyx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 10:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757282AbZCZOyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 10:54:44 -0400
Received: from cadalboia.ferrara.linux.it ([195.110.122.101]:51945 "EHLO
	cadalboia.ferrara.linux.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756782AbZCZOyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 10:54:44 -0400
X-Greylist: delayed 665 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Mar 2009 10:54:43 EDT
From: Fabio Coatti <cova@ferrara.linux.it>
Organization: FerraraLUG
To: linux-kernel@vger.kernel.org
Subject: server lockups - task blocked for more than 120 seconds
Date: Thu, 26 Mar 2009 15:43:35 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.28.8; KDE/4.2.1; i686; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903261543.35383.cova@ferrara.linux.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all, as we are experiencing several lockups on productions servers, we 
activated some kernel debug options in order to look into causes. One thing 
that we have found on kernel log is the message " task blocked for more than 
120 seconds", just before the lockup.I don't know if this is a symptom useful 
or not, so I'm posting here the message just to have some hints.
Machine is a 2xAMD 2216 (dual core) - 64bit with 2.6.28.8 kernel.
Of course I can post more detail (config and so on), but to avoit to clobber 
the list I'll just wait to hear some hints, so to understand if this can be a 
kernel problem symptom or something nothing worth to look at further.

Many thanks in advance for any answer; please leave my address in CC: list as 
I'm not subscribed to lkml at this moment, thanks.

=================================
The messages we found in log is the following:
Mar 26 13:05:17 sys@test01 kernel: [ 8295.782985] INFO: task perl:32211 
blocked for more than 120 seconds.
Mar 26 13:05:17 sys@test01 kernel: [ 8295.783202] "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar 26 13:05:17 sys@test01 kernel: [ 8295.783614] perl          D 
ffff880015464540  3832 32211   9340
Mar 26 13:05:17 sys@test01 kernel: [ 8295.783829]  ffff880015619e38 
0000000000000046 0000000000000000 0000000000000046
Mar 26 13:05:17 sys@test01 kernel: [ 8295.784251]  0000000000000000 
ffff880015464540 ffff880013cc33f0 ffff880015464768
Mar 26 13:05:17 sys@test01 kernel: [ 8295.784669]  0000000215619e38 
0000000000000046 0000000000000000 ffffffff80298122
Mar 26 13:05:17 sys@test01 kernel: [ 8295.785087] Call Trace:
Mar 26 13:05:17 sys@test01 kernel: [ 8295.785297]  [<ffffffff80298122>] ? 
generic_file_llseek+0x2c/0x5d
Mar 26 13:05:17 sys@test01 kernel: [ 8295.785512]  [<ffffffff805b85e5>] 
__mutex_lock_common+0x208/0x30a
Mar 26 13:05:17 sys@test01 kernel: [ 8295.785726]  [<ffffffff80298122>] ? 
generic_file_llseek+0x2c/0x5d
Mar 26 13:05:17 sys@test01 kernel: [ 8295.785940]  [<ffffffff80298122>] ? 
generic_file_llseek+0x2c/0x5d
Mar 26 13:05:17 sys@test01 kernel: [ 8295.786154]  [<ffffffff802a2fb0>] ? 
do_vfs_ioctl+0x37f/0x3c4
Mar 26 13:05:17 sys@test01 kernel: [ 8295.786372]  [<ffffffff80295f1c>] ? 
do_sys_open+0xcb/0xda
Mar 26 13:05:17 sys@test01 kernel: [ 8295.786584]  [<ffffffff805b8727>] 
mutex_lock_nested+0x14/0x16
Mar 26 13:05:17 sys@test01 kernel: [ 8295.786810]  [<ffffffff80298122>] 
generic_file_llseek+0x2c/0x5d
Mar 26 13:05:17 sys@test01 kernel: [ 8295.787026]  [<ffffffff80297175>] 
vfs_llseek+0x35/0x37
Mar 26 13:05:17 sys@test01 kernel: [ 8295.787237]  [<ffffffff8029726c>] 
sys_lseek+0x44/0x60
Mar 26 13:05:17 sys@test01 kernel: [ 8295.787453]  [<ffffffff8020b53b>] 
system_call_fastpath+0x16/0x1b
Mar 26 13:05:17 sys@test01 kernel: [ 8295.787669] INFO: lockdep is turned off.



