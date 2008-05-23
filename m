Return-Path: <linux-kernel-owner+w=401wt.eu-S1760785AbYEWEiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760785AbYEWEiW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 00:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760477AbYEWEiD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 00:38:03 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:35062 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762757AbYEWEh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 00:37:59 -0400
To: "Andrew Morton" <akpm@linux-foundation.org>, zanussi@comcast.net
Subject: Re: [RFC Patch 1/1] trace_printk and trace_dump interface - v2
Reply-To: prasad@linux.vnet.ibm.com
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
Organization: IBM
Cc: prasad@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       dwilder@us.ibm.com, hch@infradead.org
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
In-Reply-To: <20080520131225.46175b3b.akpm@linux-foundation.org>
References: <op.ua9axd2a03j166@prasadkr_t60p.in.ibm.com> <op.ua9a1r0y03j166@prasadkr_t60p.in.ibm.com> <op.ua90vfwv03j166@prasadkr_t60p.in.ibm.com> <20080519162149.50f58b80.akpm@linux-foundation.org> <op.ubgxivbq03j166@prasadkr_t60p.in.ibm.com> <20080520131225.46175b3b.akpm@linux-foundation.org>
Content-Transfer-Encoding: 7bit
Date: Fri, 23 May 2008 10:07:50 +0530
Message-ID: <op.ubla5cik03j166@prasadkr_t60p.in.ibm.com>
User-Agent: Opera Mail/9.26 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 01:12:25PM -0700, Andrew Morton wrote:
> On Wed, 21 May 2008 01:23:09 +0530
> "K.Prasad" <prasad@linux.vnet.ibm.com> wrote:
>>> The name 'trace' (previously GTSC), I gather that it was the chosen
> after
> > much deliberation (http://tinyurl.com/6odoh4), however I'm open to the
> > idea of changing the name (say dbg_printk/dbg_dump?).
> >> Kindly let me know of your suggestions for this, and I will change  
> them
> > during the next version.
> Well I was just putting it out there for consideration.  Yes, I think
> the whole idea of consuming the "trace_*" namespace in this patchset
> was ill-advised.
Since "trace_*" uses relay infrastructure underneath, I am thinking, if it
would be acceptable to rename them to "relay_*", say relay_printk() and
relay_dump(). I would be glad to hear from the 'relay' folks about this
thought.

> Also, I don't know how to move forward with the whole feature - I
> haven't seen a lot of interest from others and I haven't seen much
> discussion of how this feature differs from all the other tracing
> things which have been floating about.
More than a tracing mechanism, this is a tool that aids in tracing, by
providing a powerful function that directs its output onto the debugfs
mount path which could be later harnessed by user-space applications
too. A potential in-kernel user could be the 'marker' handlers which
more often would be interested in logging data.

> And even if the proposed patches presently offer unique and useful
> features, will one of the other tracing implementations (eg: ltt) later
> grow to close that gap?
> I'm also a bit dubious about the whole thing based on past experience
> with kernel-developer-only in-kernel tools.  People just don't use them
> much.  One example: fault injection.

Among the other enhancements that we were contemplating for this
mechanism, to make it more powerful and unique, is the ability to
a)Define callback functions typically invoked everytime before accessing/
   printing each variable (which may say, acquire a lock or prefix a
   timestamp) by adding fields to the trace_printk_data structure.
b)Provide sequencing information for the output, along with ability to
   prefix the output with essential data such as PID, Timestamp, CPUID,
   etc.

Thanks for letting us know your thoughts on this.

--K.Prasad
