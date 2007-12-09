Return-Path: <linux-kernel-owner+w=401wt.eu-S1753623AbXLIEUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623AbXLIEUU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 23:20:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753314AbXLIEUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 23:20:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44507 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085AbXLIEUB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 23:20:01 -0500
From: Neil Brown <neilb@suse.de>
To: "Adrian McMenamin" <lkmladrian@gmail.com>
Date: Sun, 9 Dec 2007 15:19:56 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18267.27884.259885.618469@notabene.brown>
Cc: linux-kernel@vger.kernel.org
Subject: Re: rq_for_each_bio
In-Reply-To: message from Adrian McMenamin on Sunday December 9
References: <8b67d60712081737g2be31ad0j3006a89ef1db0c59@mail.gmail.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday December 9, lkmladrian@gmail.com wrote:
> I have tried to search through the mailing list and it is not entirely
> clear, but it looks like this has gone from the kernel: not least
> because my driver reports:
> 
> drivers/sh/gdrom/gdrom.c:665: error: implicit declaration of function
> 'rq_for_each_bio'
> 
> I am not arguing for a stable ABI/API, I get that one - but is there a
> canonical source of changes in the kernel (because unless you cross
> reference lkml and git repos the mailing list isn't) and if there is -
> how can we get it on the first page of google? :)

The canonical source for changes in the kernel is the git history.  It
stores all of them!

The canonical source for changes in the kernel that are important to
your driver is the output of the compiler.  If the compiler triggers
and error where previously it didn't, then you depend on a part of the
kernel that has changed --- if someone makes an API change that does
not cause a compiler error for people who depend on the old
behaviour, then they have done the wrong thing, but that happens
rarely.

If you get a compiler error, you then look in the git history to find
out when the API changed, and read the comment.  in this case it is
commit 5705f7021748a69d84d6567e68e8851dab551464

If you look at this commit, you will see a brief explanation of the
change, and examples of how new code replaced the old.

> 
> (Actually, forget the theologocal discussion, tell me about rq_for_each_bio)

Every instance in the kernel of rq_for_each_bio used the bio simply to
call bio_for_each_segment.  So we discarded rq_for_each_bio and
introduced rq_for_each_segment.  It make code cleaner (less indent
depth) and means that we can make changes to the rules for iterating
through segments in a request in just one central place.  i.e. we have
a higher level of abstraction.

If you have a usage of rq_for_each_bio where rq_for_each_segment
cannot be used, please show us.

NeilBrown
