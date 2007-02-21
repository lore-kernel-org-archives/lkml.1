Return-Path: <linux-kernel-owner+w=401wt.eu-S1423276AbXBUX3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423276AbXBUX3w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 18:29:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423277AbXBUX3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 18:29:52 -0500
Received: from gw.goop.org ([64.81.55.164]:51515 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423276AbXBUX3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 18:29:51 -0500
Message-ID: <45DCD5E1.5070201@goop.org>
Date: Wed, 21 Feb 2007 15:29:37 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Andi Kleen <ak@suse.de>, virtualization@lists.osdl.org,
       Chris Wright <chrisw@sous-sol.org>, xen-devel@lists.xensource.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] Re: [patch 17/24] Xen-paravirt_ops: avoid having
 a bad	selector in %gs during context switch
References: <20070221205254.169835700@goop.org>	<20070221205323.770169136@goop.org> <200702212310.02218.ak@suse.de> <45DCD4D0.2000101@vmware.com>
In-Reply-To: <45DCD4D0.2000101@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> I agree with that, but especially because this is not even the right
> place to save and clear gs; when userspace uses an LDT based %gs, you
> need to do this all the way back in mmu_context.h before you switch
> the LDT out. 

Yeah.  This patch was really just to shut my debug Xen build up.  
There's no correctness issue one way or the other, so it doesn't really
matter that it doesn't catch LDT-using processes.

> And I noticed this martian hanging out in mmu_context.h:
>
> #define deactivate_mm(tsk, mm)                  \
>        asm("movl %0,%%gs": :"r" (0));

Yeah, I've always wondered what this is for.  Its a remnant of a
remnant, I think.

    J
