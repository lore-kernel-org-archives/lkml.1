Return-Path: <linux-kernel-owner+w=401wt.eu-S1751653AbXBPHgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751653AbXBPHgU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 02:36:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751879AbXBPHgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 02:36:20 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:54961 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbXBPHgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 02:36:19 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Zachary Amsden <zach@vmware.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@muc.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       Avi Kivity <avi@qumranet.com>
Subject: Re: [patch 14/21] Xen-paravirt: Add XEN config options and disable unsupported config options.
References: <20070216022449.739760547@goop.org>
	<20070216022531.570154735@goop.org> <45D54BFF.80100@vmware.com>
Date: Fri, 16 Feb 2007 00:33:58 -0700
In-Reply-To: <45D54BFF.80100@vmware.com> (Zachary Amsden's message of "Thu, 15
	Feb 2007 22:15:27 -0800")
Message-ID: <m11wkqimjd.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden <zach@vmware.com> writes:

>
> We do support different HZ values, although 100HZ is actually preferable for us,
> so I don't object to that.  PREEMPT is supported by us, but not as tested as I
> would like, so I also don't object to dropping it for generic paravirt guests -
> Rusty - Avi any objections to dropping preempt in terms of lguest/KVM
> paravirtualization?
>
> Paravirt-ops definitely needs a hook for kexec, although we should not disable
> kexec for the natively booted paravirt-ops.  Eric - is there a way to disable it
> at runtime?
>
> We do support the doublefault task gate, and it would be good to keep it, but I
> can't complain so much if it is gone from generic paravirt kernels for now,
> because it is non-essential, and generally fatal anyway.  We do need it for
> native boots of paravirt-ops kernels, however, so turning off the config option
> still needs to be revisited

Have machine_kexec_prepare fail.

I think your machine description or paravirt_ops or whatever it is needs
to hook both machine_kexec_prepare and machine_kexec.

I know there actually has been some work to get kexec actually working under
Xen but I don't know where that has gone.

Eric



