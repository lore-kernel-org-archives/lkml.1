Return-Path: <linux-kernel-owner+w=401wt.eu-S1762317AbXJDJh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762317AbXJDJh7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 05:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759900AbXJDJYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 05:24:30 -0400
Received: from cantor.suse.de ([195.135.220.2]:42216 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760612AbXJDJY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 05:24:29 -0400
To: "David J. Wilder" <dwilder@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       randy.dunlap@oracle.com, hch@infradead.org,
       systemtap@sources.redhat.com
Subject: Re: [patch 1/3]  Trace code and documentation
References: <1191342800.31351.9.camel@lc4eb748232119.ibm.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 04 Oct 2007 11:24:26 +0200
In-Reply-To: <1191342800.31351.9.camel@lc4eb748232119.ibm.com>
Message-ID: <p73odff5j1x.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"David J. Wilder" <dwilder@us.ibm.com> writes:
> @@ -0,0 +1,160 @@
> +Trace Setup and Control
> +=======================
> +In the kernel, the trace interface provides a simple mechanism for
> +starting and managing data channels (traces) to user space.

Wasn't relayfs supposed to do that already? Why do you need another
wrapper around it? 

Is this also really still faster than a printk below log level
(without console driver overhead). If not then why not just
use printk? 

Especially your example is worrying. It essentially defines a new
printk. I think there is a case for a fast logging subsystem because
printk() is admittedly a little slow [somewhat slow below log level
and incredible slow above it]

But fast means binary items (not sprintf), no global locks, not
multiple layers, per CPU etc.. But your example and this patch has all
this and I bet it is not very fast.

Is the result (e.g. the trace example module) still any faster
than printk below log level? If not then why bother.

Adding another slow logger would be just a waste of time imho.
It just means that everybody who needs a fast logger just need
to reimplement their own anyways. And the people who can tolerate
slow loggers are probably already adequately served by 
printk. Also there is already direct relayfs.

-Andi
