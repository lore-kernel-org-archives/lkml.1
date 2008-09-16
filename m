Return-Path: <linux-kernel-owner+w=401wt.eu-S1753669AbYIPIpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669AbYIPIpr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 04:45:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577AbYIPIpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 04:45:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39199 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884AbYIPIpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 04:45:38 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Linux - Novell
To: Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH ?] ACPI: pr->id is unsigned
Date: Tue, 16 Sep 2008 10:45:31 +0200
User-Agent: KMail/1.9.9
Cc: roel kluin <roel.kluin@gmail.com>, ak@linux.intel.com, lenb@kernel.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <48CF0CA4.3090701@gmail.com> <128370.1221510405@turing-police.cc.vt.edu>
In-Reply-To: <128370.1221510405@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809161045.35078.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 September 2008 22:26:45 Valdis.Kletnieks@vt.edu wrote:
> On Mon, 15 Sep 2008 21:32:20 EDT, roel kluin said:
> > since pr->id is unsigned, shouldn't something like
> > the patch below be applied?
> >
> > +	BUG_ON((pr->id >= nr_cpu_ids) || ((unsigned long)pr->id < 0));
>
> Under what conditions will the clause "(unsigned long)pr->id < 0)" be true,
> and when will it be false?  What will any sane optimizing compiler do?
>
> And *sometimes*, the *real* bug is that pr->id should be a signed quantity,
> not an unsigned one, and the cast is just papering over the issue.
>
> In other words, the original line is almost certainly buggy.  However, this
> isn't the right fix.  Somebody who actually understands the code will have
> to decide what *should* be happening here (that's beyond my understanding
> of that code)...

Just removing "pr->id < 0" condition should be the right fix.

For such an easy patch in the ACPI subsystem it's enough to only post to
the linux-acpi mailing list, no need to bother the whole world.

Thanks for finding this, do you mind to repost a new version?

    Thomas
