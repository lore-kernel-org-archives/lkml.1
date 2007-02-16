Return-Path: <linux-kernel-owner+w=401wt.eu-S1423307AbXBPGGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423307AbXBPGGj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 01:06:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423308AbXBPGGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 01:06:38 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:44339 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423307AbXBPGGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 01:06:38 -0500
Message-ID: <45D549ED.4000206@vmware.com>
Date: Thu, 15 Feb 2007 22:06:37 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>
Subject: Re: [patch 13/21] Xen-paravirt: Add nosegneg capability to the vsyscall
 page notes
References: <20070216022449.739760547@goop.org> <20070216022531.495288020@goop.org>
In-Reply-To: <20070216022531.495288020@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Add the "nosegneg" fake capabilty to the vsyscall page notes. This is
> used by the runtime linker to select a glibc version which then
> disables negative-offset accesses to the thread-local segment via
> %gs. These accesses require emulation in Xen (because segments are
> truncated to protect the hypervisor address space) and avoiding them
> provides a measurable performance boost.
>
> Signed-off-by: Ian Pratt <ian.pratt@xensource.com>
> Signed-off-by: Christian Limpach <Christian.Limpach@cl.cam.ac.uk>
> Signed-off-by: Chris Wright <chrisw@sous-sol.org>
>   

Acked-by: Zachary Amsden <zach@vmware.com>

We would like to see this by dynamic, but that is much more difficult to 
achieve, and seeing your recent linker issues, I don't think this should 
gate merging this code.  The performance loss for us I believe to be 
negligible, and the fix is quite a bit more complicated than something 
achievable in the .21 timeframe.

Zach
