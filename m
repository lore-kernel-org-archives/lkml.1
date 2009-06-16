Return-Path: <linux-kernel-owner+w=401wt.eu-S1764596AbZFPUom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764596AbZFPUom (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:44:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760299AbZFPUk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:40:58 -0400
Received: from bar.sig21.net ([80.81.252.164]:56551 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759783AbZFPUkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:40:51 -0400
Date: Tue, 16 Jun 2009 22:40:39 +0200
From: Johannes Stezenbach <js@sig21.net>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "rjw@sisk.pl" <rjw@sisk.pl>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "davej@redhat.com" <davej@redhat.com>, "pavel@ucw.cz" <pavel@ucw.cz>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "lenb@kernel.org" <lenb@kernel.org>,
       "arjan@infradead.org" <arjan@infradead.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: 2.6.30: hibernation/swsusp lockup due to acpi-cpufreq
Message-ID: <20090616204039.GA13399@sig21.net>
References: <20090615232709.GA6059@sig21.net> <200906160216.29537.rjw@sisk.pl> <20090616142217.GA5548@sig21.net> <20090616115540.ceb67a30.akpm@linux-foundation.org> <20090616195750.GA12814@sig21.net> <20090616202558.GA5423@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090616202558.GA5423@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Spam-21-Score: -3.5 (---)
X-Spam-21-Report: No, score=-3.5 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.855,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 01:25:58PM -0700, Pallipadi, Venkatesh wrote:
> 
> Can you try the patch below (your changes + a warnon). That should give
> the stack trace with successful suspend-resume.
> 
> acpi-cpufreq will not directly disable interrupt and call these routines.
> So, it will be interesting to see how we are ending up in this state.

Yes, I actually had the same idea and just did it ;-)
I also found this:
http://lkml.org/lkml/2007/7/17/674

------------[ cut here ]------------                                                                            
WARNING: at kernel/up.c:18 smp_call_function_single+0x45/0x60()                                                 
Hardware name: 2373Y4M                                                                                          
Modules linked in: ath5k mac80211 cfg80211 uhci_hcd ehci_hcd                                                    
Pid: 4139, comm: bash Not tainted 2.6.30 #8                                                                     
Call Trace:                                                                                                     
 [<c011ea0d>] warn_slowpath_common+0x60/0x90                                                                    
 [<c010d86c>] ? do_drv_read+0x0/0x31                                                                            
 [<c011ea4a>] warn_slowpath_null+0xd/0x10                                                                       
 [<c013acc1>] smp_call_function_single+0x45/0x60                                                                
 [<c010d4e5>] get_cur_val+0x62/0x6c                                                                             
 [<c010d72f>] get_cur_freq_on_cpu+0x35/0x58                                                                     
 [<c03786e9>] cpufreq_suspend+0x76/0xd9                                                                         
 [<c0136c3b>] ? clockevents_notify+0x1e/0x68                                                                    
 [<c02ff570>] sysdev_suspend+0x4e/0x182                                                                         
 [<c013fd28>] hibernation_snapshot+0x89/0x16b                                                                   
 [<c013fe99>] hibernate+0x8f/0x147                                                                              
 [<c013ec82>] ? state_store+0x0/0xa2                                                                            
 [<c013ecd7>] state_store+0x55/0xa2                                                                             
 [<c013ec82>] ? state_store+0x0/0xa2                                                                            
 [<c024dff5>] kobj_attr_store+0x1a/0x22                                                                         
 [<c01a7164>] sysfs_write_file+0xb4/0xdf                                                                        
 [<c01a70b0>] ? sysfs_write_file+0x0/0xdf                                                                       
 [<c0170cf2>] vfs_write+0x8a/0x12c                                                                              
 [<c0170e2d>] sys_write+0x3b/0x60                                                                               
 [<c01028f4>] sysenter_do_call+0x12/0x26                                                                        
---[ end trace 1c2172bce3982a59 ]---                                                                            


Johannes
