Return-Path: <linux-kernel-owner+w=401wt.eu-S1756052AbYGHXKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052AbYGHXKn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754756AbYGHXKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:10:34 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:53291 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752500AbYGHXKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:10:32 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAAePc0h5LFxA/2dsb2JhbACyEg
X-IronPort-AV: E=Sophos;i="4.30,326,1212330600"; 
   d="scan'208";a="144725750"
Date: Wed, 9 Jul 2008 09:10:27 +1000
From: Dave Chinner <david@fromorbit.com>
To: Pavel Machek <pavel@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, Takashi Sato <t-sato@yk.jp.nec.com>,
       akpm@linux-foundation.org, viro@ZenIV.linux.org.uk,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
       "xfs@oss.sgi.com" <xfs@oss.sgi.com>,
       "dm-devel@redhat.com" <dm-devel@redhat.com>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       axboe@kernel.dk, mtk.manpages@googlemail.com
Subject: Re: [PATCH 3/3] Add timeout feature
Message-ID: <20080708231026.GP11558@disturbed>
Mail-Followup-To: Pavel Machek <pavel@suse.cz>,
	Christoph Hellwig <hch@infradead.org>,
	Takashi Sato <t-sato@yk.jp.nec.com>, akpm@linux-foundation.org,
	viro@ZenIV.linux.org.uk,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"xfs@oss.sgi.com" <xfs@oss.sgi.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	axboe@kernel.dk, mtk.manpages@googlemail.com
References: <20080630212450t-sato@mail.jp.nec.com> <20080701081026.GB16691@infradead.org> <20080707110730.GG5643@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080707110730.GG5643@ucw.cz>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2008 at 01:07:31PM +0200, Pavel Machek wrote:
> Hi!
> 
> > I still disagree with this whole patch.  There is not reason to let
> > the freeze request timeout - an auto-unfreezing will only confuse the
> > hell out of the caller.  The only reason where the current XFS freeze
> > call can hang and this would be theoretically useful is when the
> 
> What happens when someone dirties so much data that vm swaps out
> whatever process that frozen the filesystem?

a) you can't dirty a frozen filesystem - by definition a frozen
   filesystem is a *clean filesystem* and *cannot be dirtied*.
b) Swap doesn't write through the filesystem
c) you can still read from a frozen filesystem to page your
   executableѕ in.
d) if dirtying another unfrozen filesystem swaps out your
   application so it can't run, then there's a major VM bug.
   Regardless, until the app completes it is relying on the
   filesystem being frozen, so it better remain frozen....

> I though that was why the timeout was there...

Not that I know of. 

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
