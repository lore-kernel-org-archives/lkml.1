Return-Path: <linux-kernel-owner+w=401wt.eu-S1763719AbXHJWZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763719AbXHJWZp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 18:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759465AbXHJWZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 18:25:18 -0400
Received: from in.cluded.net ([195.159.98.120]:50328 "EHLO in.cluded.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758979AbXHJWZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 18:25:15 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Aug 2007 18:25:14 EDT
Message-ID: <46BCE380.60508@cluded.net>
Date: Fri, 10 Aug 2007 22:15:28 +0000
From: "Daniel K." <daniel@cluded.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9a1) Gecko/20060307 SeaMonkey/1.5a
MIME-Version: 1.0
To: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: BUG: when using 'brctl stp'
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I get this on the latest GIT, it was also present shortly after -rc1.
I have not tested with earlier kernels.

# brctl stp br0 on
[  169.672008] BUG: sleeping function called from invalid context at kernel/mutex.c:86
[  169.672532] in_atomic():1, irqs_disabled():0
[  169.672832] 
[  169.672832] Call Trace:
[  169.673406]  [<ffffffff8125db3a>] mutex_lock+0x19/0x2f
[  169.673696]  [<ffffffff81067135>] __alloc_pages+0x71/0x2d3
[  169.673996]  [<ffffffff881e0abc>] :bridge:set_stp_state+0x12/0x37
[  169.674293]  [<ffffffff881e0a0a>] :bridge:store_bridge_parm+0x5f/0x79
[  169.674587]  [<ffffffff810ceb24>] sysfs_write_file+0xf2/0x134
[  169.674879]  [<ffffffff8108b3ad>] vfs_write+0xce/0x177
[  169.675170]  [<ffffffff8108b970>] sys_write+0x45/0x6e
[  169.675463]  [<ffffffff8100bc8e>] system_call+0x7e/0x83
[  169.675769] 
[  169.676139] br0: starting userspace STP failed, staring kernel STP

# brctl stp br0 off
[  171.774500] BUG: sleeping function called from invalid context at kernel/mutex.c:86
[  171.775040] in_atomic():1, irqs_disabled():0
[  171.775327] 
[  171.775328] Call Trace:
[  171.775906]  [<ffffffff8125db3a>] mutex_lock+0x19/0x2f
[  171.776195]  [<ffffffff81067135>] __alloc_pages+0x71/0x2d3
[  171.776496]  [<ffffffff881e0abc>] :bridge:set_stp_state+0x12/0x37
[  171.776792]  [<ffffffff881e0a0a>] :bridge:store_bridge_parm+0x5f/0x79
[  171.777086]  [<ffffffff810ceb24>] sysfs_write_file+0xf2/0x134
[  171.777378]  [<ffffffff8108b3ad>] vfs_write+0xce/0x177
[  171.777669]  [<ffffffff8108b970>] sys_write+0x45/0x6e
[  171.777958]  [<ffffffff8100bc8e>] system_call+0x7e/0x83
[  171.778250] 


Daniel K.
