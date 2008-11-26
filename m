Return-Path: <linux-kernel-owner+w=401wt.eu-S1754013AbYKZDZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbYKZDZF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 22:25:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753043AbYKZDYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 22:24:54 -0500
Received: from ti-out-0910.google.com ([209.85.142.191]:9378 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982AbYKZDYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 22:24:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HYe3qHHgNIX+R4VhPvMYJ4mbriO1ZA/bpLu1WGZPCZYjXDUniN7cYBZJ1LZIZWEXns
         hn2eNs7anTqjSd06oP51fqIieH4iNZjRyRHtxA2ChIOVyd1RBXEr0XOd5zq5w3Vh1Vez
         nxeQ6cw2Rjh0SqMTrEgSnsSjO7wnJQCNmzK8M=
Date: Wed, 26 Nov 2008 11:24:47 +0800
From: walimis <walimisdev@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>, Steven Rostedt <rostedt@goodmis.org>,
       Liming Wang <liming.wang@windriver.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ftrace: adding other non-leaving .text sections
Message-ID: <20081126032447.GB16166@ubuntu.mshome.net>
References: <1227666566-9044-1-git-send-email-liming.wang@windriver.com> <alpine.DEB.1.10.0811252201270.26424@gandalf.stny.rr.com> <20081126030446.GA14685@linux-sh.org> <20081126031438.GA16166@ubuntu.mshome.net> <20081126031850.GB14685@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081126031850.GB14685@linux-sh.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2008 at 12:18:50PM +0900, Paul Mundt wrote:
>On Wed, Nov 26, 2008 at 11:14:38AM +0800, walimis wrote:
>> On Wed, Nov 26, 2008 at 12:04:46PM +0900, Paul Mundt wrote:
>> >On Tue, Nov 25, 2008 at 10:03:35PM -0500, Steven Rostedt wrote:
>> >> 
>> >> On Wed, 26 Nov 2008, Liming Wang wrote:
>> >> 
>> >> > Please review this patch, and I don't know whether new sections will conflict 
>> >> > with sched tracer or others. 
>> >> > This patch is against Steven tree's tip/devel latest commit.
>> >> > 
>> >> > Impact: improve recordmcount.pl
>> >> > 
>> >> > Besides .text section, there are three .text sections that won't
>> >> > be freed after kernel booting. They are: .sched.text, .spinlock.text
>> >> > and .kprobes.text, which contain functions we can trace. But the last
>> >> > section ".kprobes.text" is particular, which has been marked as "notrace",
>> >> > we ignore it. Thus we add other two sections.
>> >> 
>> >> Yep, only those sections that we know will not disappear are OK. I was
>> >> conservative with only using ".text" but I knew there were other sections 
>> >> that were OK, so I used the hash array to make it easy to add others.
>> >> 
>> >Does your .text cover .text.head by the way?
>> No, and not needed. Because .text.head is of booting code, to which
>> function tracer can't trace.
>> 
>In the case of CPU hotplug it can be entered at any time. I don't see why
>it can't be traced from the boot CPU at least.
OK, I see. Need more investigating on it.
Thanks.

