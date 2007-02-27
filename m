Return-Path: <linux-kernel-owner+w=401wt.eu-S1751382AbXB0R4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382AbXB0R4m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 12:56:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751682AbXB0R4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 12:56:41 -0500
Received: from gw.goop.org ([64.81.55.164]:45916 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382AbXB0R4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 12:56:40 -0500
Message-ID: <45E470D6.7050401@goop.org>
Date: Tue, 27 Feb 2007 09:56:38 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@SteelEye.com>
CC: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-arch@vger.kernel.org
Subject: Re: [patch 09/26] Xen-paravirt_ops: remove HAVE_ARCH_MM_LIFETIME,
 define no-op architecture implementations
References: <20070227081337.434798469@goop.org>	 <20070227081632.356636957@goop.org>	 <1172589358.3408.2.camel@mulgrave.il.steeleye.com>	 <45E46889.9090801@goop.org> <1172597726.3408.25.camel@mulgrave.il.steeleye.com>
In-Reply-To: <1172597726.3408.25.camel@mulgrave.il.steeleye.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> On Tue, 2007-02-27 at 09:21 -0800, Jeremy Fitzhardinge wrote:
>   
>> You mean add the two stubs to asm-generic/mmu_context.h, and then
>> include that in all these files?  That would be cleaner, but it
>> wouldn't
>> remove the need to touch all these files, would it?
>>     
>
> it would if you added asm-generic/mmu_context_paravirt.h
>   

include/asm-generic isn't in the compile include path; its contents are
only ever used if they're explicitly included by some other asm/
header.  I seem to remember there was some debate about this, but I
don't really understand the rationale for the current arrangement; it
makes sense to me to have asm-generic as a set of fallback default includes.

> and only included that in the main kernel files that need the three
> operations (that's just fork.c and mmap.c, isn't it)?
>   

Yeah, it's really only two operations.  activate_mm happens in arch code
anyway, so there's no need to make a fuss about it.

    J
