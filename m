Return-Path: <linux-kernel-owner+w=401wt.eu-S1758668AbYBDUZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758668AbYBDUZ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 15:25:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757097AbYBDUZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 15:25:11 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:37644 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754570AbYBDUZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 15:25:09 -0500
Date: Mon, 4 Feb 2008 21:25:27 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Ingo Molnar <mingo@elte.hu>, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: brk randomization breaks columns
Message-ID: <20080204202527.GD4915@elf.ucw.cz>
References: <20080204122837.GA1647@elf.ucw.cz> <20080204130156.GA8730@elte.hu> <20080204132853.GA4630@elf.ucw.cz> <Pine.LNX.4.64.0802041554030.30955@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802041554030.30955@jikos.suse.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Not sure this helps... If I only randomize _end_ of heap, it still 
> > works. If I try to randomize beggining of heap, too, it will not even 
> > start recent binaries :-(.
> 
> I don't uderstand this, sorry. Ehen the mapping for the new process is 
> being established during loading of the binary, the beginning and the end 
> of the heap are the same ...

Okay, I was assuming this is mapping heap..

  /* Calling set_brk effectively mmaps the pages that we need
         * for the bss and break sections.  We must do this before
         * mapping in the interpreter, to make sure it doesn't wind
         * up getting placed where the bss needs to go.
         */
        retval = set_brk(elf_bss, elf_brk);

If I add

+       elf_brk += random;

before set_brk() (and revert the brk randomization), it works,
including columns.

If I add

+//     elf_bss += random;

before set_brk(), I break everything.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
