Return-Path: <linux-kernel-owner+w=401wt.eu-S1758373AbYAGRbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758373AbYAGRbz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 12:31:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754245AbYAGRbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 12:31:47 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:38362 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574AbYAGRbq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 12:31:46 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Alejandro Riveira =?utf-8?q?Fern=C3=A1ndez?= <ariveira@gmail.com>
Subject: Re: Linux 2.6.24-rc7
Date: Mon, 7 Jan 2008 18:30:51 +0100
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org> <200801071724.03936.mb@bu3sch.de> <20080107175248.7b0e143f@Varda>
In-Reply-To: <20080107175248.7b0e143f@Varda>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200801071830.51895.mb@bu3sch.de>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 January 2008 17:52:48 Alejandro Riveira Fernández wrote:
> El Mon, 7 Jan 2008 17:24:03 +0100
> Michael Buesch <mb@bu3sch.de> escribió:
> 
>                                                                                      
> > 
> > Can you post the lines above this?
> > This might be a WARN_ON_ONCE() triggering, for which fixes are on their way into
> > the wireless-2.6 tree.
> 
>  This?
> 
> 
> [   37.043990] WARNING: at /home/alex/kernel/linux-2.6/net/mac80211/rx.c:1486 __ieee80211_rx() 
> [   37.043996] Pid: 0, comm: swapper Not tainted 2.6.24-rc7 #3                                                               
> [   37.043998]                                                                                                               
> [   37.043999] Call Trace:                                                                                                   
> [   37.044001]  <IRQ>  [<ffffffff80227fe3>] enqueue_task+0x13/0x30                                                           
> [   37.044040]  [<ffffffff88178cbe>] :mac80211:__ieee80211_rx+0xc7e/0xd30                                                    
> [   37.044044]  [<ffffffff80228062>] activate_task+0x32/0x50                                                                 
> [   37.044073]  [<ffffffff8816a28b>] :mac80211:ieee80211_tasklet_handler+0xbb/0x120                                          
> [   37.044086]  [<ffffffff80238d08>] tasklet_action+0x48/0xb0                                                                
> [   37.044091]  [<ffffffff80238c09>] __do_softirq+0x69/0xe0                                                                  
> [   37.044097]  [<ffffffff8020ce2c>] call_softirq+0x1c/0x30                                                                  
> [   37.044101]  [<ffffffff8020efe5>] do_softirq+0x35/0x90                                                                    
> [   37.044105]  [<ffffffff80238aa5>] irq_exit+0x95/0xa0                                                                      
> [   37.044108]  [<ffffffff8020f0c0>] do_IRQ+0x80/0x100                                                                       
> [   37.044111]  [<ffffffff8020a840>] default_idle+0x0/0x40                                                                   
> [   37.044115]  [<ffffffff8020c181>] ret_from_intr+0x0/0xa                                                                   
> [   37.044117]  <EOI>  [<ffffffff8020a869>] default_idle+0x29/0x40                                                           
> [   37.044130]  [<ffffffff8020a8f5>] cpu_idle+0x75/0xc0                                                                      
> [   37.044146]                                                                                                               


Can you check if that is the
WARN_ON_ONCE(((unsigned long)(skb->data + hdrlen)) & 3);
in rx.c line 1486?
If that is the one, then fixes are already on their way upstream.
Ignore the harmless warning for now.

-- 
Greetings Michael.
