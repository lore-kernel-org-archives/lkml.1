Return-Path: <linux-kernel-owner+w=401wt.eu-S1756916AbZFARET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916AbZFARET (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 13:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753790AbZFAREM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 13:04:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53984 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670AbZFAREL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 13:04:11 -0400
Message-ID: <4A2409C3.2000804@zytor.com>
Date: Mon, 01 Jun 2009 10:02:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Borislav Petkov <petkovbb@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Borislav Petkov <borislav.petkov@amd.com>, greg@kroah.com,
       mingo@elte.hu, norsk5@yahoo.com, tglx@linutronix.de, mchehab@redhat.com,
       aris@redhat.com, edt@aei.ca, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com
CC: Sam Ravnborg <sam@ravnborg.org>, "H.J. Lu" <hjl.tools@gmail.com>
Subject: Re: [PATCH 0/4] amd64_edac: misc fixes
References: <1242845037-1029-1-git-send-email-borislav.petkov@amd.com> <20090528164720.0af5752b.akpm@linux-foundation.org> <20090529103329.GB23530@aftab> <20090529130115.a44efaee.akpm@linux-foundation.org> <20090530081954.GA21954@liondog.tnic> <20090530014007.3c1e22d5.akpm@linux-foundation.org> <4A218761.5080607@zytor.com> <20090601145326.GA28260@liondog.tnic> <4A2407D1.5050706@zytor.com>
In-Reply-To: <4A2407D1.5050706@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> 
> Yes, we would have to do something like that.
> 
> However, if you're doing that you shouldn't use typeof() there...
> instead this should be turned into an inline function with explicit
> 64-bit types.
> 
> It would be good if we could get Kbuild to export some kind of macro
> that we can use to test binutils version, so we can do something like:
> 
> #if BINUTILS_VERSION >= KERNEL_VERSION(2,18,50)
> /* Do the right thing */
> #else
> /* Do the wrong thing */
> #endif
> 

The other option, and perhaps a better option, is to key it on the
version of gcc; then we can use the gcc intrinsics __builtin_popcount(),
__builtin_popcountl() and __builtin_popcountll(), which should produce
better code since gcc can schedule them appropriately.

Probably also means passing -msse4.2 to gcc while hoping that that
doesn't enable any #TS-generating instructions (SSE 4.2 is mostly a
collection of integer instructions).

(H.J., any comments?)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

