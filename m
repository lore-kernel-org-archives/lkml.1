Return-Path: <linux-kernel-owner+w=401wt.eu-S1767359AbXECD6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767359AbXECD6B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 23:58:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767364AbXECD6B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 23:58:01 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:29470 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767359AbXECD57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 23:57:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=V87Ak0IJSbPw3aWwqzQLlnHR5DV/xikWEbXYNyXcT9FLnKbiUo81BveUqF8sagyl3iFgycuVHIEiBsH2x5/l/UQ3SLjtIPvFz/FAYn4sSDb51X2Q1VO5TFZu8x4D+3Wwy+PKqQzMAhoYhc7+7n0OK4qRw2glkY2oG+HPXgy7x4k=
Date: Thu, 3 May 2007 11:57:49 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [RELEASE] Lguest for 2.6.21
Message-ID: <20070503035749.GC2295@localhost.localdomain>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
Mail-Followup-To: Rusty Russell <rusty@rustcorp.com.au>,
	lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
	virtualization <virtualization@lists.linux-foundation.org>
References: <1178117028.19815.14.camel@localhost.localdomain> <20070502193303.GA1502@localhost.localdomain> <1178146848.23670.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1178146848.23670.6.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2007 at 09:00:48AM +1000, Rusty Russell wrote:
>On Thu, 2007-05-03 at 03:33 +0800, WANG Cong wrote:
>> Hi Rusty!
>> 
>> I found you forgot to check the return value of copy_from_user, and
>> here is the fix for drivers/lguest/interrupts_and_traps.c.
>> 
>> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
>
>Hi Wang!
>
>	Thanks for the patch.  This omission (in several places) was
>deliberate.  We can't really do anything sensible if the user unmapped
>the page.  I assume you saw a gcc warning from this code?

Yes. In fact, I got two warnings, another one is in drivers/lguest/hypercalls.c.

If I understand you correctly, you mean we can do nothing useful to fix it?

>
>	We could also use lgread() in these places which does this check and
>kills the guest if something goes wrong.  I'll check the benchmarks to
>make sure the (slight) extra overhead doesn't cause a regression...
>
>Thanks!
>Rusty.

I have sent a mail which described the errors I got when comipling Documentation/lguest/lguest.c. But it seems that you didn't receive it (it didn't appear in lkml.org neither!). It is that, I have already made my .config as you suggested, but I still can't compile Documentation/lguest/lguest.c, errors are:

lguest.c: In function 'add_to_bridge':
lguest.c:779: error: 'SIOCBRADDIF' undeclared (first use in this function)
lguest.c:779: error: (Each undeclared identifier is reported only once
lguest.c:779: error: for each function it appears in.)

Can you help me out?

Thanks!

