Return-Path: <linux-kernel-owner+w=401wt.eu-S1760054AbYGJT4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760054AbYGJT4q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 15:56:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753314AbYGJT4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 15:56:38 -0400
Received: from gw.goop.org ([64.81.55.164]:41339 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752419AbYGJT4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 15:56:37 -0400
Message-ID: <48766967.7040008@goop.org>
Date: Thu, 10 Jul 2008 12:56:23 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Mike Travis <travis@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>	<m1abgqzv3g.fsf@frodo.ebiederm.org> <20080709200757.GD14009@elte.hu>	<48751B57.8030605@goop.org> <20080709133958.612635f0@infradead.org>	<4875231F.1020506@zytor.com> <487524A0.6020304@goop.org>	<487529AE.3060505@zytor.com> <m1r6a2r9nj.fsf@frodo.ebiederm.org>	<48753A71.2030006@zytor.com> <m18wwahauq.fsf@frodo.ebiederm.org>	<48763732.7020805@sgi.com> <m1lk091soo.fsf@frodo.ebiederm.org>	<48765B03.6020905@goop.org> <m1ej61y2da.fsf@frodo.ebiederm.org>
In-Reply-To: <m1ej61y2da.fsf@frodo.ebiederm.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Jeremy Fitzhardinge <jeremy@goop.org> writes:
>
>   
>> Eric W. Biederman wrote:
>>     
>>> I think we can get away with just simply realloc'ing the percpu area
>>> on each cpu.  No fancy table manipulations required.  Just update
>>> the base pointer in %gs and in someplace global.
>>>
>>>       
>> It's perfectly legitimate to take the address of a percpu variable and store it
>> somewhere.  We can't move them around.
>>     
>
> Really?  I guess there are cases where that makes sense.  It is a pretty
> rare case though.  Especially when you are not talking about doing it temporarily
> with preemption disabled.  There are few enough users of the API I think we can
> certainly explore the cost of forbidding in the general case of storing the
> address of a percpu variable.
>   

No, that sounds like a bad idea.  For one, how would you enforce it?  
How would you check for it?  It's one of those things that would mostly 
work and then fail very rarely.

Secondly, I depend on it.  I register a percpu structure with Xen to 
share per-vcpu specific information (interrupt mask, time info, runstate 
stats, etc).

    J
