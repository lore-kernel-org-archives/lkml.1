Return-Path: <linux-kernel-owner+w=401wt.eu-S1753124AbXCaOfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124AbXCaOfU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 10:35:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbXCaOfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 10:35:19 -0400
Received: from ns1.suse.de ([195.135.220.2]:60968 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753124AbXCaOfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 10:35:18 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Zachary Amsden <zach@vmware.com>
Subject: Re: [PATCH] VMI paravirt-ops bugfix for 2.6.21
Date: Sat, 31 Mar 2007 16:35:01 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <460E1FC7.5030107@vmware.com>
In-Reply-To: <460E1FC7.5030107@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703311635.01776.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 31 March 2007 10:45, Zachary Amsden wrote:
> So lazy MMU mode is vulnerable to interrupts coming in and issuing 
> kmap_atomic, which does not work when under lazy MMU mode.  The window 
> for this is small, but it means highmem kernels, especially with heavy 
> network, USB, or AIO workloads are vulnerable to getting invariably 
> fatal pagefaults in interrupt handlers.  For now, the best fix is to 
> simply disable and re-enable interrupts when entering and exiting lazy 
> mode (which, btw, is already guaranteed to have preempt disabled).  For 
> the future, a better fix is to simply exit lazy mode when issuing 
> kmap_atomic, but I do not want to touch any generic code now for 2.6.21.

I think I would prefer you touch the generic code. This new hook is ugly.

And the lazy mode is currently only used by VMI anyways, isn't it? So you shouldn't 
impact anybody else

-Andi

