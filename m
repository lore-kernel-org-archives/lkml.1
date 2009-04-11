Return-Path: <linux-kernel-owner+w=401wt.eu-S1759005AbZDKVE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759005AbZDKVE1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 17:04:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754593AbZDKVER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 17:04:17 -0400
Received: from ox1.aei.mpg.de ([194.94.224.6]:33203 "EHLO ox1.aei.mpg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753324AbZDKVER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 17:04:17 -0400
Date: Sat, 11 Apr 2009 23:03:36 +0200
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, tiwai@suse.de, alsa-devel@vger.kernel.org
Subject: Re: General protection fault when unloading snd_hda_intel on
	2.6.30-rc1+
Message-ID: <20090411210336.GA15272@Pilar.aei.mpg.de>
References: <20090411193630.GA16968@Pilar.aei.mpg.de> <20090411132033.003c581c@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090411132033.003c581c@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 11.Apr'09 at 13:20:33 -0700, Arjan van de Ven wrote:
> 
> if you happen to have CONFIG_DEBUG_INFO enabled, then you can run the
> oops through scripts/markup_oops.pl to get the source code of the exact
> line that is oopsing.. makes diagnosing it even easier!

I did not have CONFIG_DEBUG_INFO enabled back then, but now I have.

The script gives me this output:

No vmlinux specified, assuming /lib/modules/2.6.30-rc1-00191-gd848223/build/vmlinux
 		add_input_randomness(type, code, value); 
 		input_handle_event(dev, type, code, value); 
 		spin_unlock_irqrestore(&dev->event_lock, flags); 
 	} 
 } 
 ffffffff8044bf7a:	48 8b 5d d8          	mov    -0x28(%rbp),%rbx |  %ebx => 3 
 ffffffff8044bf7e:	4c 8b 65 e0          	mov    -0x20(%rbp),%r12 |  %r12 => ffffffff805bb97c 
 ffffffff8044bf82:	4c 8b 6d e8          	mov    -0x18(%rbp),%r13 |  %r13 => 5 
 ffffffff8044bf86:	4c 8b 75 f0          	mov    -0x10(%rbp),%r14 |  %r14 => 697665646632785c 
 ffffffff8044bf8a:	4c 8b 7d f8          	mov    -0x8(%rbp),%r15 |  %r15 => 0 
 ffffffff8044bf8e:	c9                   	leaveq  
 ffffffff8044bf8f:	c3                   	retq    
  
 static inline int variable_test_bit(int nr, volatile const unsigned long *addr) 
 { 
 	int oldbit; 
  
 	asm volatile("bt %2,%1\n\t" 
*ffffffff8044bf90:	0f a3 77 20          	bt     %esi,0x20(%rdi) |  %edi = 697665646632785c  %esi = 5 <--- faulting instruction
 ffffffff8044bf94:	19 c0                	sbb    %eax,%eax 
 static struct input_handler *input_table[8]; 
  
 static inline int is_event_supported(unsigned int code, 
 				     unsigned long *bm, unsigned int max) 
 { 
 	return code <= max && test_bit(code, bm); 
 ffffffff8044bf96:	85 c0                	test   %eax,%eax 
 ffffffff8044bf98:	74 e0                	je     ffffffff8044bf7a <input_event+0x2a> 
 { 
 	unsigned long flags; 
  
 	if (is_event_supported(type, dev->evbit, EV_MAX)) { 

