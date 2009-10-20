Return-Path: <linux-kernel-owner+w=401wt.eu-S1752613AbZJTQL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbZJTQL3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 12:11:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752522AbZJTQL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 12:11:29 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:38287 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469AbZJTQL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 12:11:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=mwwoQqy8YwF8baHEQW8WOOnupyroduryyFLO9unl78d5noBqSEhFn/sS+tu6FO4q0i
         0EM6JCu9DTbPLuCUdm4z9MNhlK4qhNhuyGdfLUgqAOiSAAPZSTvqQsPAARXGF2mXIBla
         yGhLI4M+b1qz490lbXEWp/hfthuDy1AOxXNgM=
Message-ID: <4ADDE11E.6030502@gmail.com>
Date: Tue, 20 Oct 2009 12:11:10 -0400
From: Miles Lane <miles.lane@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.sourceforge.net
Subject: 2.6.32-rc5-git1 -- 2 locks held by cat -- running "find /sys | head
 -c 4" --> system hang
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2 locks held by cat/4179:
  #0:  (&p->lock){+.+.+.}, at: [<c10a3884>] seq_read+0x25/0x315
  #1:  (&dev_priv->mm.active_list_lock){+.+...}, at: [<c119a854>] i915_batchbuffer_info+0x2b/0x124
Pid: 4179, comm: cat Not tainted 2.6.32-rc5-git1 #2
Call Trace:
  [<c104874f>] ? __debug_show_held_locks+0x1e/0x20
  [<c1023fb0>] __might_sleep+0xf0/0xf7
  [<c101c393>] kmap+0x17/0x58
  [<c119a8d6>] i915_batchbuffer_info+0xad/0x124
  [<c10a39bf>] seq_read+0x160/0x315
  [<c108fb8c>] ? rw_verify_area+0x98/0xbb
  [<c10a385f>] ? seq_read+0x0/0x315
  [<c1090331>] vfs_read+0x75/0xa9
  [<c10903f9>] sys_read+0x3b/0x5d
  [<c1002a8f>] sysenter_do_call+0x12/0x36
