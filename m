Return-Path: <linux-kernel-owner+w=401wt.eu-S1755170AbZJLJEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170AbZJLJEA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 05:04:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754888AbZJLJEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 05:04:00 -0400
Received: from mail-yx0-f188.google.com ([209.85.210.188]:45420 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754785AbZJLJD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 05:03:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=UEDRwubxOScY/l3fvosY88en67oeSBnw18WZawa1Wq/7dkm2TnQIz1FwnDwubvaq37
         5IX8l30jsGFmZ87xoBELCNJry1jkV2BRJPoauZwhN6rGjcFPZf1dni92PnG8JRWuq2yc
         7GBP7XZIKm2VhrVyDMihP/RqdBV/3UUtocQAg=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0910112216060.12574@localhost.localdomain>
References: <alpine.LFD.2.00.0910112216060.12574@localhost.localdomain>
Date: Mon, 12 Oct 2009 19:03:23 +1000
Message-ID: <21d7e9970910120203k3b411796pf00e3453c4d2297b@mail.gmail.com>
Subject: Re: [PATCH RFC] frontend.c: Remove the BKL from agp_open
From: Dave Airlie <airlied@gmail.com>
To: John Kacur <jkacur@redhat.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       David Airlie <airlied@linux.ie>, Jonathan Corbet <corbet@lwn.net>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Vincent Sanders <vince@simtec.co.uk>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 6:24 AM, John Kacur <jkacur@redhat.com> wrote:
>
> @David Airlie. I was looking at the agp driver for removal of the bkl
> lock. From what I could tell, the mutex_lock(&(agp_fe.agp_mutex)) should
> cover what we need. However, I may have easily missed something, and would
> appreciate your review / comments on the patch.

This seems fine, though I suck at locking logic,

One thing to note is the number of users of this interface is probably
close to 0,
so even if this does break something we probably won't ever find out.

Dave.
