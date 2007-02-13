Return-Path: <linux-kernel-owner+w=401wt.eu-S1751389AbXBMWpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751389AbXBMWpp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 17:45:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751390AbXBMWpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 17:45:45 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:59033 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751389AbXBMWpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 17:45:44 -0500
Message-ID: <45D23F97.5040907@vmware.com>
Date: Tue, 13 Feb 2007 14:45:43 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>
Subject: Re: [patch 13/21] Xen-paravirt: Add nosegneg capability to the vsyscall
 page notes
References: <20070213221729.772002682@goop.org> <20070213221830.466651996@goop.org>
In-Reply-To: <20070213221830.466651996@goop.org>
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

I don't like this because now a kernel compiled with both CONFIG_XEN and 
CONFIG_VMI has "nosegneg" turned on.  We don't actually require this for 
performance or correctness, so it would be nice to be able to 
dynamically turn it off instead of having it forced.

Zach
