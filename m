Return-Path: <linux-kernel-owner+w=401wt.eu-S965757AbXCPRhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965757AbXCPRhu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 13:37:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965768AbXCPRhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 13:37:50 -0400
Received: from gw.goop.org ([64.81.55.164]:53669 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965757AbXCPRht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 13:37:49 -0400
Message-ID: <45FAD5E8.1030301@goop.org>
Date: Fri, 16 Mar 2007 10:37:44 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 12/26] Xen-paravirt_ops: Fix patch site clobbers to include
 return register
References: <20070301232443.195603797@goop.org> <20070301232527.755495278@goop.org> <20070316092626.GN23174@elte.hu>
In-Reply-To: <20070316092626.GN23174@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> Fix a few clobbers to include the return register.  The clobbers set 
>> is the set of all registers modified (or may be modified) by the code 
>> snippet, regardless of whether it was deliberate or accidental.
>>     
>
> i guess we need these paravirt.h clobber fixes for v2.6.21 (VMI) too, 
> correct?

No, I don't think so.  These aren't gcc-style clobbers, but a marker in
the .parainstruction section about what registers may be clobbered by
the patched in code.   VMI doesn't use that info, and/or doesn't clobber
more than is allowed at each site, so it isn't an issue.

    J
