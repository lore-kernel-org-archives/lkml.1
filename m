Return-Path: <linux-kernel-owner+w=401wt.eu-S1755499AbYIRL6F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499AbYIRL6F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 07:58:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752940AbYIRL5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 07:57:55 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:31636 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbYIRL5z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 07:57:55 -0400
Message-Id: <48D25E87.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 Beta 
Date: Thu, 18 Sep 2008 12:58:31 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH] x86: x86_{phys,virt}_bits field also for i386 (v3)
References: <48D21BA3.76E4.0078.0@novell.com>
 <20080918071852.GA7639@elte.hu> <20080918091003.GA3751@elte.hu>
 <48D23BF6.76E4.0078.0@novell.com> <20080918095710.GA11633@elte.hu>
 <20080918112018.GA456@elte.hu>
In-Reply-To: <20080918112018.GA456@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Ingo Molnar <mingo@elte.hu> 18.09.08 13:20 >>>
>
>* Ingo Molnar <mingo@elte.hu> wrote:
>
>> * Jan Beulich <jbeulich@novell.com> wrote:
>> 
>> > I'm really sorry for that, yet another merge oversight (not caught 
>> > because only re-tested on x86-64). Here's a better one.
>> 
>> ah, i see, the delta below. Nasty.
>
>the attached config fails in a similar way.

Hmm, yes, other than in .27, -tip derives resource_size_t from phys_addr_t,
regardless of CONFIG_RESOURCES_64BIT (and the config you provided
is a non-PAE one). I have to question that change, which I'm sure is
responsible for this failure. If there's a good reason for this, then
phys_addr_valid() should use phys_addr_t as its parameter type (and
so should ioremap() & Co), and the pre-processor conditional should
then change to depend on CONFIG_PHYS_ADDR_T_64BIT. Since ioremap()
would need to change first, I'd have to withdraw the patch until that
gets sorted out.

Jan

