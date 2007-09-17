Return-Path: <linux-kernel-owner+w=401wt.eu-S1760664AbXIQJMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760664AbXIQJMH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 05:12:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758876AbXIQI5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:57:47 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:53931
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758998AbXIQI5q convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:57:46 -0400
Message-Id: <46EE5DDF.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Mon, 17 Sep 2007 09:58:39 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Andi Kleen" <ak@suse.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: constify stacktrace_ops
References: <46E55C79.76E4.0078.0@novell.com>
 <20070916031820.fc85d43d.akpm@linux-foundation.org>
In-Reply-To: <20070916031820.fc85d43d.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Andrew Morton <akpm@linux-foundation.org> 16.09.07 12:18 >>>
>On Mon, 10 Sep 2007 14:02:17 +0100 "Jan Beulich" <jbeulich@novell.com> wrote:
>
>> .. as they're never written to.
>
>arch/i386/kernel/traps.c: In function 'dump_trace':
>arch/i386/kernel/traps.c:197: warning: initialization discards qualifiers from pointer target type
>
>Due to
>
>                struct ops_and_data oad = { .ops = ops, .data = data };
>
>messy to fix.

Not really - 'struct ops_and_data' can simply have its 'ops' member also be
declared 'struct stacktrace_ops *'. I actually have the patch this way here,
but since I generally submit patches against Linus' tree, I had to rip out
these hunks, since the structure gets added with the unwinder patch.

Jan

