Return-Path: <linux-kernel-owner+w=401wt.eu-S1755892AbYGIUSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892AbYGIUSq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 16:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751520AbYGIUSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 16:18:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44490 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751527AbYGIUSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 16:18:36 -0400
Message-ID: <48751CF9.4020901@linux-foundation.org>
Date: Wed, 09 Jul 2008 15:18:01 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com> <m1abgqzv3g.fsf@frodo.ebiederm.org> <20080709200757.GD14009@elte.hu> <48751B57.8030605@goop.org>
In-Reply-To: <48751B57.8030605@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Ingo Molnar wrote:
>> Note that the zero-based percpu problems are completely unrelated to
>> stackprotector. I was able to hit them with a stackprotector-disabled
>> gcc-4.2.3 environment.
> 
> The only reason we need to keep a zero-based pda is to support
> stack-protector.  If we drop drop it, we can drop the pda - and its
> special zero-based properties - entirely.


Another reason to use a zero based per cpu area is to limit the offset range. Limiting the offset range allows in turn to limit the size of the generated instructions because it is part of the instruction. It also is easier to handle since __per_cpu_start does not figure
in the calculation of the offsets.


