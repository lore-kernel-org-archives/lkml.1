Return-Path: <linux-kernel-owner+w=401wt.eu-S1755597AbYENE6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597AbYENE6t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 00:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756519AbYENE6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 00:58:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47602 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753070AbYENE6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 00:58:20 -0400
Date: Tue, 13 May 2008 21:57:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, linville@tuxdriver.com,
       ron.rindjunsky@intel.com, sfr@canb.auug.org.au, tomas.winkler@intel.com,
       git@vger.kernel.org
Subject: Re: + wireless-fix-iwlwifi-unify-init-driver-flow.patch added to
 -mm tree
Message-Id: <20080513215737.fe1bdebd.akpm@linux-foundation.org>
In-Reply-To: <20080513.213927.191790810.davem@davemloft.net>
References: <200805140405.m4E45oBc015343@imap1.linux-foundation.org>
	<20080513.213927.191790810.davem@davemloft.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2008 21:39:27 -0700 (PDT) David Miller <davem@davemloft.net> wrote:

> From: akpm@linux-foundation.org
> Date: Tue, 13 May 2008 21:05:50 -0700
> 
> > Subject: wireless: fix "iwlwifi: unify init driver flow"
> > From: Andrew Morton <akpm@linux-foundation.org>
> > 
> > drivers/net/wireless/iwlwifi/iwl-core.c: In function 'iwlcore_init_geos':
> > drivers/net/wireless/iwlwifi/iwl-core.c:323: error: implicit declaration of function 'iwlcore_init_ht_hw_capab'
> > 
> > This (or something like it) should be folded into the base patch to avoid
> > breaking bisection, please.
> > 
> > Cc: Ron Rindjunsky <ron.rindjunsky@intel.com>
> > Cc: Tomas Winkler <tomas.winkler@intel.com>
> > Cc: John W. Linville <linville@tuxdriver.com>
> > Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
> Andrew, you have to figure out what we're supposed to do here.

Well someone does ;)

> If I "fold in the patch" to avoid breaking bisection, I have to
> completely rebase my tree screwing up everyone of my downstream
> developers.
> 
> Or is this some patch I'm supposed to remember to fold in several
> months from now, to some random changeset out of thousands, when the
> merge window opens?
> 
> Neither option is tenable, and the headaches of neither are
> worth it purely for the sake of bisection.
> 
> My solution to the bisection problem is to wait a day before pushing
> out usually, it's a best effort thing.  I do as many sanity builds as
> I can, and we also hope that someone during that day might solve the
> problem independantly and post a fix.  That way I can fix it in my
> tree locally before the tree goes public.
> 
> And I think this is the most reasonable approach.
> 
> Once I push something to my public tree, quite frankly, it's the real
> deal, it's staying there, and it's a part of the permanent record.
> And therefore, we'll put fixes on top.

What goes into Linus's tree is there for ever and I do think that all
the short-term things we do should be built around making the permanent
record as good as possible.

This is a(nother) case where a toolchain/process problem is forcing us
to do something which we don't want to do.  In an ideal world we should
tell the git developers "we want x, please" and hopefully they can give
it to us.  Because right now, we're having to work around shortcomings
in git and we are producing a lesser product as a result of this.  A tool
should follow the way in which humans want to work, not vice versa.

Short-term...  dunno.  Perhaps you could have a two-weekly
broadly-announced rebase in which you integrate all these dribs and
drags back into their proper place?  Commit them with some well-known
identifier in the title so that they can all be located when that time
comes?

If you announce such a rebase a day or so beforehand then all the guys
who feed into you could get their stuff merged up into your tree to
minimise their pain when the rebase happens, perhaps.

(That being said, this particular no-compile isn't a huge problem - it
can be worked around with a Kconfig change.  But that isn't generally
the case)
