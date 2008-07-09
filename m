Return-Path: <linux-kernel-owner+w=401wt.eu-S1756560AbYGIUte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560AbYGIUte (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 16:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753103AbYGIUt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 16:49:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34604 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029AbYGIUt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 16:49:26 -0400
Message-ID: <487522A8.60906@zytor.com>
Date: Wed, 09 Jul 2008 16:42:16 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Christoph Lameter <cl@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com> <m1abgqzv3g.fsf@frodo.ebiederm.org> <20080709200757.GD14009@elte.hu> <48751B57.8030605@goop.org> <48751CF9.4020901@linux-foundation.org> <4875209D.8010603@goop.org>
In-Reply-To: <4875209D.8010603@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> 
> No, you do it the same as i386.  You set the segment base to be 
> percpu_area-__per_cpu_start, and then just refer to %gs:per_cpu__foo 
> directly.  You can use rip-relative addressing to make it a smaller 
> addressing mode too:
> 
>   0:    65 89 05 00 00 00 00     mov    %eax,%gs:0(%rip)        # 0x7
> 

Thinking about this some more, I don't know if it would make sense to 
put the x86-64 stack canary at the *end* of the percpu area, and 
otherwise use negative offsets.  That would make sure they were readily 
reachable from %rip-based references from within the kernel text area.

	-hpa
