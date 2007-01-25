Return-Path: <linux-kernel-owner+w=401wt.eu-S965114AbXAYOwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965114AbXAYOwR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 09:52:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965033AbXAYOwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 09:52:17 -0500
Received: from moutng.kundenserver.de ([212.227.126.177]:56863 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965275AbXAYOwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 09:52:16 -0500
X-Greylist: delayed 8605 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Jan 2007 09:52:16 EST
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [RFC] Limit the size of the pagecache
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Aubrey Li <aubreylee@gmail.com>,
       Christoph Lameter <clameter@sgi.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Robin Getz <rgetz@blackfin.uclinux.org>,
       ?missing.closing.'"' in token?"Frysinger",
	Michael <Michael.Frysinger@analog.com>,
	Bryan Wu <cooloney.lkml@gmail.com>,
	 ?missing closing '"'.in.token?"Hennerich"@vax.1wt.eu,
       Michael <Michael.Hennerich@analog.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Illegal-Object: Syntax error in To: address found on vger.kernel.org:
	To:	?missing closing '"' in token?"Frysinger", Michael <Michael.Frysinger@analog.com>, Bryan Wu <cooloney.lkml@gmail.com>, ?missing closing '"' in token?"Hennerich"
			^-extraneous tokens in address
Illegal-Object: Syntax error in To: address found on vger.kernel.org:
	To:	?missing closing '"' in token?"Frysinger", Michael <Michael.Frysinger@analog.com>, Bryan Wu <cooloney.lkml@gmail.com>, ?missing closing '"' in token?"Hennerich"
			^-extraneous tokens in address
Reply-To: 7eggert@gmx.de
Date: Thu, 25 Jan 2007 15:51:34 +0100
References: <7GEEK-4lH-39@gated-at.bofh.it> <7GLdb-5Uz-13@gated-at.bofh.it> <7GRix-7fU-1@gated-at.bofh.it> <7GRLZ-7Uy-29@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1HA5ws-0000vQ-KM@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:9b3b2cc444a07783f194c895a09f1de9
X-Provags-ID2: V01U2FsdGVkX191Hiv7zjHjJdHZA8s9OehakijCHm3V6SWukp5+H7KIETepG/xznq2UtHwdvkDweFXmWpadYXPYV7ICU545TlEaJnTHH1GxMOtRhoU7k/kj/w==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Wed, 2007-01-24 at 22:22 +0800, Aubrey Li wrote:
>> On 1/24/07, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

>> > He wants to make a nommu system act like a mmu system; this will just
>> > never ever work.
>> 
>> Nope. Actually my nommu system works great with some of patches made by us.
>> What let you think this will never work?
> 
> Because there are perfectly valid things user-space can do to mess you
> up. I forgot the test-case but it had something to do with opening a
> million files, this will scatter slab pages all over the place.

a) Limit the number of open files.
b) Don't do that then.

> Also, if you cycle your large user-space allocations a bit unluckily
> you'll also fragment it into oblivion.
> 
> So you can not guarantee it will not fragment into smithereens stopping
> your user-space from using large than page size allocations.

Therefore you should purposely increase the mess up to the point where the
system is guaranteed not to work? IMO you should rather put the other issues
onto the TODO list.

BTW: I'm not sure a hard limit is the right thing to do for mmu systems,
I'd rather implement high and low watermarks; if one pool is larger than
it's high watermark, it will be next get it's pages evicted, and it won't
lose pages if it's at the lower watermark.

> If your user-space consists of several applications that do dynamic
> memory allocation of various sizes its a matter of (run-) time before
> things will start failing.
> 
> If you prealloc a large area at boot time (like we now do for hugepages)
> and use that for user-space, you might 'reset' the status quo by cycling
> the whole of userspace.

Preallocating the page cache (and maybe the slab space?) may very well be
the right thing to do for nommu systems. It worked quite well in DOS times
and on old MACs.
-- 
Funny quotes:
30. Why is a person who plays the piano called a pianist but a person who
    drives a race car not called a racist?
Friﬂ, Spammer: iz@7eggert.dyndns.org pveUtv@rFGfMneI.7eggert.dyndns.org
