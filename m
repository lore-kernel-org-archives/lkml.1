Return-Path: <linux-kernel-owner+w=401wt.eu-S1751917AbZKHLsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917AbZKHLsn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 06:48:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751470AbZKHLsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 06:48:42 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35138 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457AbZKHLsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 06:48:42 -0500
Date: Sun, 8 Nov 2009 12:48:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       hare@suse.de, akpm@linux-foundation.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86: Add back _end symbol that is missing from
 Symbol.map
Message-ID: <20091108114829.GQ11372@elte.hu>
References: <200911041519.nA4FJWEW030164@imap1.linux-foundation.org>
 <tip-d1e4d37b79e944f6351ae38eb1ca7c9f7b506e76@git.kernel.org>
 <20091108113805.GA11847@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091108113805.GA11847@merkur.ravnborg.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sam Ravnborg <sam@ravnborg.org> wrote:

> On Sun, Nov 08, 2009 at 11:07:12AM +0000, tip-bot for Hannes Reinecke wrote:
> > Commit-ID:  d1e4d37b79e944f6351ae38eb1ca7c9f7b506e76
> > Gitweb:     http://git.kernel.org/tip/d1e4d37b79e944f6351ae38eb1ca7c9f7b506e76
> > Author:     Hannes Reinecke <hare@suse.de>
> > AuthorDate: Wed, 4 Nov 2009 07:19:32 -0800
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Sun, 8 Nov 2009 12:05:03 +0100
> > 
> > x86: Add back _end symbol that is missing from Symbol.map
> > 
> > With 2.6.31 'crash' on x86_64 falls flat on its face as the
> > '_end' symbol is missing from the System.map file.
> > 
> > The culprit is commit 091e52c3551d3031343df24b573b770b4c6c72b6,
> > which moved the '_end' symbol into it's own section.  Apparently
> > this causes kallsyms to not reference it properly.
> > 
> > So do not include _end in it's own section.
> > 
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Sam Ravnborg <sam@ravnborg.org>
> > Cc: <stable@kernel.org> # .31.x
> > LKML-Reference: <200911041519.nA4FJWEW030164@imap1.linux-foundation.org>
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> I'm afraid this will break a RELOCTABLE i386 kernel.
> 
> We fixed this up some time ago where we had to
> move the symbol definition inside a section
> to prevent the symbol being absolute.

ah, indeed. So ... the question is then, why did _end disappear from 
System.map?

	Ingo
