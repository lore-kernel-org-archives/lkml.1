Return-Path: <linux-kernel-owner+w=401wt.eu-S1767372AbXECEUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767372AbXECEUi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 00:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767373AbXECEUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 00:20:38 -0400
Received: from ozlabs.org ([203.10.76.45]:45429 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767372AbXECEUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 00:20:37 -0400
Subject: Re: [RELEASE] Lguest for 2.6.21
From: Rusty Russell <rusty@rustcorp.com.au>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
In-Reply-To: <20070503035749.GC2295@localhost.localdomain>
References: <1178117028.19815.14.camel@localhost.localdomain>
	 <20070502193303.GA1502@localhost.localdomain>
	 <1178146848.23670.6.camel@localhost.localdomain>
	 <20070503035749.GC2295@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 03 May 2007 14:20:32 +1000
Message-Id: <1178166032.23670.16.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-03 at 11:57 +0800, WANG Cong wrote:
> On Thu, May 03, 2007 at 09:00:48AM +1000, Rusty Russell wrote:
> >	Thanks for the patch.  This omission (in several places) was
> >deliberate.  We can't really do anything sensible if the user unmapped
> >the page.  I assume you saw a gcc warning from this code?
> 
> Yes. In fact, I got two warnings, another one is in drivers/lguest/hypercalls.c.
> 
> If I understand you correctly, you mean we can do nothing useful to fix it?

We can, but we can ignore those warnings for the moment; they're
harmless.

> I have sent a mail which described the errors I got when comipling
> Documentation/lguest/lguest.c. But it seems that you didn't receive it
> (it didn't appear in lkml.org neither!).

Hmm, no, I didn't get it here either 8(

>  It is that, I have already made my .config as you suggested, but I
> still can't compile Documentation/lguest/lguest.c, errors are:
> 
> lguest.c: In function 'add_to_bridge':
> lguest.c:779: error: 'SIOCBRADDIF' undeclared (first use in this function)
> lguest.c:779: error: (Each undeclared identifier is reported only once
> lguest.c:779: error: for each function it appears in.)

Ah, perhaps older libc headers?  Can you try adding this to the top of
Documentation/lguest/lguest.c after the #define BRIDGE_PFX "bridge:"

#ifndef SIOCBRADDIF
#define SIOCBRADDIF	0x89a2		/* add interface to bridge      */
#endif

Thanks,
Rusty.

