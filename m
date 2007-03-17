Return-Path: <linux-kernel-owner+w=401wt.eu-S932812AbXCQAac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932812AbXCQAac (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 20:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932825AbXCQAac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 20:30:32 -0400
Received: from smtp.osdl.org ([65.172.181.24]:44249 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932812AbXCQAab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 20:30:31 -0400
Date: Fri, 16 Mar 2007 16:30:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Dan Hecht <dhecht@vmware.com>, Zachary Amsden <zach@vmware.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH/RFC] replace get_scheduled_cycles with sched_clock
 paravirt_op
Message-Id: <20070316163026.7a474142.akpm@linux-foundation.org>
In-Reply-To: <45F847E2.7040102@goop.org>
References: <45F847E2.7040102@goop.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Mar 2007 12:07:14 -0700 Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Subject: Add a sched_clock paravirt_op
> 
> The tsc-based get_scheduled_cycles interface is not a good match for
> Xen's runstate accounting, which reports everything in nanoseconds.
> 
> This patch replaces this interface with a sched_clock interface, which
> matches both Xen and VMI's requirements.
> 
> In order to do this, we:
>    1. replace get_scheduled_cycles with sched_clock
>    2. hoist cycles_2_ns into a common header
>    3. update vmi accordingly
> 
> One thing to note: because sched_clock is implemented as a weak function in
> kernel/sched.c, we must define a real function in order to override this weak
> binding.  This means the usual paravirt_ops technique of using an inline
> function won't work in this case.

include/asm/paravirt.h: In function 'paravirt_sched_clock':
include/asm/paravirt.h:281: warning: implicit declaration of function 'PVOP_CALL0'
include/asm/paravirt.h:281: error: expected expression before 'unsigned'
