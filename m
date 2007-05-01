Return-Path: <linux-kernel-owner+w=401wt.eu-S1422721AbXEAUZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422721AbXEAUZg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 16:25:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965440AbXEAUZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 16:25:36 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:53669 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965211AbXEAUZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 16:25:35 -0400
Date: Tue, 1 May 2007 13:24:56 -0700
From: Bill Irwin <bill.irwin@oracle.com>
To: Ulrich Drepper <drepper@gmail.com>
Cc: Bill Irwin <bill.irwin@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>, linux-kernel@vger.kernel.org,
       wli@holomorphy.com
Subject: Re: per-thread rusage
Message-ID: <20070501202456.GR26598@holomorphy.com>
Mail-Followup-To: Bill Irwin <bill.irwin@oracle.com>,
	Ulrich Drepper <drepper@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Dumazet <dada1@cosmosbay.com>, linux-kernel@vger.kernel.org
References: <20070404172931.GM2986@holomorphy.com> <20070404194829.1a93d8fd.dada1@cosmosbay.com> <20070404181050.GN2986@holomorphy.com> <20070409165315.4704021f.akpm@linux-foundation.org> <20070410004201.GA2986@holomorphy.com> <20070501172937.GQ26598@holomorphy.com> <a36005b50705011139p361dbc46ube0da5e42955f8b0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a36005b50705011139p361dbc46ube0da5e42955f8b0@mail.gmail.com>
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/1/07, Bill Irwin <bill.irwin@oracle.com> wrote:
>> A sort of note for me to refer back to when I get the rest of the way
>> here. AIX does this with getrusage(RUSAGE_THREAD,...), Solaris with
>> getrusage(RUSAGE_LWP,...),

On Tue, May 01, 2007 at 11:39:46AM -0700, Ulrich Drepper wrote:
> RUSAGE_LWP is a remnant of Solaris' M-on-N thread library days.  No
> reason to got there.  Use RUSAGE_THREAD.  Even though the kernel calls
> the process and process group, at userland these are threads and
> processes.

Well, this is just the part where I'm surveying how other OS's report
getrusage-like info on a per-thread basis. As far as this is concerned,
RUSAGE_LWP is just Solaris nomenclature for it. The implementation
details (e.g. M:N thread disambiguation) are not so important for this.
What I think it means is "Solaris and AIX pass a nonstandard flag to
getrusage() for the same purpose."

And actually, you're a good person to ask about all this. How do other
kernels/OS's report per-thread analogues of rusage information? Googling
for getrusage() manpages is probably not going to find ones that, say,
force userspace to fish it out of /proc/ analogues and so on. The basic
idea is to try to do it similarly to how everyone else does so userspace
(I suppose this would include glibc) don't have to bend over backward to
accommodate it. Or basically to do what everyone expects.


- wli
