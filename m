Return-Path: <linux-kernel-owner+w=401wt.eu-S1752851AbZGAGoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851AbZGAGoV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 02:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbZGAGoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 02:44:14 -0400
Received: from deleuze.hcoop.net ([69.90.123.67]:47666 "EHLO deleuze.hcoop.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012AbZGAGoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 02:44:14 -0400
From: Jeremy Maitin-Shepard <jeremy@jeremyms.com>
To: Nigel Cunningham <ncunningham@crca.org.au>
Cc: tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org
Subject: Re: [TuxOnIce-devel] RFC: Suspend-to-ram cold boot protection by encrypting page cache
References: <87hbxx0wcp.fsf@jeremyms.com> <4A4B0125.2090502@crca.org.au>
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-1: winter into spring
Date: Tue, 30 Jun 2009 23:43:53 -0700
In-Reply-To: <4A4B0125.2090502@crca.org.au> (Nigel Cunningham's message of
	"Wed, 01 Jul 2009 16:24:37 +1000")
Message-ID: <87d48k2992.fsf@jeremyms.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nigel Cunningham <ncunningham@crca.org.au> writes:

> Hi Jeremy.
> I'd suggest emailing the Linux-PM list rather than tuxonice-devel.
> TuxOnIce devel focuses on the out-of-vanilla suspend to disk
> enhancements rather than on suspend to ram.

The Linux-PM list is a good suggestion, but I specifically included
tuxonice because of the note at the bottom --- namely that I believe
that tuxonice in particular already includes support for much of what is
needed to implement the idea.

Specifically, suppose right at the stage in tuxonice hibernation when
the kernel as about to write the page cache pages to disk, it instead
just encrypts in place those pages, clears the encryption key, then
waits for the userspace helper to pass it back the key again to use to
decrypt the pages.

In fact it would seems that actually entering S3 is mostly irrelevant in
terms of the implementation.

Tuoxnice already has code to deal with interfacing with a userspace
helper that is kept unfrozen (and its pages handled specially) while
everything else is frozen and the page cache is overwritten, which is
precisely what is needed for this idea.  In particular, it seems that an
implementation of the idea I proposed would look a lot like tuxonice
with a powerdown mode of entering S3, just that instead of writing the
page cache to disk, it is encrypted in place.  I suppose it could well be that
all of the facilities used by tuxonice to do this are actually already
in the kernel, in which case it is indeed not relevant to tuxonice, but
it is not clear that the uswsusp infrastructure has everything that is
needed.

-- 
Jeremy Maitin-Shepard
