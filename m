Return-Path: <linux-kernel-owner+w=401wt.eu-S1161120AbXDED0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161120AbXDED0d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 23:26:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161125AbXDED0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 23:26:33 -0400
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:40459 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161120AbXDED0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 23:26:32 -0400
Subject: Re: [PATCH] Lguest32, use guest page tables to find paddr for
	emulated instructions
From: Steven Rostedt <rostedt@goodmis.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: virtualization@lists.osdl.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>
In-Reply-To: <1175741976.12230.627.camel@localhost.localdomain>
References: <1175713626.9371.28.camel@localhost.localdomain>
	 <1175741976.12230.627.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 04 Apr 2007 23:26:24 -0400
Message-Id: <1175743584.9371.47.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-05 at 12:59 +1000, Rusty Russell wrote:
> On Wed, 2007-04-04 at 15:07 -0400, Steven Rostedt wrote:

> Yeah, I haven't tried loading random modules but I can imagine this does
> happen (what module was it, BTW?)

I have no idea of which module it crashed on. I didn't investigate that
too much.  I could simply send a trap to guest when 
__pa(addr) != lguest_find_guest_paddr(addr) and see which module it
crashed on.

My block device I used was basically a copy of a RHEL5 system. I only
modified the inittab and fstab to get it working.  So on startup and
doing the udev init was when it crashed.

> 
> I used to have a function just like this, but managed to get rid of
> it.  
> 
> Hmm, perhaps we should have an "int lgread_virt_byte(u8 *)" which does
> the pgtable walk and read all in one?  It won't be efficient, but it'll
> be more correct and maybe even fewer lines 8)

I forgot that you have a goal to keep lguest small :)

Perhaps we can fork, and have lguest and lguest-lite.

-- Steve

