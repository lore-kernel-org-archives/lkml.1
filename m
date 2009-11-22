Return-Path: <linux-kernel-owner+w=401wt.eu-S1754504AbZKVEIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504AbZKVEIO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 23:08:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754376AbZKVEIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 23:08:14 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:38208 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367AbZKVEIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 23:08:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Asa1A+WbNI9OC2qDxodaxrqe//yws7pkh/gbjyQZZ6FvLz8ud6ePtcrIXaNmQPG7nN
         3+d6ycB/yLbqdW5uqAgIDIBUcshV1vhiPw62xQ6BUEfS5UjXluRYm4ECBbod/+B7dFgy
         Mt4d3A5qwkNAYz2YqfuO8lOl0cSpY3kqFDcZg=
Date: Sun, 22 Nov 2009 05:08:16 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [RFC Patch 4/5] PERF-HW_HBKPT: Enable perf-events to use
	hw-breakpoints
Message-ID: <20091122040815.GC6572@nowhere>
References: <20091029220551.166918079@linux.vnet.ibm.com> <20091029222223.GE14906@in.ibm.com> <20091122025158.GB6572@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091122025158.GB6572@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 22, 2009 at 03:52:00AM +0100, Frederic Weisbecker wrote:
> On Fri, Oct 30, 2009 at 03:52:23AM +0530, K.Prasad wrote:
> > Enable perf-events to collect memory access statistics on kernel-space
> > data in the context of a running process.
> > 
> > Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
> 
> 
> 
> I'm going to take the userspace part of this patch to integrate breakpoints
> in perf tools.
> 
> But I'm not sure passing the name of the symbol to the kernel and store
> it in the perf attr is a good idea.
> We should probably resolve the name from userspace and pass the address
> to the kernel. Mostly because if we want to support breakpoints in
> userspace apps, we don't want conflicts between kernel and userspace
> symbols.
> 
> Thanks.
> 


Hmm, actually instead of memory-write/memory-readwrite
I would rather see:

mem:symbol:[r][w][x]

like mem:pid_max:rw

We could default it to rw for now.

This will be more flexible I guess.
And later for ranges:

mem:symbol[[start]:[len]:[rwx]

This could be:
mem:array_name[0:5]:rwx

So, I'll need an ad-hoc parsing function for this one. This
would be hard by integrating your patch.
I'll try something else. But I can probably take the 5th patch
of your series.

Thanks.

