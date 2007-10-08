Return-Path: <linux-kernel-owner+w=401wt.eu-S1755993AbXJHNA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993AbXJHNA0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 09:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753919AbXJHNAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 09:00:13 -0400
Received: from main.gmane.org ([80.91.229.2]:36618 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754450AbXJHNAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 09:00:11 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bernd Schubert <bs@q-leap.de>
Subject: 2.6.23 regression: do_nanosleep will not return
Date: Mon, 08 Oct 2007 14:50:55 +0200
Organization: q-leap networks GmbH
Message-ID: <fed93g$eq4$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: ns1.q-leap.de
User-Agent: KNode/0.10.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

we have a system here were e.g. "sleep 1" will never finish. This is an 
issue of 2.6.23, on all older kernel versions it did work fine.

Seems to hang in do_nanosleep() 

[  153.775792] sleep         S 0000000000000000     0  5372   5341              
[  153.782385]  ffff81007f0a9ea8 0000000000000082 0000000000000000 0000000000008efc                                                                             
[  153.790635]  ffff81007f0a9e48 ffffffff802447b4 ffff81007f0c3080 0000000300000000                                                                             
[  153.798938]  ffff81007f0c39c8 ffff81007f0c37c0 000000004001d908 0000000000000000                                                                             
[  153.806991] Call Trace:                                                      
[  153.809937]  [<ffffffff8048e4cd>] do_nanosleep+0x42/0x75                     
[  153.815727]  [<0000000000000001>]                                            
[  153.819383]                                                                  
[  153.775792] sleep         S 0000000000000000     0  5372   5341              


[  330.669444] SysRq : Show Pending Timers                                      
[  330.673552] Timer List Version: v0.3                                         
[  330.677326] HRTIMER_MAX_CLOCK_BASES: 2                                       
[  330.681282] now at 255011372633 nsecs                                        
[  330.829981] active timers:                                                   
[  330.832859]  #0: <ffff81007f0e3de8>, hrtimer_wakeup, S:01                    
[  330.838805]  # expires at 260156346358 nsecs [in 5144973725 nsecs]           

[  337.046189] now at 261387685432 nsecs                                        
[  337.194966] active timers:                                                   
[  337.197834]  #0: <ffff81007f0e3de8>, hrtimer_wakeup, S:01                    
[  337.203793]  # expires at 260156346358 nsecs [in 18446744072478212542 nsecs] 
[  330.669444] SysRq : Show Pending Timers


Any ideas?

Thanks,
Bernd

