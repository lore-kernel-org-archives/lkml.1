Return-Path: <linux-kernel-owner+w=401wt.eu-S934030AbXCTQOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934030AbXCTQOI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 12:14:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934029AbXCTQOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 12:14:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49848 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934026AbXCTQOG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 12:14:06 -0400
Message-ID: <460007ED.5010805@redhat.com>
Date: Tue, 20 Mar 2007 12:12:29 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       ak@suse.de, virtualization@lists.linux-foundation.org,
       jbeulich@novell.com, jeremy@goop.org, xen-devel@lists.xensource.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       chrisw@sous-sol.org, virtualization@lists.osdl.org,
       anthony@codemonkey.ws, akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: [patch 13/26] Xen-paravirt_ops: Consistently wrap paravirt ops
 callsites to make them patchable
References: <20070319.120854.30182994.davem@davemloft.net>	<200703192159.42396.ak@suse.de>	<Pine.LNX.4.64.0703192015020.6730@woody.linux-foundation.org>	<20070319.204712.118947830.davem@davemloft.net> <m13b40wnrb.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m13b40wnrb.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
 
> I'm conflicted about the dwarf unwinder.  I was off doing other things
> at the time so I missed the pain, but I do have a distinct recollection of
> the back traces on x86_64 being distinctly worse the on i386.  Lately
> I haven't seen that so it may be I was misinterpreting what I was
> seeing, and the compiler optimizations were what gave me such weird
> back traces.  
> 

Well, if you compile x86_64 with frame pointers it helps a bit because
the compiler doesn't tail merge function calls. But the stack backtrace
ignores the frame pointers even if they're present, unlike i386 which
will use them.

