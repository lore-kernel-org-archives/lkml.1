Return-Path: <linux-kernel-owner+w=401wt.eu-S1751761AbZIXKtJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761AbZIXKtJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 06:49:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751018AbZIXKtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 06:49:04 -0400
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:13138 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751206AbZIXKtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 06:49:03 -0400
X-Trace: 262638216/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.2.195/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.2.195
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqIEAFLrukpQKQLD/2dsb2JhbACBUtQ7gjqBYQU
X-IronPort-AV: E=Sophos;i="4.44,445,1249254000"; 
   d="scan'208";a="262638216"
Date: Thu, 24 Sep 2009 11:49:02 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Michal Simek <michal.simek@petalogix.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       John Williams <john.williams@petalogix.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org
Subject: Re: Microblaze noMMU break - mm/nommu.h
In-Reply-To: <e6a72e5f0909232343w55c2fc89pd4924baf7390976b@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0909241112050.3328@sister.anvils>
References: <e6a72e5f0909230313j7ea0f232led2b7899dd555af0@mail.gmail.com> 
 <Pine.LNX.4.64.0909231645360.18774@sister.anvils>
 <e6a72e5f0909232343w55c2fc89pd4924baf7390976b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Sep 2009, Michal Simek wrote:
> 2009/9/23 Hugh Dickins <hugh.dickins@tiscali.co.uk>
> >
> > Thank you for testing linux-next, but these kind of inadvertent
> > breaks to CONFIG_NOMMU are probably most often caused by changes
> > coming in via Andrew's mmotm - where most (liable to break nomm)
> > mm development occurs.
> >
> 
> you are welcome.
> 
> >
> > linux-next was started really as a service to make Andrew's life
> > with mmotm slightly easier, but now, yes, he would like to move
> > over to getting his mm series into linux-next... but it's not a
> > trivial task to turn that around.
> >
> > If it's possible for you to test mmotms, your input on breakages
> > would be much appreciated; but I can quite understand that linux-next
> > is enough work for you, and that I appear to be bleating at you to
> > do something different, when it's me who needs to learn to be more
> > careful and build more configs.
> >
> 
> I can easily test any git tree - just give me link. + info how is this tree
> maintained
> will be helpful too. (If is used rebase, if yes - on which tree, etc)

Thank you.

   git://git.zen-sources.org/zen/mmotm.git

At first I was going to say that mmotm is maintained as a quilt tree,
a tarfile of patches against the last -rcN (including one origin.patch
of the changes in Linus's tree, and the linux-next.patch from that),
which you would apply using quilt.

But you're git-oriented, so wouldn't be wanting to spend time on that:
it is also made available nowadays as a git tree, which should suit you
much better - but that is constructed from the original quilt patches,
and I don't actually use it myself, so can't guarantee how well it works.

Here's what Andrew says in one of his mm-commits and lkml announcements
(they're irregular, depending on many factors, principally Andrew's
load: roughly one or perhaps two per week).  Sometimes an mmotm comes
out just after Linus releases a new -rcN, but the mmotm would then
be based on the previous -rcN - since it needs to include the prior
linux-next, and be tested to some extent.

Quote:

The mm-of-the-moment snapshot 2009-09-17-18-00 has been uploaded to

   http://userweb.kernel.org/~akpm/mmotm/

and will soon be available at

   git://git.zen-sources.org/zen/mmotm.git

It contains the following patches against 2.6.31:

origin.patch				# recent diff from -rcN to Linus -git
[urgent fix patches]
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
[misc patches akpm is holding]
mm.patch				# which appends -mm1 to the -rcN
[mm and other patches ]

(when I write of an -rcN, well, at present it's just 2.6.31 itself,
no "-rcN" at all.)

> 
> I tested it and works.

Thanks for reporting back: Linus was paying attention to the thread,
and put the fix in directly without any more prompting.

> There is one new issue about pagewalk in different patch. :-(

Our sympathies.

Hugh
