Return-Path: <linux-kernel-owner+w=401wt.eu-S1758586AbYGJQqI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758586AbYGJQqI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 12:46:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751576AbYGJQp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 12:45:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50307 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750833AbYGJQpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 12:45:55 -0400
Message-ID: <48763CA6.9030802@linux-foundation.org>
Date: Thu, 10 Jul 2008 11:45:26 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>	<m1abgqzv3g.fsf@frodo.ebiederm.org> <20080709200757.GD14009@elte.hu>	<48751B57.8030605@goop.org> <48751CF9.4020901@linux-foundation.org>	<4875209D.8010603@goop.org> <48752CCD.30507@linux-foundation.org>	<m1wsjupuiz.fsf@frodo.ebiederm.org> <48753C99.5050408@goop.org> <m1ej62iq9z.fsf@frodo.ebiederm.org> <487555A8.2050007@zytor.com> <487556A5.5090907@goop.org> <4876194E.4080205@linux-foundation.org> <48761C06.3020003@zytor.com> <48762A3B.5050104@linux-foundation.org> <48762DD2.5090802@zytor.com> <487637A1.4080403@linux-foundation.org> <487639ED.7000502@zytor.com>
In-Reply-To: <487639ED.7000502@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:

> It will, but it might still be a net loss due to higher load on the TLB
> (you're effectively using the TLB to do the table lookup for you.)  On
> the other hand, Mike points out that once we move away from fixed-sized
> segments we pretty much have to use virtual addresses anyway(*).

There will be no additional overhead since the memory already mapped 1-1 using 2MB TLBs and we want to use the same for the percpu areas. This is similar to the vmemmap solution.

>> The first percpu area would ideally be the per cpu segment generated
>> by the linker.
>>
>> How would that fit into the address map? In particular the 2G distance
>> between code and the first per cpu area must not be violated unless we
>> go to a zero based approach.
> 
> If with "zero-based" you mean "nonzero gs_base for the boot CPU" then
> yes, you're right.
> 
> Note again that that is completely orthogonal to RIP-based versus absolute.

?? The distance to the per cpu area for cpu 0 is larger than 2G. Kernel wont link with RIP based addresses. You would have to place the per cpu areas 1TB before the kernel text.




