Return-Path: <linux-kernel-owner+w=401wt.eu-S932352AbZHCPYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932352AbZHCPYm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 11:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932328AbZHCPYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 11:24:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42212 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932287AbZHCPYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 11:24:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Gene Heskett <gene.heskett@verizon.net>
Subject: Re: [Bug #13899] Oops from tar, 2.6.31-rc5, 32 bit on quad core phenom.
Date: Mon, 3 Aug 2009 17:25:18 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc5-rjw; KDE/4.2.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <Su1q3S6JjyO.A.jeB.hcgdKB@chimera> <iZB3Pj-uj3M.A.TjB.lcgdKB@chimera> <200908022034.41252.gene.heskett@verizon.net>
In-Reply-To: <200908022034.41252.gene.heskett@verizon.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908031725.19100.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 August 2009, Gene Heskett wrote:
> On Sunday 02 August 2009, Rafael J. Wysocki wrote:
> >This message has been generated automatically as a part of a report
> >of recent regressions.
> >
> >The following bug entry is on the current list of known regressions
> >from 2.6.30.  Please verify if it still should be listed and let me know
> >(either way).
> >
> >
> >Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13899
> >Subject		: Oops from tar, 2.6.31-rc5, 32 bit on quad core phenom.
> >Submitter	: Gene Heskett <gene.heskett@verizon.net>
> >Date		: 2009-08-01 13:04 (2 days old)
> >References	: http://marc.info/?l=linux-kernel&m=124913190304149&w=4
> At this time I am not sure about this one.  Amanda ran normally AFAIK this 
> morning.
> 
> The machine does not appear to be affected, but I did just find this,
> in /var/log/messages: (I think this is the one I posted)
> 
> Aug  1 01:15:01 coyote xinetd[2316]: START: amanda pid=18959 from=::ffff:192.168.71.3                                                  
> Aug  1 01:16:17 coyote kernel: [ 7423.221754] BUG: Bad page state in process tar  pfn:a1293                                            
> Aug  1 01:16:17 coyote kernel: [ 7423.221760] page:c28fc260 flags:80004000 count:0 mapcount:0 mapping:(null) index:0                   
> Aug  1 01:16:17 coyote kernel: [ 7423.221764] Pid: 19211, comm: tar Not tainted 2.6.31-rc5 #1                                          
> Aug  1 01:16:17 coyote kernel: [ 7423.221766] Call Trace:                                                                              
> Aug  1 01:16:17 coyote kernel: [ 7423.221774]  [<c130b0e3>] ? printk+0x23/0x40                                                         
> Aug  1 01:16:17 coyote kernel: [ 7423.221780]  [<c1083d6f>] bad_page+0xcf/0x150                                                        
> Aug  1 01:16:17 coyote kernel: [ 7423.221784]  [<c1084e0d>] get_page_from_freelist+0x37d/0x480                                         
> Aug  1 01:16:17 coyote kernel: [ 7423.221788]  [<c107ed54>] ? add_to_page_cache_lru+0x84/0x90                                          
> Aug  1 01:16:17 coyote kernel: [ 7423.221791]  [<c10850ef>] __alloc_pages_nodemask+0xdf/0x520                                          
> Aug  1 01:16:17 coyote kernel: [ 7423.221795]  [<c1087954>] __do_page_cache_readahead+0x104/0x220                                      
> Aug  1 01:16:17 coyote kernel: [ 7423.221798]  [<c1087aa4>] ra_submit+0x34/0x50                                                        
> Aug  1 01:16:17 coyote kernel: [ 7423.221801]  [<c1087d00>] ondemand_readahead+0x120/0x240                                             
> Aug  1 01:16:17 coyote kernel: [ 7423.221804]  [<c1087ebc>] page_cache_async_readahead+0x9c/0xb0                                       
> Aug  1 01:16:17 coyote kernel: [ 7423.221807]  [<c10806ac>] generic_file_aio_read+0x33c/0x6a0                                          
> Aug  1 01:16:17 coyote kernel: [ 7423.221830]  [<c10b09c9>] do_sync_read+0xe9/0x140                                                    
> Aug  1 01:16:17 coyote kernel: [ 7423.221835]  [<c104e400>] ? autoremove_wake_function+0x0/0x60                                        
> Aug  1 01:16:17 coyote kernel: [ 7423.221839]  [<c115211e>] ? security_file_permission+0x1e/0x40                                       
> Aug  1 01:16:17 coyote kernel: [ 7423.221842]  [<c10b0a80>] ? rw_verify_area+0x60/0xe0                                                 
> Aug  1 01:16:17 coyote kernel: [ 7423.221845]  [<c10b1827>] vfs_read+0xb7/0x180                                                        
> Aug  1 01:16:17 coyote kernel: [ 7423.221848]  [<c10b08e0>] ? do_sync_read+0x0/0x140                                                   
> Aug  1 01:16:17 coyote kernel: [ 7423.221850]  [<c10b19f8>] sys_read+0x58/0xa0                                                         
> Aug  1 01:16:17 coyote kernel: [ 7423.221854]  [<c10031b7>] sysenter_do_call+0x12/0x22                                                 
> Aug  1 01:16:17 coyote kernel: [ 7423.221856] Disabling lock debugging due to kernel taint                                             
> Aug  1 01:20:31 coyote xinetd[2316]: EXIT: amanda status=0 pid=18959 duration=330(sec)                                                 
> Aug  1 01:20:34 coyote xinetd[2316]: START: amanda pid=19523 from=::ffff:192.168.71.3         
> 
> [snip extraneous stuff from my router that goes to syslog]
> 
> Aug  1 02:45:05 coyote xinetd[2316]: EXIT: amanda status=0 pid=19523 duration=5071(sec)                                                
> Aug  1 02:45:07 coyote xinetd[2316]: START: amanda pid=21465 from=::ffff:192.168.71.3                                                  
> Aug  1 02:46:07 coyote xinetd[2316]: EXIT: amanda status=0 pid=21465 duration=60(sec)                                                  
> Aug  1 02:46:19 coyote xinetd[2316]: START: amanda pid=21545 from=::ffff:192.168.71.3                                                  
> Aug  1 02:46:49 coyote xinetd[2316]: EXIT: amanda status=0 pid=21545 duration=30(sec)                                                  
> Aug  1 02:46:50 coyote xinetd[2316]: START: amanda pid=21572 from=::ffff:192.168.71.3                                                  
> Aug  1 02:47:20 coyote xinetd[2316]: EXIT: amanda status=0 pid=21572 duration=30(sec)                                                  
> Aug  1 02:47:21 coyote xinetd[2316]: START: amanda pid=21604 from=::ffff:192.168.71.3                                                  
> Aug  1 02:48:51 coyote xinetd[2316]: EXIT: amanda status=0 pid=21604 duration=90(sec)
> [then this morning]
> Aug  2 01:36:10 coyote xinetd[2316]: EXIT: amanda status=0 pid=11552 duration=540(sec)                                                 
> Aug  2 01:36:11 coyote xinetd[2316]: START: amanda pid=11801 from=::ffff:192.168.71.3
> Aug  2 01:54:41 coyote xinetd[2316]: EXIT: amanda status=0 pid=11801 duration=1110(sec)                                                
> Aug  2 01:54:46 coyote xinetd[2316]: START: amanda pid=12247 from=::ffff:192.168.71.3                                                  
> Aug  2 01:57:16 coyote xinetd[2316]: EXIT: amanda status=0 pid=12247 duration=150(sec)                                                 
> Aug  2 01:57:30 coyote xinetd[2316]: START: amanda pid=12360 from=::ffff:192.168.71.3                                                  
> Aug  2 01:58:00 coyote xinetd[2316]: EXIT: amanda status=0 pid=12360 duration=30(sec)                                                  
> Aug  2 01:58:00 coyote xinetd[2316]: START: amanda pid=12387 from=::ffff:192.168.71.3                                                  
> Aug  2 01:58:30 coyote xinetd[2316]: EXIT: amanda status=0 pid=12387 duration=30(sec)                                                  
> Aug  2 01:58:30 coyote xinetd[2316]: START: amanda pid=12414 from=::ffff:192.168.71.3                                                  
> Aug  2 01:59:30 coyote xinetd[2316]: EXIT: amanda status=0 pid=12414 duration=60(sec)                                                  
> Aug  2 01:59:45 coyote xinetd[2316]: START: amanda pid=12482 from=::ffff:192.168.71.3                                                  
> Aug  2 02:00:15 coyote xinetd[2316]: EXIT: amanda status=0 pid=12482 duration=30(sec)                                                  
> Aug  2 02:00:30 coyote xinetd[2316]: START: amanda pid=12535 from=::ffff:192.168.71.3                                                  
> Aug  2 02:01:00 coyote xinetd[2316]: EXIT: amanda status=0 pid=12535 duration=30(sec)
> 
> So it did not repeat the Ooops this morning.  I wish I had more clues to offer.
> Let it ride as is for another 4 or 5 days, during which time I may have a good
> excuse to reboot & restart this -rc5 from scratch.  Or maybe someone else might also
> note it, but if not watching the log, I think its otherwise silent & may go by
> un-noticed.

Thanks for the update.

Rafael
