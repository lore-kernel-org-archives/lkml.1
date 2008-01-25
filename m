Return-Path: <linux-kernel-owner+w=401wt.eu-S1755036AbYAYJR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036AbYAYJR4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 04:17:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757188AbYAYJRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 04:17:33 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:7939
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756152AbYAYJR3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 04:17:29 -0500
Message-Id: <4799B75C.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Fri, 25 Jan 2008 09:18:04 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Nick Piggin" <nickpiggin@yahoo.com.au>
Cc: "Keir Fraser" <Keir.Fraser@cl.cam.ac.uk>, "Ingo Molnar" <mingo@elte.hu>,
       "Harvey Harrison" <harvey.harrison@gmail.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Matt Mackall" <mpm@selenic.com>, "Andi Kleen" <ak@suse.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH UPDATE] x86: ignore spurious faults
References: <47992CB2.8050606@goop.org>
 <C3BF420A.12CFE%Keir.Fraser@cl.cam.ac.uk>
 <4799A8A6.76E4.0078.0@novell.com>
 <200801251938.39231.nickpiggin@yahoo.com.au>
In-Reply-To: <200801251938.39231.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Nick Piggin <nickpiggin@yahoo.com.au> 25.01.08 09:38 >>>
>On Friday 25 January 2008 19:15, Jan Beulich wrote:
>> Actually, another thought: permitting (and handling) spurious faults for
>> kernel mappings conflicts with NMI handling, i.e. great care would be
>> needed to ensure the NMI path cannot touch any such mapping. So
>> even the present Xen/Linux Dom0 implementation may have some
>> (perhaps unlikely) problems here, and it would get worse if we added
>> e.g. a virtual watchdog NMI (something I am considering, which would
>> then extend the problem to DomU-s).
>
>Can you explain how they conflict?

In the same way as vmalloc faults do (which is why vmalloc_sync_all()
got introduced): a page fault nested inside an NMI will, by virtue of
executing IRET, prematurely tell the processor that NMI handling is
done (and specifically unmask further NMIs).

Jan

