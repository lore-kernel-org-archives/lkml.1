Return-Path: <linux-kernel-owner+w=401wt.eu-S1753760AbZLRN5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760AbZLRN5B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 08:57:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753705AbZLRN5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 08:57:00 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:59828 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbZLRN47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 08:56:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=MZdeQStkOLziK/5V+cFiXwid+rtlkKo2ImWk4Hdlngy+0N//zAjwOA7g0OS1dAh8lr
         UdpBbPDqt/aCEZNuGMJ9/Jptm8rimbidSzbNTp3P/rcgZUNv5W64i2tlZRmhwyuHzlr1
         Yz6Q+Oba936I/uwA+zwKPp6GT/3sPYP/Wc3Ak=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] Drop 80-character limit in checkpatch.pl
Date: Fri, 18 Dec 2009 14:55:34 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       =?iso-8859-1?q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org,
       Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com> <200912171618.32882.bzolnier@gmail.com> <alpine.LRH.2.00.0912181400130.21496@twin.jikos.cz>
In-Reply-To: <alpine.LRH.2.00.0912181400130.21496@twin.jikos.cz>
MIME-Version: 1.0
Message-Id: <200912181455.34664.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 December 2009 02:04:37 pm Jiri Kosina wrote:
> On Thu, 17 Dec 2009, Bartlomiej Zolnierkiewicz wrote:
> 
> > > > I like this patch, this is actually what I wanted to do.
> > > 
> > > I have nothing against a switch, but it had better default to off.
> > > 
> > > The whole 80-char limit is insane. It results in insane "fixes". Just 
> > > about every time somebody "improves" a patch due to the warning, the 
> > > result is worse than the original patch.
> > 
> > Examples? :)
> 
> balance_leaf() in fs/reiserfs/do_balan.c
> 
> Example picked totally at random:
> 
> 	set_le_ih_k_offset(ih,
> 			   le_ih_k_offset(ih) +
> 			   (tb->
> 			    lbytes <<
> 			    (is_indirect_le_ih
> 			     (ih) ? tb->tb_sb->
> 			     s_blocksize_bits -
> 			     UNFM_P_SHIFT :
> 			     0)));
> 
> See how everything is nicely aligned to 80 cols?

I see but the above code is an utter crap anyway.

Firstly what kind of a function parameter is that:

   le_ih_k_offset(ih) + (tb->lbytes << (is_indirect_le_ih(ih) ? tb->tb_sb->s_blocksize_bits - UNFM_P_SHIFT : 0))

?

[ BTW 'tb->tb_sb->s_blocksize_bits - UNFM_P_SHIFT' construct is used five
  times in balance_leaf() and is a likely candidate for helper / macro. ]

More importantly the whole balance_leaf() function is almost 1400 LOC (!)
big and impossible to read: code for handling particular 'switch' blocks
should be factored out into separate functions etc.

The point I was making is that the once we remove the limit we don't have
other tool to _automatically_ point suspicious code areas (yes, I would
also prefer intelligent static code checker over dumb limit but it simply
not here as things are today and dumb limit works surprisingly well most
of the time -- please note how that the structural problem with the code
example given is immediately visible with the current limit).

> Generally, don't look at this function after having a good lunch you want 
> to keep. You have been warned.

No worries, I visit dark places (ide, staging, ..) and come back alive.. ;)

--
Bartlomiej Zolnierkiewicz
