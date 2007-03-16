Return-Path: <linux-kernel-owner+w=401wt.eu-S965716AbXCPRIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965716AbXCPRIt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 13:08:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965712AbXCPRIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 13:08:49 -0400
Received: from gw.goop.org ([64.81.55.164]:33616 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965716AbXCPRIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 13:08:48 -0400
Message-ID: <45FACF1B.5010709@goop.org>
Date: Fri, 16 Mar 2007 10:08:43 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [patch 15/26] Xen-paravirt_ops: Add apply_to_page_range() which
 applies a function to a pte range.
References: <20070301232443.195603797@goop.org> <20070301232528.155002121@goop.org> <20070316091940.GJ23174@elte.hu>
In-Reply-To: <20070316091940.GJ23174@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> nice one! I suspect we could simplify some of the less 
> performance-critical open-coded pagetable walker loops in the kernel 
> with this? (i'm not even sure it's all that much of a performance loss 
> to pass a function pointer around - would be nice to convert say 
> mprotect() to this and see the performance difference?)
>   

apply_page_to_range has the side-effect of allocating all the pagetable
levels for the address range it walks.  Xen uses this to populate
pagetables (for example, build out the pagetable, and let the hypervisor
plug a mapping into the pte page).

If that's OK for the other uses, then it should be good.

    J
