Return-Path: <linux-kernel-owner+w=401wt.eu-S1755435AbYGIUvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbYGIUvt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 16:51:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754477AbYGIUv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 16:51:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34616 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344AbYGIUv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 16:51:27 -0400
Message-ID: <4875231F.1020506@zytor.com>
Date: Wed, 09 Jul 2008 16:44:15 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>	<m1abgqzv3g.fsf@frodo.ebiederm.org>	<20080709200757.GD14009@elte.hu>	<48751B57.8030605@goop.org> <20080709133958.612635f0@infradead.org>
In-Reply-To: <20080709133958.612635f0@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Wed, 09 Jul 2008 13:11:03 -0700
> Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
>> Ingo Molnar wrote:
>>> Note that the zero-based percpu problems are completely unrelated
>>> to stackprotector. I was able to hit them with a
>>> stackprotector-disabled gcc-4.2.3 environment.
>> The only reason we need to keep a zero-based pda is to support 
>> stack-protector.  If we drop drop it, we can drop the pda - and its 
>> special zero-based properties - entirely.
> 
> what's wrong with zero based btw?
> 

Two problems:

1. it means pda references are invalid if their offsets are ever more 
than CONFIG_PHYSICAL_BASE (which I do not think is likely, but still...)

2. some vague hints of a linker bug.

	-hpa
