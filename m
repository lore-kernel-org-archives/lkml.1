Return-Path: <linux-kernel-owner+w=401wt.eu-S965913AbXCPUjF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965913AbXCPUjF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 16:39:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965912AbXCPUjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 16:39:04 -0400
Received: from gw.goop.org ([64.81.55.164]:46956 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965908AbXCPUjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 16:39:03 -0400
Message-ID: <45FB005D.9060809@goop.org>
Date: Fri, 16 Mar 2007 13:38:53 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: mingo@elte.hu, ak@muc.de, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, chrisw@sous-sol.org, zach@vmware.com,
       rusty@rustcorp.com.au, anthony@codemonkey.ws,
       torvalds@linux-foundation.org, NetDev <netdev@vger.kernel.org>
Subject: Re: [patch 13/26] Xen-paravirt_ops: Consistently wrap paravirt ops
 callsites to make them patchable
References: <20070301232443.195603797@goop.org>	<20070301232527.956565107@goop.org>	<20070316092445.GM23174@elte.hu> <20070316.023331.59468179.davem@davemloft.net>
In-Reply-To: <20070316.023331.59468179.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> Perhaps the problem can be dealt with using ELF relocations.
>
> There is another case, discussed yesterday on netdev, where run-time
> resolution of ELF relocations would be useful (for
> very-very-very-read-only variables) so if it can solve this problem
> too it would be nice to have a generic infrastructure for it.

That's an interesting idea.  Have you or anyone else looked at what it
would take to code up?

For this case, I guess you'd walk the relocs looking for references into
the paravirt_ops structure.  You'd need to check that was a reference
from an indirect jump or call instruction, which would identify a
patchable callsite.  The offset into the pv_ops structure would identify
which operation is involved.  That would be enough to use the existing
paravirt_ops patch machinery to insert a patch, though it doesn't
provide quite as much information as the current scheme.  The current
scheme also tells us how much space is available for patching over, and
what registers the patched-in code can use/clobber.

What are the netdev requirements?

    J
