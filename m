Return-Path: <linux-kernel-owner+w=401wt.eu-S1755437AbYDQWBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437AbYDQWBr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 18:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753941AbYDQWBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 18:01:38 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:52412 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886AbYDQWBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 18:01:38 -0400
Date: Fri, 18 Apr 2008 00:01:34 +0200 (CEST)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: LKML <linux-kernel@vger.kernel.org>
Subject: BUG: MAX_STACK_TRACE_ENTRIES too low!
Message-ID: <alpine.DEB.1.10.0804172352240.13949@sheep.housecafe.de>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1/PrLqfPJOTELloUtBfaJszHcLfXclV44dvBUW
 Pu/C/RtRH4jcmuGceDxp8CjnU4bbWXqo4mio2ti9nT06YEpoOg
 SJI9gt1S4/vBLYm/NIP9A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

just before upgrading from -rc9 to -final, this showed up in the logs:

BUG: MAX_STACK_TRACE_ENTRIES too low!
turning off the locking correctness validator.
Pid: 30729, comm: mv Not tainted 2.6.25-rc9 #2
  [<c013a842>] save_trace+0x92/0xa0
  [<c013a894>] add_lock_to_list+0x44/0xc0
  [<c013cfe1>] __lock_acquire+0xec1/0xf90
  [<c01756a3>] lock_rename+0x73/0xf0
  [<c013d36c>] lock_release_non_nested+0x10c/0x1b0
  [<c01756a3>] lock_rename+0x73/0xf0
  [<c017573b>] unlock_rename+0x1b/0x60
  [<c013d4a7>] lock_release+0x97/0x170
  [<c04857e3>] __mutex_unlock_slowpath+0x53/0x110
  [<c017573b>] unlock_rename+0x1b/0x60
  [<c017827b>] sys_renameat+0x1fb/0x210
  [<c0486893>] _spin_unlock_irqrestore+0x33/0x60
  [<c016e7b2>] vfs_write+0x102/0x140
  [<c01782b7>] sys_rename+0x27/0x30
  [<c0102eb6>] sysenter_past_esp+0x5f/0xa5
  =======================

A quick search on the net tells me, this has been reported around ~2.6.18, 
but this was back in 2006. My box here is still running fine, and I'm not 
sure how to reproduce this one - there hasn't been much I/O when the BUG 
occured. I just wanted t have this reported...

Full dmesg and .config: http://nerdbynature.de/bits/2.6.25-rc9/

Thanks,
Christian.
-- 
BOFH excuse #339:

manager in the cable duct
