Return-Path: <linux-kernel-owner+w=401wt.eu-S1759991AbZKLC36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759991AbZKLC36 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 21:29:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759957AbZKLC36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 21:29:58 -0500
Received: from ozlabs.org ([203.10.76.45]:36553 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759943AbZKLC35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 21:29:57 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Adam Litke <agl@us.ibm.com>
Subject: Re: virtio: Add memory statistics reporting to the balloon driver
Date: Thu, 12 Nov 2009 12:59:59 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; i686; ; )
Cc: Anthony Liguori <aliguori@us.ibm.com>, agl@linux.vnet.ibm.com,
       qemu-devel@nongnu.org, Avi Kivity <avi@redhat.com>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <1257782838.2835.5.camel@aglitke> <200911111313.24226.rusty@rustcorp.com.au> <1257952114.2876.29.camel@aglitke>
In-Reply-To: <1257952114.2876.29.camel@aglitke>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200911121259.59540.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Nov 2009 01:38:34 am Adam Litke wrote:
> > But it raises the question: what stats are generally useful cross-OS?  Should
> > we be supplying numbers like "unused" (free) "instantly discardable" (ie.
> > clean), "discardable to disk" (ie. file-backed), "discardable to swap"
> > (ie. swap-backed) and "unswappable" instead?
> 
> While I see the virtue in presenting abstracted memory stats that seem
> more digestible in a virtualization context, I think we should keep the
> raw stats.  This concentrates the complexity in the host-side management
> daemon, and allows the host daemon to make better decisions (ie. by
> reacting to trends in individual statistics).  Different OSes (or
> different versions of the same OS), may also have different sets of
> statistics that will provide the answers that a management daemon needs.

OK, I see you made each one a separate feature bit, which does allow this
somewhat.  But you can't just change the meaning arbitrarily, all you can
do is refuse to supply some of them.  This is because virtio is an ABI,
but also it's plain sanity: run a new guest on an old host and get crazy
answers.

Two more questions:

I assume memtot should be equal to the initial memory granted to the guest
(perhaps reduced if the guest can't use all the memory for internal reasons)?

I'm not sure of the relevance to the host of the number of anonymous pages?
That's why I wondered if unswappable pages would be a better number to supply?

Thanks,
Rusty.
