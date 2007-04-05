Return-Path: <linux-kernel-owner+w=401wt.eu-S1160993AbXDEC7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1160993AbXDEC7j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 22:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161001AbXDEC7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 22:59:39 -0400
Received: from ozlabs.org ([203.10.76.45]:40863 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1160993AbXDEC7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 22:59:38 -0400
Subject: Re: [PATCH] Lguest32, use guest page tables to find paddr for
	emulated instructions
From: Rusty Russell <rusty@rustcorp.com.au>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: virtualization@lists.osdl.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>
In-Reply-To: <1175713626.9371.28.camel@localhost.localdomain>
References: <1175713626.9371.28.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 05 Apr 2007 12:59:36 +1000
Message-Id: <1175741976.12230.627.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-04 at 15:07 -0400, Steven Rostedt wrote:
> [Bug that was found by my previous patch]
> 
> This patch allows things like modules, which don't have a direct
> __pa(EIP) mapping to do emulated instructions.
> 
> Sure, the emulated instruction probably should be a paravirt_op, but
> this patch lets you at least boot a kernel that has modules needing
> emulated instructions.

Yeah, I haven't tried loading random modules but I can imagine this does
happen (what module was it, BTW?)

I used to have a function just like this, but managed to get rid of
it.  

Hmm, perhaps we should have an "int lgread_virt_byte(u8 *)" which does
the pgtable walk and read all in one?  It won't be efficient, but it'll
be more correct and maybe even fewer lines 8)

Thanks for the patch!
Rusty.


