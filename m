Return-Path: <linux-kernel-owner+w=401wt.eu-S1757600AbYGJR0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600AbYGJR0S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 13:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751639AbYGJR0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 13:26:00 -0400
Received: from gw.goop.org ([64.81.55.164]:34057 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511AbYGJRZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 13:25:58 -0400
Message-ID: <48764619.9040708@goop.org>
Date: Thu, 10 Jul 2008 10:25:45 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Mike Travis <travis@sgi.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>	<m1abgqzv3g.fsf@frodo.ebiederm.org> <20080709200757.GD14009@elte.hu>	<48751B57.8030605@goop.org> <20080709133958.612635f0@infradead.org>	<4875231F.1020506@zytor.com> <487524A0.6020304@goop.org>	<487529AE.3060505@zytor.com> <m1r6a2r9nj.fsf@frodo.ebiederm.org>	<48753A71.2030006@zytor.com> <m18wwahauq.fsf@frodo.ebiederm.org> <48763732.7020805@sgi.com> <487641D6.5060206@goop.org> <48764307.20905@linux-foundation.org>
In-Reply-To: <48764307.20905@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> Jeremy Fitzhardinge wrote:
>
>   
>> You want to virtually map the percpu area?  How and when would it get
>> extended?
>>     
>
> It would get extended when cpu_alloc() is called and the allocator finds that there is no per cpu memory available.
>   

Which, I take it, allocates percpu memory.  It would have the same 
caveats as vmalloc memory, with respect to accessing it during fault 
handlers and nmi handlers, I take it.

How would cpu_alloc() actually get used?  It doesn't make much sense for 
general code, since we don't have the notion of a percpu pointer to 
memory (vs a pointer to percpu memory).  Is the intended use for 
allocating percpu memory in modules?  What other uses?

    J
