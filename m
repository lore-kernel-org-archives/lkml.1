Return-Path: <linux-kernel-owner+w=401wt.eu-S1161604AbXDLMHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161604AbXDLMHV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 08:07:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161602AbXDLMHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 08:07:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56334 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161598AbXDLMHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 08:07:20 -0400
To: "Ken Chen" <kenchen@google.com>
Cc: "Zach Brown" <zach.brown@oracle.com>, akpm@linux-foundation.org,
       linux-aio@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] convert aio event reap to use atomic-op instead of spin_lock
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
References: <20070410235353.325A7346F64@localhost>
	<20070411180038.GN28322@mami.zabbo.net>
	<b040c32a0704111228t5065253en9249ff88db5b1384@mail.gmail.com>
	<b040c32a0704120029u423bfd39pfa0479c3c678ebe2@mail.gmail.com>
From: Jeff Moyer <jmoyer@redhat.com>
Date: Thu, 12 Apr 2007 08:06:28 -0400
In-Reply-To: <b040c32a0704120029u423bfd39pfa0479c3c678ebe2@mail.gmail.com> (Ken Chen's message of "Thu, 12 Apr 2007 00:29:28 -0700")
Message-ID: <x49ejmp3igr.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.5-b27 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

==> On Thu, 12 Apr 2007 00:29:28 -0700, "Ken Chen" <kenchen@google.com> said:

Ken> On 4/11/07, Ken Chen <kenchen@google.com> wrote:
Ken> > On 4/11/07, Zach Brown <zach.brown@oracle.com> wrote:
Ken> > > First, I'll NAK this and all AIO patches until the patch
Ken> description > > says that it's been run through the regression
Ken> tests that we've started > > collecting in autotest.  They're
Ken> trivial to run, never fear:
Ken> >
Ken> > OK.  I will run those regression tests.

Ken> Unfortunately, the aio_dio_bugs test in autotest has bug in it
Ken> :-( We need stress test the "test code".

Ken> on stock 2.6.21-rc6 kernel:

Ken> [rock-me-baby]$ cd autotest/tests/aio_dio_bugs/src
Ken> [rock-me-baby]$ make [rock-me-baby]$
Ken> ./aio-free-ring-with-bogus-nr-pages
Ken> aio-free-ring-with-bogus-nr-pages: Error: io_setup returned -22,
Ken> expected -ENOMEM

Ken> hmm???  The problem is that the test code forgot to initialized
Ken> ctx variable and in the kernel, sys_io_setup returns EINVAL if
Ken> user address contain none-zero value.

Zach had already sent a fix for that.  I wonder why it didn't go in.

I didn't see any response to Zach's request for code that actually
tests out the shared ring buffer.  Do you have such code?

-Jeff
