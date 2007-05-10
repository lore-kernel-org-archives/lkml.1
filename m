Return-Path: <linux-kernel-owner+w=401wt.eu-S1757409AbXEJJtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409AbXEJJtV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 05:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756421AbXEJJtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 05:49:14 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51073 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643AbXEJJtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 05:49:14 -0400
Date: Thu, 10 May 2007 11:49:08 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Zhao Forrest <forrest.zhao@gmail.com>
Cc: discuss@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [discuss] A question about GART aperture unmap
Message-ID: <20070510094908.GB14898@one.firstfloor.org>
References: <ac8af0be0705092259p65f057bcoe5e1b9abb963d5e3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac8af0be0705092259p65f057bcoe5e1b9abb963d5e3@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> After commenting out clear_kernel_mapping() line, the system would
> have sync flood and reset from time to time. However when with this
> clear_kernel_mapping() line, no system reset happened.

Hmm, that should not happen. Normally the problems fixed by 
this are expected to be very rare and you also should not get 
sync flood, but just cache line corruption. While it might be possible
for random corruption to then cause sync flood that should be again
rather unlikely. If it's repeatable quickly something else
must be wrong.

> 
> As we know that CPU prefetch never cross the page boundary, in this

That only applies to sequential prefetch. But speculative execution can
 prefetch pretty much any address. That is why the clear_kernel_mapping is 
needed.

-Andi
