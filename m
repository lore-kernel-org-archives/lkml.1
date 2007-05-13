Return-Path: <linux-kernel-owner+w=401wt.eu-S1757655AbXEMFkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757655AbXEMFkG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 01:40:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755662AbXEMFj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 01:39:57 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54335 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306AbXEMFj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 01:39:56 -0400
Subject: Re: [PATCH 8/8] One Laptop Per Child power/battery driver
From: David Woodhouse <dwmw2@infradead.org>
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: "Maciej W. Rozycki" <macro-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>,
       Andrew Morton <akpm-3NddpPZAyC0@public.gmane.org>,
       kernel-discuss-CN5wO63fgwogsBAKwltoeQ@public.gmane.org,
       Greg KH <gregkh-l3A5Bk7waGM@public.gmane.org>,
       linux-kernel@vger.kernel.org,
       Anton Vorontsov <cbou-JGs/UdohzUI@public.gmane.org>,
       Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>,
       Satyam Sharma 
	<satyam.sharma-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
In-Reply-To: <20070512093509.f3d1865f.zaitcev@redhat.com>
References: <20070503213303.GH20067@zarina> <20070507140453.GD3868@ucw.cz>
	 <1178550653.11851.191.camel@pmac.infradead.org>
	 <20070507194949.GB3981@ucw.cz>
	 <a781481a0705071304m7f6d1b7ewa179e291f52689a4@mail.gmail.com>
	 <Pine.LNX.4.64N.0705081831070.30981@blysk.ds.pg.gda.pl>
	 <1178646751.2824.48.camel@pmac.infradead.org>
	 <20070512093509.f3d1865f.zaitcev@redhat.com>
Content-Type: text/plain
Date: Sun, 13 May 2007 13:39:48 +0800
Message-Id: <1179034789.2802.61.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7.dwmw2.2) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please don't use my work email address unless I _really_ need to be
wearing my tinfoil hat when I read it.

On Sat, 2007-05-12 at 09:35 -0700, Pete Zaitcev wrote:
> On Tue, 08 May 2007 18:52:31 +0100, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> > On Tue, 2007-05-08 at 18:45 +0100, Maciej W. Rozycki wrote:
> 
> > >  Well, my name has an acute above "o" and a dot above "z", but I do not 
> > > have such a high expectation as to have it correctly spelled in comments 
> > > and elsewhere within some code before I am able to get it right in 
> > > official documents issued in English.  And the universe is not going to 
> > > collapse because of the missing accents, so I consider this an issue we 
> > > can think of resolving once we have fixed all the bugs that we have.
> > 
> > It's not an issue which needs resolving. We can spell your name just
> > fine; we just need Pavel to quit whining and join us in the 21st
> > century.
> 
> I hate to agree with Pavel, but the real issue here is you being
> intentionally obtuse. Naked patches are not compatible with UTF-8.

Wrong. Of course they're compatible -- they're just applied as a byte
stream. Patch and git are agnostic about file _contents_.

Git's apply-mailbox tool does honour the Content-Type: header in the
mail, and it converts _comments_ to the correct charset for the
repository, as well as handling RFC2047-encoding in the From: header.
But it doesn't touch the patch itself.

> To assume that UTF-8 is not converted anywhere is tantamount to the
> fallacy of SPF: Everyone on the net must do foo, then nirvana happens
> If the code is being pulled git to git, UTF-8 is fine. Or send your
> patches in MIME at the very least.

Some systems mangle whitespace in transit too, or even convert to HTML.
I've known people who _have_ to send patches as MIME attachments to
avoid having their patches converted to HTML. By your logic, we could
argue that we shouldn't send patches in email at all, because it's also
"tantamount to the fallacy of SPF".

But we'd be wrong -- just as you are. SPF is utterly moronic because it
suddenly tries to change the rules and assumes that everyone has already
changed, or it throws away valid email from unknown senders. In the case
of sending patches, yes you _do_ assume that people aren't doing bizarre
things to mangle them in transit, but that mangling is actually
relatively rare. Not only that, but you only really care about a
_single_ transit path, from you to whoever applies the patch. Which is
easy enough to debug if it starts to do stupid things like converting to
HTML or converting charsets.

-- 
dwmw2

