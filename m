Return-Path: <linux-kernel-owner+w=401wt.eu-S1762678AbYENNKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762678AbYENNKI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 09:10:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762455AbYENNJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 09:09:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57069 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758354AbYENNJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 09:09:39 -0400
Message-ID: <482AE47F.7080700@redhat.com>
Date: Wed, 14 May 2008 09:09:19 -0400
From: Steven Rostedt <srostedt@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: mingo@elte.hu, acme@redhat.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org
Subject: Re: [PATCH 0/2]: Add sparc64 ftrace support.
References: <20080513.220652.24245811.davem@davemloft.net>
In-Reply-To: <20080513.220652.24245811.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> This was a lot more trivial than I expected, about a 20 minute
> hack.  Most of the time was spent on test boots :)

Cool! This is what we tried to do with ftrace (make it trivial ;-)

> 
> The first patch removes the packed attribute from the ftrace_page
> blob of dynamic ftrace entries, because not only does it cause
> unaligned accesses on sparc64 it's also totally useless.
> 
> The second patch adds sparc64 ftrace support.
> 
> One thing I noticed is that sparc64 uses an mcount implementation
> already for a quick-and-dirty stack usage checker.  I tried to
> make them live alongside eachother.
> 
> Next, I think the mcount symbol export needs some tweaking.  On sparc,
> the symbol _mcount is what the compiler references (this seems to be a
> sparc sysv4'ism) whereas on x86 it appears that plain "mcount" is
> used.  I provide both symbols and we already have a local export of
> "_mcount" to take care of this.  I think architectures should deal
> with this symbol exporting since it is different on every system.

No, the same is for PPC (_mcount). I have a port for this ready. I'll 
look at your code and compare it with my PPC port.

Ingo, do you think it's time I can hand the PPC stuff over to you? I'll 
just have to update it to the lastest linux-ftrace.git.

Thanks,

-- Steve

