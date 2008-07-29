Return-Path: <linux-kernel-owner+w=401wt.eu-S1759579AbYG2OeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759579AbYG2OeZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 10:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758207AbYG2OeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 10:34:15 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:40015 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759485AbYG2OeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 10:34:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=RpG3jB3/RNlNpe1gGT72bZpvpccF0LMiNgMvsWXZ9rPK3MSNF3825o19NfKcd1YVIA
         hfkkeCS1HQ/tbUeE1R4mecwNgt/wjoneaEs3jn7t+/WLkUeZklhIStsn+QYdwkSOAM/k
         rlj0/KQRDvV/seS+48mJiJe+FkRXP5h1MGTaM=
Message-ID: <488F2A65.2090405@gmail.com>
Date: Tue, 29 Jul 2008 16:34:13 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mike Travis <travis@sgi.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: cpu4096 + smp_affinity breakage
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I see cpu4096 branches in -tip. Do you know about /proc/irq/*/*smp_affinity 
(irq_affinity_read_proc, default_affinity_read) breakage with NR_CPUS=4096? 
Reading by `cat' from those files fails due to bitmap sent out is about 1150 
bytes, but cat provides only 1024B sized buffer. Can you think about any fix 
for this?

Using file offset and utilize only portion of that buffer returned to the 
userspace will break atomicity I guess (does this matter?). If we get a 
snapshot, it would get old if some reader breaks up. And if we use 
per-reader buffer, we will be unable to free it. Any ideas?

I think the same problem is for not-at-once-writes.
