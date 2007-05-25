Return-Path: <linux-kernel-owner+w=401wt.eu-S1765372AbXEYSsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765372AbXEYSsg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 14:48:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764066AbXEYSsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 14:48:21 -0400
Received: from mga03.intel.com ([143.182.124.21]:55119 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764044AbXEYSsS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 14:48:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,580,1170662400"; 
   d="scan'208";a="232165277"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [patch] removes MAX_ARG_PAGES
Date: Fri, 25 May 2007 11:48:09 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A018B17DE@scsmsx411.amr.corp.intel.com>
In-Reply-To: <1180020019.7019.133.camel@twins>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch] removes MAX_ARG_PAGES
Thread-Index: AceeFxRGD6tMziZvQSGRqcgfGRFVPQA5SQGg
From: "Luck, Tony" <tony.luck@intel.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Cc: "Ollie Wild" <aaw@google.com>, <linux-kernel@vger.kernel.org>,
       <parisc-linux@lists.parisc-linux.org>, <linux-mm@kvack.org>,
       <linux-arch@vger.kernel.org>, "Andrew Morton" <akpm@osdl.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <ak@suse.de>
X-OriginalArrivalTime: 25 May 2007 18:48:11.0087 (UTC) FILETIME=[3E342DF0:01C79EFD]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I just tried this on an Altix from the test lab, and ia32 bash just
> started.

I don't have any native x86 binaries on my Madison-based testbox, so my
test case was to compile a simple program that counted total length of
argument strings on an x86 box, and copy it to my ia64 box.  So that I
wouldn't have to copy over a bunch of libraries too, I compiled it
with -static.  This is the test case that "hung" my system (re-running
it today from /dev/tty1 instead of from an xterm, I see that it actually
oopsed in rb_next()).  I wasn't even running with a long arglist.  Just
"*" for my home directory (19 files/directories = ~170 bytes).

-Tony

My test program.  Compile on ia32 box with "cc -static -o args args.c"

---- begin args.c ----
main(int argc, char **argv)
{
	int n;

	printf("argc = %d\n", argc);

	n = 0;
	while (--argc)
		n += strlen(*++argv);

	printf("bytes = %d\n", n);
}
