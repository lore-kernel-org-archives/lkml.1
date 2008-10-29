Return-Path: <linux-kernel-owner+w=401wt.eu-S1755128AbYJ2Qnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128AbYJ2Qnf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 12:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754870AbYJ2QnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 12:43:25 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:52716 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754918AbYJ2QnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 12:43:24 -0400
Date: Wed, 29 Oct 2008 09:43:06 -0700
From: Gary Hade <garyhade@us.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Gary Hade <garyhade@us.ibm.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, lcm@us.ibm.com
Subject: Re: x86_64: remove debug code from arch_add_memory()
Message-ID: <20081029164305.GA9035@us.ibm.com>
References: <20081028234314.GA16140@us.ibm.com> <20081029083053.GB6364@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081029083053.GB6364@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2008 at 09:30:53AM +0100, Ingo Molnar wrote:
> 
> * Gary Hade <garyhade@us.ibm.com> wrote:
> 
> > 
> > Gets rid of dmesg spam created during physical memory hot-add which
> > will very likely confuse users.  The change removes what appears to
> > be debugging code which I assume was unintentionally included in:
> >   x86: arch/x86/mm/init_64.c printk fixes
> >   commit 10f22dde556d1ed41d55355d1fb8ad495f9810c8
> > 
> > Signed-off-by: Gary Hade <garyhade@us.ibm.com>
> > 
> > ---
> >  arch/x86/mm/init_64.c |    1 -
> >  1 file changed, 1 deletion(-)
> 
> applied to tip/x86/urgent, thanks Gary!
> 
> Note, i changed it slightly: instead of removing it completely i 
> changed it to WARN_ON_ONCE(ret), to show us when __add_pages() fails. 
> (which is what the original intention was there)

No problem!  That's obviously better.

> This does not trigger in your tests, right?

Correct.  I just did a memory hot-add with that change and the
WARN_ON_ONCE(ret) did not write anything to dmesg.

Thanks,
Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc

