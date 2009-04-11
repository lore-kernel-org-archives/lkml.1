Return-Path: <linux-kernel-owner+w=401wt.eu-S1758026AbZDKViT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026AbZDKViT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 17:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755945AbZDKViJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 17:38:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:38747 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755773AbZDKViI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 17:38:08 -0400
Date: Sat, 11 Apr 2009 14:39:50 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Carlos R. Mafra" <crmafra2@gmail.com>
Cc: linux-kernel@vger.kernel.org, tiwai@suse.de, alsa-devel@vger.kernel.org
Subject: Re: General protection fault when unloading snd_hda_intel on
 2.6.30-rc1+
Message-ID: <20090411143950.3429ebc0@infradead.org>
In-Reply-To: <20090411210336.GA15272@Pilar.aei.mpg.de>
References: <20090411193630.GA16968@Pilar.aei.mpg.de>
	<20090411132033.003c581c@infradead.org>
	<20090411210336.GA15272@Pilar.aei.mpg.de>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Apr 2009 23:03:36 +0200
"Carlos R. Mafra" <crmafra2@gmail.com> wrote:

> From: "Carlos R. Mafra" <crmafra2@gmail.com>
> To: Arjan van de Ven <arjan@infradead.org>
> Cc: linux-kernel@vger.kernel.org, tiwai@suse.de,
> alsa-devel@vger.kernel.org Subject: Re: General protection fault when
> unloading snd_hda_intel on 2.6.30-rc1+ Date: Sat, 11 Apr 2009
> 23:03:36 +0200 User-Agent: Mutt/1.5.18 (2008-05-17)
> 
> On Sat 11.Apr'09 at 13:20:33 -0700, Arjan van de Ven wrote:
>  [...]
  
  
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




so... "dev" is pointing evbit at... 697665646632785 which looks like grabage.

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
