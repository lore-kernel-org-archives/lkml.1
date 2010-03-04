Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908Ab0CDTSW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 14:18:22 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:46696 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756134Ab0CDTSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 14:18:21 -0500
X-IronPort-AV: E=Sophos;i="4.49,582,1262563200"; 
   d="scan'208";a="9789167"
Date: Thu, 4 Mar 2010 19:22:08 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Sheng Yang <sheng@linux.intel.com>,
       xen-devel <xen-devel@lists.xensource.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ian Campbell <Ian.Campbell@eu.citrix.com>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Xen-devel] Re: [PATCH 7/7] xen: Make event channel work with
 PV extension of HVM
In-Reply-To: <4B8FFAD8.8090006@goop.org>
Message-ID: <alpine.DEB.2.00.1003041910520.24752@kaball-desktop>
References: <1267695416-14988-1-git-send-email-sheng@linux.intel.com> <1267695416-14988-8-git-send-email-sheng@linux.intel.com> <4B8FFAD8.8090006@goop.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Mar 2010, Jeremy Fitzhardinge wrote:
> 
> I think you need to expand this comment to explain the consequences of
> this change on SMP bringup and timers.  I still don't see why there are
> (or should be) any differences from PV cpu bringup, aside from the tiny
> details of syscall setup (and MTRR I guess, but that's all a noop
> anyway, right?).
> 
> Also, I think you can probably do the timer changes in a separate patch,
> as even with evtchns, an emulated timer device interrupt will still be
> delivered properly via VIRQ_EMUL_PIN_*.
> 
 
One of the problems is that some VCPU initialization hypercalls at the
moment are PV specific and don't work with HVM guests, in particular I
find that VCPUOP_initialise doesn't work correctly for me.

But the timers shouldn't be an issue because you should be able to
receive the VIRQ_TIMER or the emulated timer interrupt anyway.


