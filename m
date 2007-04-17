Return-Path: <linux-kernel-owner+w=401wt.eu-S1754340AbXDQNdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340AbXDQNdT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 09:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754338AbXDQNdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 09:33:19 -0400
Received: from gw.goop.org ([64.81.55.164]:53350 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754013AbXDQNdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 09:33:19 -0400
Message-ID: <4624CC7C.6040107@goop.org>
Date: Tue, 17 Apr 2007 09:32:44 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>, Hugh Dickins <hugh@veritas.com>,
       David Rientjes <rientjes@google.com>,
       Michel Lespinasse <walken@vmware.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] Pte drop ptep_get_and_clear paravirt op.patch
References: <200704120530.l3C5Ubs0022821@zach-dev.vmware.com>
In-Reply-To: <200704120530.l3C5Ubs0022821@zach-dev.vmware.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> In shadow mode hypervisors, ptep_get_and_clear achieves the desired
> purpose of keeping the shadows in sync by issuing a native_get_and_clear,
> followed by a call to pte_update, which indicates the PTE has been
> modified.
>
> Direct mode hypervisors (Xen) have no need for this anyway, and will trap
> the update using writable pagetables.
>   

Jan Beulich just posted a patch for Xen/linux which specialzes
ptep_get_and_clear, which apparently improves kernel-compile performance
by 25-30% on some configurations.  I think we'll want to keep this.

    J
