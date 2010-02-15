Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642Ab0BOWzJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 17:55:09 -0500
Received: from mtagate6.uk.ibm.com ([194.196.100.166]:34233 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756404Ab0BOWzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 17:55:07 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
Organization: IBM
To: Dave Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>
Subject: Re: [git pull] drm
Date: Mon, 15 Feb 2010 23:55:03 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc8-prerelease; KDE/4.3.4; x86_64; ; )
Cc: torvalds@linux-foundation.org, dri-devel@lists.sf.net,
       linux-kernel@vger.kernel.org, Maarten Maathuis <madman2003@gmail.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
References: <alpine.DEB.2.00.1002110417200.516@skynet.skynet.ie> <201002151053.48681.borntraeger@de.ibm.com>
In-Reply-To: <201002151053.48681.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201002152355.03161.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 15 Februar 2010 10:53:48 schrieb Christian Borntraeger:
I think this regression is triggered by

commit 39c9bfb453b748ce220ceefacbe2a5c19fabf67b
Author: Ben Skeggs <bskeggs@redhat.com>
Date:   Tue Feb 9 10:22:29 2010 +1000

    drm/nv50: prevent multiple init tables being parsed at the same time

One possible solution is to replace the spinlock bios->lock with a mutex, 
but there are others ways of fixing this BUG.

CCing Ben.



> [    2.175437] BUG: scheduling while atomic: nouveau/0/753/0x00000002                                                                                                       
> [    2.175439] Modules linked in:                                                                                                                                           
> [    2.175442] Pid: 753, comm: nouveau/0 Not tainted 2.6.33-rc8-prerelease #27                                                                                              
> [    2.175443] Call Trace:                                                                                                                                                  
> [    2.175451]  [<ffffffff815dcdea>] ? schedule+0x86a/0x880                                                                                                                 
> [    2.175454]  [<ffffffff8120a420>] ? vsnprintf+0xe0/0x9a0                                                                                                                 
> [    2.175456]  [<ffffffff815dd18c>] ? schedule_timeout+0x15c/0x250                                                                                                         
> [    2.175460]  [<ffffffff81068570>] ? process_timeout+0x0/0x10                                                                                                             
> [    2.175462]  [<ffffffff81069068>] ? msleep+0x18/0x30                                                                                                                     
> [    2.175466]  [<ffffffff812d48d1>] ? init_time+0x51/0x90                                                                                                                  
> [    2.175468]  [<ffffffff812d3ffb>] ? parse_init_table+0xcb/0x1a0                                                                                                          
> [    2.175470]  [<ffffffff812d424a>] ? init_sub_direct+0x4a/0xd0                                                                                                            
> [    2.175472]  [<ffffffff812d3ffb>] ? parse_init_table+0xcb/0x1a0                                                                                                          
> [    2.175474]  [<ffffffff812d496f>] ? nouveau_bios_run_init_table+0x5f/0xa0                                                                                                
> [    2.175476]  [<ffffffff812d4c0c>] ? nouveau_bios_run_display_table+0x25c/0x500                                                                                           
> [    2.175480]  [<ffffffff812fd220>] ? nv50_display_irq_handler_bh+0x0/0x410                                                                                                
> [    2.175483]  [<ffffffff812fd4cc>] ? nv50_display_irq_handler_bh+0x2ac/0x410                                                                                              
> [    2.175485]  [<ffffffff812fd220>] ? nv50_display_irq_handler_bh+0x0/0x410                                                                                                
> [    2.175487]  [<ffffffff8107047b>] ? worker_thread+0x16b/0x250                                                                                                            
> [    2.175490]  [<ffffffff81074240>] ? autoremove_wake_function+0x0/0x30                                                                                                    
> [    2.175492]  [<ffffffff81070310>] ? worker_thread+0x0/0x250                                                                                                              
> [    2.175494]  [<ffffffff81070310>] ? worker_thread+0x0/0x250                                                                                                              
> [    2.175496]  [<ffffffff81073dbe>] ? kthread+0x8e/0xa0                                                                                                                    
> [    2.175499]  [<ffffffff81027554>] ? kernel_thread_helper+0x4/0x10                                                                                                        
> [    2.175501]  [<ffffffff81073d30>] ? kthread+0x0/0xa0                                                                                                                     
> [    2.175503]  [<ffffffff81027550>] ? kernel_thread_helper+0x0/0x10                                                                                                        
> [    2.182407] Console: switching to colour frame buffer device 240x75                                                                                                      
> [    2.186632] fb0: nouveaufb frame buffer device                                                                                                                           
> [    2.186633] registered panic notifier                                                                                                                                    
> [    2.186636] [drm] Initialized nouveau 0.0.15 20090420 for 0000:01:00.0 on minor 0  
> ...
> 
