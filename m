Return-Path: <linux-kernel-owner+w=401wt.eu-S1757350AbYGIVD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350AbYGIVD5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 17:03:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754060AbYGIVDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 17:03:47 -0400
Received: from relay1.sgi.com ([192.48.171.29]:56712 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751489AbYGIVDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 17:03:46 -0400
Message-ID: <487527B1.4070305@sgi.com>
Date: Wed, 09 Jul 2008 14:03:45 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com> <4874F30C.8020800@zytor.com> <4874F909.7060503@goop.org> <4874FEDF.90404@sgi.com> <20080709193404.GC4804@elte.hu>
In-Reply-To: <20080709193404.GC4804@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>>> This fragility makes me very nervous.  It seems hard enough to get 
>>> this stuff working with current tools; making it work over the whole 
>>> range of supported tools looks like its going to be hard.
>> (me too ;-)
>>
>> Once I get a solid version working with (at least) gcc-4.2.4, then 
>> regression testing with older tools will be easier, or at least a 
>> table of results can be produced.
> 
> the problem is, we cannot just put it even into tip/master if there's no 
> short-term hope of fixing a problem it triggers. gcc-4.2.3 is solid for 
> me otherwise, for series of thousands of randomly built kernels.

Great, I'll request we load gcc-4.2.3 on our devel server.

> 
> can we just leave out the zero-based percpu stuff safely and could i 
> test the rest of your series - or are there dependencies? I think 
> zero-based percpu, while nice in theory, is probably just a very small 
> positive effect so it's not a life or death issue. (or is there any 
> deeper, semantic reason why we'd want it?)

I sort of assumed that zero-based would not make it into 2.6.26-rcX,
and no, reaching 4096 cpus does not require it.  The other patches
I've been submitting are more general and will fix possible panics
(like stack overflows, etc.)

Thanks,
Mike
