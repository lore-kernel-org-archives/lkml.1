Return-Path: <linux-kernel-owner+w=401wt.eu-S932422AbZJUTY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932422AbZJUTY6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 15:24:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932343AbZJUTY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 15:24:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28480 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932283AbZJUTYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 15:24:55 -0400
Message-ID: <4ADF5FE2.7070604@redhat.com>
Date: Wed, 21 Oct 2009 14:24:18 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Dave Jones <davej@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, esandeen@redhat.com,
       cebbert@redhat.com, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Unnecessary overhead with stack protector.
References: <20091015183540.GA8098@redhat.com>	<20091015190720.GA19467@elte.hu>	<4ADF2DAA.9030604@redhat.com> <20091021110053.26ab9982@infradead.org> <4ADF59F8.7010205@redhat.com> <4ADF5C6B.80605@redhat.com>
In-Reply-To: <4ADF5C6B.80605@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Sandeen wrote:
> Eric Sandeen wrote:

..

> but maybe more to Dave's original point, xfs on x86_64 in my tree had
> 243 functions with minimal stack usage of 8 bytes.  w/
> CC_STACKPROTECTOR_ALL in force, I end up with these sizes for those
> functions:
> 
>   count bytes
>       3 16
>     236 24
>       1 32
>       5 40
> 
> 8->24 bytes is pretty significant too, w/ a 200% increase, if you add a
> few up...

And on top of that (sorry for the self-replies) there are 600+ functions
in xfs that didn't even register a stack footprint at all (i.e. no sub
%rsp in disassembly) w/o stackprotector, which now have 16 or 24 bytes
with it on.

Forgive me if I'm not using the right tools to look, but it seems to me
that in the aggregate, CC_STACKPROTECTOR_ALL has a pretty big impact.

-Eric
