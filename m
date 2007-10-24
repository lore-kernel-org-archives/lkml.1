Return-Path: <linux-kernel-owner+w=401wt.eu-S1753238AbXJXI3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbXJXI3k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 04:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751409AbXJXI3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 04:29:33 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:8051
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750893AbXJXI3c convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 04:29:32 -0400
Message-Id: <471F1EEE.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Wed, 24 Oct 2007 09:31:10 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@xensource.com>
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: CONFIG_XEN dependencies
References: <471DE2F8.76E4.0078.0@novell.com>
 <471E38D6.5050202@xensource.com>
In-Reply-To: <471E38D6.5050202@xensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Jeremy Fitzhardinge <jeremy@xensource.com> 23.10.07 20:09 >>>
>Jan Beulich wrote:
>> Jeremy,
>>
>> CONFIG_XEN (in 2.6.23) depends on X86_CMPXCHG and X86_TSC. This
>> precludes enabling the option in kernels using M386, M486, or M586, despite
>> the fact that the detection code doesn't need these features and if Xen is
>> present the features are implicitly there. At least the X86_TSC dependency
>> can thus be dropped in my opinion, which would then only exclude M386
>> kernels. (Dropping X86_CMPXCHG may yield build problems, but could
>> perhaps also be eliminated by forcibly #define-ing it in the relevant source
>> files.)
>
>Yeah, that's a bit tacky though.  We added it because reviewers
>(probably Adrian Bunk, or maybe akpm) noticed the Xen code
>unconditionally using cmpxchg, and I added tsc because, well, we use it.
>
>But you're right; we can't get to any of the Xen code without booting
>under Xen, which necessarily means all those features are available,
>regardless of how the kernel is configured.
>
>What config combinations do you want to support?

The specific goal is to be able to enable the XEN option in our native kernel,
which gets configured with M586. So we could live with XEN depending on
X86_CMPXCHG, but would definitely need the dependency on X86_TSC
dropped. Nevertheless I'd favor even X86_CMPXCHG dropped unless that
causes unresolvable (or difficult to resolve) problems.

Jan

