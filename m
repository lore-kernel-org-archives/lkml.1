Return-Path: <linux-kernel-owner+w=401wt.eu-S1756649AbZERQkE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649AbZERQkE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 12:40:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753956AbZERQjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 12:39:55 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:36671 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752502AbZERQjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 12:39:54 -0400
To: Ingo Molnar <mingo@elte.hu>
cc: Jan Kara <jack@suse.cz>, Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, "Theodore Ts'o" <tytso@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
Subject: Re: updated: ext3 IO latency measurements on v2.6.30-rc1 
In-Reply-To: Your message of "Thu, 09 Apr 2009 23:59:46 +0200."
             <20090409215946.GA28183@elte.hu> (sfid-20090515_115729_335569_6D25DDD8) 
X-Mailer: MH-E 8.1; nmh 1.2; GNU Emacs 22.3.1
Date: Mon, 18 May 2009 12:37:19 -0400
From: Sanjoy Mahajan <sanjoy@mit.edu>
Message-Id: <E1M65q3-0006up-M2@approx.mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To test the ext3 improvements in 2.6.30-rc5, I tried my previous test of
starting an rxvt while findutils or 'aptitude dist-upgrade' is madly
spinning the disk.

With vanilla 2.6.29 in those circumstances, starting an rxvt took 4
seconds on an otherwise unloaded system (Thinkpad T60 w/ 1.83GHz
dual-core CPU, 1.5GB RAM, 5400 rpm drive).  The second rxvt came up
right away.  So the first rxvt probably stalled until /usr/bin/rxvt
could be grabbed from disk.

With 2.6.30-rc5, the rxvt showed up much faster -- either right away
(maybe it was still in the cache) or after about 0.5 seconds (probably
the uncached case).

Other tests were also snappy, like opening a 10MB PDF file in Emacs,
adding a newline at the beginning, and saving it (while findutils was
running).  I hadn't done the same test with 2.6.29, but I'm pretty sure
it would have been painfully slow if findutils was running.

So, relative to 2.6.29, I see a large improvement in interactive
behavior under high IO load.

-Sanjoy

`Until lions have their historians, tales of the hunt shall always
 glorify the hunters.'  --African Proverb
