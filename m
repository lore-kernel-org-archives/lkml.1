Return-Path: <linux-kernel-owner+w=401wt.eu-S1758920AbYGJUzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758920AbYGJUzR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 16:55:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754123AbYGJUzD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 16:55:03 -0400
Received: from gw.goop.org ([64.81.55.164]:57392 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753940AbYGJUzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 16:55:01 -0400
Message-ID: <48767717.9030100@goop.org>
Date: Thu, 10 Jul 2008 13:54:47 -0700
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
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>	<m1abgqzv3g.fsf@frodo.ebiederm.org> <20080709200757.GD14009@elte.hu>	<48751B57.8030605@goop.org> <20080709133958.612635f0@infradead.org>	<4875231F.1020506@zytor.com> <487524A0.6020304@goop.org>	<487529AE.3060505@zytor.com> <m1r6a2r9nj.fsf@frodo.ebiederm.org>	<48753A71.2030006@zytor.com> <m18wwahauq.fsf@frodo.ebiederm.org>	<48763732.7020805@sgi.com> <m1lk091soo.fsf@frodo.ebiederm.org>	<48765B03.6020905@goop.org> <m1ej61y2da.fsf@frodo.ebiederm.org>	<48766967.7040008@goop.org> <m1fxqhtroj.fsf@frodo.ebiederm.org>
In-Reply-To: <m1fxqhtroj.fsf@frodo.ebiederm.org>
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
>> No, that sounds like a bad idea.  For one, how would you enforce it?  How would
>> you check for it?  It's one of those things that would mostly work and then fail
>> very rarely.
>>     
>
> Well the easiest way would be to avoid the letting people take the address of
> per cpu memory, and just provide macros to read/write it.  We are 90% of the
> way there already so it isn't a big jump.
>   

Well, the x86_X_percpu api is there.  But per_cpu() and get_cpu_var() 
both explicitly return lvalues which can have their addresses taken.

>> Secondly, I depend on it.  I register a percpu structure with Xen to share
>> per-vcpu specific information (interrupt mask, time info, runstate stats, etc).
>>     
>
> Well even virtual allocation is likely to break the Xen sharing case as you
> would at least need to compute the physical address and pass it to Xen.
>   

Right.  At the moment it assumes that the percpu variable is in the 
linear mapping, but it could easily do a pagetable walk if necessary.

    J
