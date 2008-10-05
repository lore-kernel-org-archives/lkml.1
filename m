Return-Path: <linux-kernel-owner+w=401wt.eu-S1755361AbYJEKBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361AbYJEKBU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 06:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753818AbYJEKBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 06:01:06 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:37736 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753334AbYJEKBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 06:01:04 -0400
Date: Sun, 5 Oct 2008 12:00:38 +0200
From: Pavel Machek <pavel@suse.cz>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, Takashi Sato <t-sato@yk.jp.nec.com>,
       Ric Wheeler <rwheeler@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, linux-fsdevel@vger.kernel.org,
       dm-devel@redhat.com, viro@ZenIV.linux.org.uk,
       linux-ext4@vger.kernel.org, xfs@oss.sgi.com, axboe@kernel.dk,
       mtk.manpages@googlemail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] Add timeout feature
Message-ID: <20081005100037.GB2351@ucw.cz>
References: <20080908205337t-sato@mail.jp.nec.com> <20080908171119.GB22521@infradead.org> <48DBFD42.6030307@redhat.com> <D0B0D91F884647D6808626CDFF81E532@nsl.ad.nec.co.jp> <20080929141326.GA31781@infradead.org> <48E0E7D4.1090409@sandeen.net> <20080929143749.GA13286@infradead.org> <48E0EA0B.7000701@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E0EA0B.7000701@sandeen.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-09-29 09:45:31, Eric Sandeen wrote:
> Christoph Hellwig wrote:
> > On Mon, Sep 29, 2008 at 09:36:04AM -0500, Eric Sandeen wrote:
> >> Christoph Hellwig wrote:
> >>> On Fri, Sep 26, 2008 at 05:52:35PM +0900, Takashi Sato wrote:
> >>>> I think that your concern is that the freezer cannot recognize the occurrence
> >>>> of a timeout and it continues the backup process and the backup data is
> >>>> corrupted finally.
> >>> What timeout should happen?  the freeze ioctl must not return until the
> >>> filesystem is a clean state and all writes are blocked.
> >> The suggestion was that *UN*freeze would return ETIMEDOUT if the
> >> filesystem had already unfrozen itself, I think.  That way you know that
> >> the snapshot you just took is worthless, at least.
> > 
> > But why would the filesystem every unfreeze itself?  That defeats the
> > whole point of freezing it.
> 
> I agree.  Was just trying to clarify the above point.
> 
> But there have been what, 12 submissions now, with the unfreeze timeout
> in place so it's a persistent theme ;)
> 
> Perhaps a demonstration of just how easy (or not easy) it is to deadlock
> a filesystem by freezing the root might be in order, at least.
> 
> And even if it is relatively easy, I still maintain that it is the
> administrator's role to not inflict damage on the machine being
> administered.  There are a lot of potentially dangerous tools at root's
> disposal; why this particular one needs a nanny I'm still not quite sure.

Can you docuument what administrator must not do for freezing to be
safe?

What if so much dirty data accumulates on frozen filesystem that
there's not enough memory for the unfreeze tool?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
