Return-Path: <linux-kernel-owner+w=401wt.eu-S1760703AbYGJRc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760703AbYGJRc5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 13:32:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760594AbYGJRcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 13:32:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42258 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760586AbYGJRcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 13:32:43 -0400
Message-ID: <48764783.6030201@linux-foundation.org>
Date: Thu, 10 Jul 2008 12:31:47 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Mike Travis <travis@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>	<m1abgqzv3g.fsf@frodo.ebiederm.org> <20080709200757.GD14009@elte.hu>	<48751B57.8030605@goop.org> <20080709133958.612635f0@infradead.org>	<4875231F.1020506@zytor.com> <487524A0.6020304@goop.org>	<487529AE.3060505@zytor.com> <m1r6a2r9nj.fsf@frodo.ebiederm.org>	<48753A71.2030006@zytor.com> <m18wwahauq.fsf@frodo.ebiederm.org> <48763732.7020805@sgi.com> <487637DE.1050706@zytor.com> <48763A5E.7080105@linux-foundation.org> <48763B36.80104@zytor.com> <48763D1C.8040206@linux-foundation.org> <48764530.7000909@goop.org>
In-Reply-To: <48764530.7000909@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
>
> The base address of the percpu area and the offsets from that base are
> completely independent values.

Definitely.


> The addressing modes:
> 
>    * ABS
>    * off(%rip)
> 
> Are exactly equivalent in what offsets they can generate, so long as *at
> link time* the percpu *symbols* are within 2G of the code addressing
> them.  *After* the addressing mode has generated an effective address
> (by whatever means it likes), the %gs: override applies the segment
> base, which can therefore offset the effective address to anywhere at all.

Right. The problem is with the percpu area handled by the linker. That percpu area is used by the boot cpu and later we setup other additional per cpu areas. Those can be placed in an arbitrary way if one goes through a table of pointers to these areas.

However, that does not work if one calculates the virtual address instead of looking up a physical address.





