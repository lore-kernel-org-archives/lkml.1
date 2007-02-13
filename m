Return-Path: <linux-kernel-owner+w=401wt.eu-S1751367AbXBMWfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751367AbXBMWfQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 17:35:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751373AbXBMWfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 17:35:16 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48805 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367AbXBMWfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 17:35:14 -0500
Date: Tue, 13 Feb 2007 23:32:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Indan Zupancic <indan@nul.nu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [patch 02/11] syslets: add syslet.h include file, user API/ABI definitions
Message-ID: <20070213223241.GJ22104@elte.hu>
References: <20070213142024.GC638@elte.hu> <4390.81.207.0.53.1171397879.squirrel@secure.samage.net> <20070213214335.GC22104@elte.hu> <4715.81.207.0.53.1171405496.squirrel@secure.samage.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4715.81.207.0.53.1171405496.squirrel@secure.samage.net>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.8
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.8 required=5.9 tests=ALL_TRUSTED,BAYES_50 autolearn=no SpamAssassin version=3.1.7
	-1.8 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Indan Zupancic <indan@nul.nu> wrote:

> What I propose:
> 
> 	atom1 returns 0, has SYSLET_STOP_ON_ZERO|SYSLET_SKIP_NEXT_ON_STOP set
> 	atom2
> 	atom3
> 
> (You've already used my SYSLET_SKIP_NEXT_ON_STOP instead of 
> SYSLET_SKIP_TO_NEXT_ON_STOP. ;-)

doh. Yes. I noticed and implemented this yesterday and it's in the 
submitted syslet code - but i guess i was too tired to remember my own 
code - so i added the wrong comments :-/ If you look at the sample 
user-space code:

        init_atom(req, &req->open_file, __NR_sys_open,
                  &req->filename_p, &O_RDONLY_var, NULL, NULL, NULL, NULL,
                  &req->fd, SYSLET_STOP_ON_NEGATIVE, &req->read_file);

the 'STOP_ON_NEGATIVE' acts on that particular atom.

this indeed cleaned up things quite a bit and made the user-space syslet 
code alot more straightforward. A return value can still be recovered 
and examined (with a different condition and a different jump target) 
arbitrary number of times via ret_ptr and via sys_umem_add().

	Ingo
