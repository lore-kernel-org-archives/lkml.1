Return-Path: <linux-kernel-owner+w=401wt.eu-S1946428AbXBIM6J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946428AbXBIM6J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 07:58:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946431AbXBIM6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 07:58:09 -0500
Received: from mtagate4.de.ibm.com ([195.212.29.153]:35420 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946428AbXBIM6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 07:58:06 -0500
Subject: Re: [patch] i386/x86_64: smp_call_function locking inconsistency
From: Jan Glauber <jan.glauber@de.ibm.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: David Miller <davem@davemloft.net>, akpm@osdl.org, mingo@elte.hu,
       ak@suse.de, schwidefsky@de.ibm.com, linux-kernel@vger.kernel.org
In-Reply-To: <20070209084221.GA8259@osiris.boeblingen.de.ibm.com>
References: <20070208203210.GB9798@osiris.ibm.com>
	 <20070208.124328.88477956.davem@davemloft.net>
	 <20070209084221.GA8259@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain
Date: Fri, 09 Feb 2007 13:57:18 +0100
Message-Id: <1171025838.5349.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-02-09 at 09:42 +0100, Heiko Carstens wrote:
> I just want to avoid that s390 has different semantics for
> smp_call_functiom*() than any other architecture. But then again it
> will probably not hurt since we allow more.
> Another thing that comes into my mind is smp_call_function together
> with cpu hotplug. Who is responsible that preemption and with that
> cpu hotplug is disabled?
> Is it the caller or smp_call_function itself?

I think the caller must disable preemption since smp_call_function()
means "do something on all but the current cpu". If the preempt_disable
would happen only in smp_call_function() it could already be running on
a different cpu, which is not what the caller wants.

If preemption must be disabled before smp_call_function() we should have
the same semantics for all smp_call_function_* variants.

Jan

