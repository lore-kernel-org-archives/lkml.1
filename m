Return-Path: <linux-kernel-owner+w=401wt.eu-S1759431AbZAVWy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759431AbZAVWy7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 17:54:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752768AbZAVWyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 17:54:51 -0500
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:51668 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752676AbZAVWyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 17:54:50 -0500
Subject: Re: lmbench lat_mmap slowdown with CONFIG_PARAVIRT
From: Zachary Amsden <zach@vmware.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Nick Piggin <npiggin@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "jeremy@xensource.com" <jeremy@xensource.com>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Xen-devel <xen-devel@lists.xensource.com>
In-Reply-To: <4978F6C6.3090003@goop.org>
References: <20090120110542.GE19505@wotan.suse.de>
	 <20090120112634.GA20858@elte.hu> <20090120140324.GA26424@elte.hu>
	 <49763806.5090009@goop.org> <20090120205653.GA19710@elte.hu>
	 <20090121072718.GN24891@wotan.suse.de>  <4977A051.8050203@goop.org>
	 <1232663311.16317.176.camel@bodhitayantram.eng.vmware.com>
	 <4978F6C6.3090003@goop.org>
Content-Type: text/plain
Date: Thu, 22 Jan 2009 14:55:07 -0800
Message-Id: <1232664907.16317.182.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-22 at 14:44 -0800, Jeremy Fitzhardinge wrote:

> I did have some patches to do that at one point.  If you set pgd_val = 
> paravirt_nop, then the patching machinery will completely nop out the 
> call site.  The problem is that it depends on the calling convention 
> using the same regs for the first arg and return - true for 32-bit, but 
> not 64.  We could fix that with identity functions which the patcher 
> recognizes and can replace with either pure nops or inline appropriate 
> register moves.

What about removing the identity functions entirely.  They are useless,
really.  All that is needed is a patch site filled with nops for Xen to
overwrite, just stuffing the value into the proper registers.  For
64-bit, it can be a simple mov to satisfy the constraints.

> Also, I just posted patches to get rid of all pvops calls when fetching 
> or setting flags in a pte, which I hope will help.

Sounds like it will help.

