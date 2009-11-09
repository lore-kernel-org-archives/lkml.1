Return-Path: <linux-kernel-owner+w=401wt.eu-S1751690AbZKIKc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690AbZKIKc4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 05:32:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751014AbZKIKc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 05:32:56 -0500
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:1245 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750985AbZKIKcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 05:32:55 -0500
X-Trace: 286942360/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.118.106/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.118.106
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEADN+90pQKXZq/2dsb2JhbACBTtlkhD4E
X-IronPort-AV: E=Sophos;i="4.44,707,1249254000"; 
   d="scan'208";a="286942360"
Date: Mon, 9 Nov 2009 10:32:52 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Andi Kleen <andi@firstfloor.org>
cc: Mark Veltzer <mark.veltzer@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: get_user_pages question
In-Reply-To: <87skco59jl.fsf@basil.nowhere.org>
Message-ID: <Pine.LNX.4.64.0911091031460.15199@sister.anvils>
References: <200911090850.26724.mark.veltzer@gmail.com> <87skco59jl.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Nov 2009, Andi Kleen wrote:
> Mark Veltzer <mark.veltzer@gmail.com> writes:
> >
> > I am testing this kernel module with several buffers from user space allocated 
> > in several different ways. heap, data segment, static variable in function and 
> > stack. All scenarious work EXCEPT the stack one. When passing the stack buffer 
> > the kernel sees one thing while user space sees another.
> 
> In theory it should work, stack is no different from any other pages.
> First thought was that you used some platform with incoherent caches,
> but that doesn't seem to be the case if it's standard x86.

It may be irrelevant to Mark's stack case, but it is worth mentioning
the fork problem: how a process does get_user_pages to pin down a buffer
somewhere in anonymous memory, a thread forks (write protecting anonymous
memory shared between parent and child), child userspace writes to a
location in the same page as that buffer, causing copy-on-write which
breaks the connection between the get_user_pages buffer and what child
userspace sees there afterwards.

Hugh
