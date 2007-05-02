Return-Path: <linux-kernel-owner+w=401wt.eu-S1767184AbXEBXBF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767184AbXEBXBF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 19:01:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767180AbXEBXBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 19:01:04 -0400
Received: from ozlabs.org ([203.10.76.45]:41793 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767184AbXEBXBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 19:01:03 -0400
Subject: Re: [RELEASE] Lguest for 2.6.21
From: Rusty Russell <rusty@rustcorp.com.au>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
In-Reply-To: <20070502193303.GA1502@localhost.localdomain>
References: <1178117028.19815.14.camel@localhost.localdomain>
	 <20070502193303.GA1502@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 03 May 2007 09:00:48 +1000
Message-Id: <1178146848.23670.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-03 at 03:33 +0800, WANG Cong wrote:
> Hi Rusty!
> 
> I found you forgot to check the return value of copy_from_user, and
> here is the fix for drivers/lguest/interrupts_and_traps.c.
> 
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

Hi Wang!

	Thanks for the patch.  This omission (in several places) was
deliberate.  We can't really do anything sensible if the user unmapped
the page.  I assume you saw a gcc warning from this code?

	We could also use lgread() in these places which does this check and
kills the guest if something goes wrong.  I'll check the benchmarks to
make sure the (slight) extra overhead doesn't cause a regression...

Thanks!
Rusty.

