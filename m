Return-Path: <linux-kernel-owner+w=401wt.eu-S1763614AbXEWVGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763614AbXEWVGT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 17:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756100AbXEWVGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 17:06:12 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:34682 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755632AbXEWVGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 17:06:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=oWt2CUee8s/x40cP/CO3eO5oqR1TIHtzpUHAg/52Q7/aslsQutn+pl4DH+19NcRsxvuteo4ay9C5Twos5X4HbgCrUb8ewdtn0rBoTCKScCUkfgpNycJho8ig95ZuPFXLq9gvzvlOm2HrxrCocHN2FDCmLxL8nGWmiBNqm67HS+E=
Message-ID: <4654AC94.6080601@googlemail.com>
Date: Wed, 23 May 2007 23:05:24 +0200
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc2-mm1
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org> <46540DB2.5000605@googlemail.com> <Pine.LNX.4.64.0705231016330.20031@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0705231016330.20031@schroedinger.engr.sgi.com>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter napisał(a):
> On Wed, 23 May 2007, Michal Piotrowski wrote:
> 
>> Christoph, this looks like a bug in SLUB.
> 
> Please boot with slub_debug to find the bad code that overwrites a slab 
> object after it was freed.
> 
> 

[   19.096577] Real Time Clock Driver v1.12ac
[   21.650315] *** SLUB kmalloc-8: Redzone Active@0xc90f6d20 slab 0xc528c530
[   21.657365]     offset=3360 flags=0x400000c3 inuse=61 freelist=0xc90f6d58
[   21.664349]   Bytes b4 0xc90f6d10:  00 00 00 00 00 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a ........ZZZZZZZZ
[   21.674305]     Object 0xc90f6d20:  31 30 31 39 2e 30 30 35                         1019.005        
[   21.684259]    Redzone 0xc90f6d28:  00 cc cc cc                                     .ллл            
[   21.694265] FreePointer 0xc90f6d2c -> 0xc90f6d58
[   21.699061] Last alloc: get_modalias+0x61/0xf5 jiffies_ago=53 cpu=1 pid=554
[   21.706362]     Filler 0xc90f6d50:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
[   21.716364]  [<c010523d>] dump_trace+0x63/0x1eb
[   21.721117]  [<c01053df>] show_trace_log_lvl+0x1a/0x2f
[   21.726466]  [<c010601d>] show_trace+0x12/0x14
[   21.731096]  [<c0106035>] dump_stack+0x16/0x18
[   21.735790]  [<c017e0fa>] object_err+0x143/0x14b
[   21.740575]  [<c017e2cc>] check_object+0x66/0x234
[   21.745582]  [<c017eb43>] __slab_free+0x239/0x384
[   21.750503]  [<c017f446>] kfree+0xa6/0xc6
[   21.754706]  [<c02e2335>] get_modalias+0xb9/0xf5
[   21.759517]  [<c02e23b7>] dmi_dev_uevent+0x27/0x3c
[   21.764537]  [<c027866a>] dev_uevent+0x1ad/0x1da
[   21.769429]  [<c0205024>] kobject_uevent_env+0x20a/0x45b
[   21.774970]  [<c020527f>] kobject_uevent+0xa/0xf
[   21.779834]  [<c02779f1>] store_uevent+0x4f/0x58
[   21.784678]  [<c027758e>] dev_attr_store+0x29/0x2f
[   21.789688]  [<c01bec4f>] sysfs_write_file+0x16e/0x19c
[   21.795022]  [<c0183ba7>] vfs_write+0xd1/0x15a
[   21.799673]  [<c01841d7>] sys_write+0x3d/0x72
[   21.804284]  [<c0104112>] sysenter_past_esp+0x5f/0x99
[   21.809606]  [<b7f7b410>] 0xb7f7b410
[   21.813379]  =======================
[   21.817083] @@@ SLUB kmalloc-8: Restoring redzone (0xcc) from 0xc90f6d28-0xc90f6d2b

Here is another one

[    0.182216] PM: Adding info for No Bus:id
[    0.182333] *** SLUB kmalloc-8: Redzone Active@0xc7838188 slab 0xc521cfc0
[    0.182395]     offset=392 flags=0x400000c3 inuse=8 freelist=0xc78381c0
[    0.182455]   Bytes b4 0xc7838178:  00 00 00 00 00 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a ........ZZZZZZZZ
[    0.183299]     Object 0xc7838188:  31 30 31 39 2e 30 30 35                         1019.005        
[    0.184141]    Redzone 0xc7838190:  00 cc cc cc                                     .ллл            
[    0.184980] FreePointer 0xc7838194 -> 0xc78381c0
[    0.185038] Last alloc: get_modalias+0x61/0xf5 jiffies_ago=0 cpu=0 pid=1
[    0.185196]     Filler 0xc78381b8:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
[    0.186043]  [<c010523d>] dump_trace+0x63/0x1eb
[    0.186155]  [<c01053df>] show_trace_log_lvl+0x1a/0x2f
[    0.186262]  [<c010601d>] show_trace+0x12/0x14
[    0.186368]  [<c0106035>] dump_stack+0x16/0x18
[    0.187567]  [<c017e0fa>] object_err+0x143/0x14b
[    0.187677]  [<c017e2cc>] check_object+0x66/0x234
[    0.187788]  [<c017eb43>] __slab_free+0x239/0x384
[    0.187895]  [<c017f446>] kfree+0xa6/0xc6
[    0.188001]  [<c02e2335>] get_modalias+0xb9/0xf5
[    0.188111]  [<c02e23b7>] dmi_dev_uevent+0x27/0x3c
[    0.188219]  [<c027866a>] dev_uevent+0x1ad/0x1da
[    0.188328]  [<c0205024>] kobject_uevent_env+0x20a/0x45b
[    0.188438]  [<c020527f>] kobject_uevent+0xa/0xf
[    0.188544]  [<c02782bd>] device_add+0x274/0x45f
[    0.188650]  [<c02784ba>] device_register+0x12/0x15
[    0.188761]  [<c0504d25>] dmi_id_init+0x256/0x26c
[    0.188869]  [<c04ec505>] kernel_init+0x14e/0x2bf
[    0.188976]  [<c0104e0b>] kernel_thread_helper+0x7/0x10
[    0.189083]  =======================
[    0.189143] @@@ SLUB kmalloc-8: Restoring redzone (0xcc) from 0xc7838190-0xc7838193

http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.22-rc2-mm1/mm-dmesg
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.22-rc2-mm1/mm-config

Regards,
Michal

-- 
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
