Return-Path: <linux-kernel-owner+w=401wt.eu-S1755550AbZFOMsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550AbZFOMsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 08:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751800AbZFOMsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 08:48:09 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:54750 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751078AbZFOMsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 08:48:08 -0400
Subject: kallsyms broken on ARM by commit 17b1f0d
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: ARM Ltd
Date: Mon, 15 Jun 2009 13:47:43 +0100
Message-Id: <1245070063.16986.22.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Jun 2009 12:47:44.0053 (UTC) FILETIME=[7A20AE50:01C9EDB7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

With the above commit, kallsyms on ARM no longer show correct
information. That's a trace with this commit:

    [<c007bfec>] _etext+0xffd9bfec/0x126d8                                      
    [<c00795e4>] _etext+0xffd995e4/0x126d8                                      
    [<c0147d94>] _etext+0xffe67d94/0x126d8                                      
    [<c0147f10>] _etext+0xffe67f10/0x126d8                                      
    [<c01481bc>] _etext+0xffe681bc/0x126d8                                      
    [<c0148218>] _etext+0xffe68218/0x126d8                                      
    [<c0143db0>] _etext+0xffe63db0/0x126d8                                      
    [<c0143e18>] _etext+0xffe63e18/0x126d8                                      
    [<c007f250>] _etext+0xffd9f250/0x126d8                                      
    [<c007c238>] _etext+0xffd9c238/0x126d8                                      
    [<c007c2b8>] _etext+0xffd9c2b8/0x126d8                                      
    [<c0023dc0>] _etext+0xffd43dc0/0x126d8                                      

and with the commit reverted:

    [<c007bfec>] kmemleak_alloc+0x14c/0x260                                     
    [<c00795e4>] kmem_cache_alloc+0xd4/0x108                                    
    [<c0147d94>] tty_ldisc_try_get+0x18/0xb0                                    
    [<c0147f10>] tty_ldisc_get+0x18/0x40                                        
    [<c01481bc>] tty_ldisc_reinit+0x28/0x5c                                     
    [<c0148218>] tty_ldisc_release+0x28/0x3c                                    
    [<c0143db0>] tty_release_dev+0x3cc/0x428                                    
    [<c0143e18>] tty_release+0xc/0x14                                           
    [<c007f250>] __fput+0x104/0x1c4                                             
    [<c007c238>] filp_close+0x70/0x7c                                           
    [<c007c2b8>] sys_close+0x74/0xa8                                            
    [<c0023dc0>] ret_fast_syscall+0x0/0x28                                      

Any idea what went wrong? I haven't looked at your commit in detail.

Thanks.

-- 
Catalin

