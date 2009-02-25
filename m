Return-Path: <linux-kernel-owner+w=401wt.eu-S1758645AbZBYDu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758645AbZBYDu3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 22:50:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754016AbZBYDuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 22:50:16 -0500
Received: from smtp116.mail.mud.yahoo.com ([209.191.84.165]:20580 "HELO
	smtp116.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753011AbZBYDuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 22:50:15 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=u7k0WDrCiM7RsFVufqvZtuRY0tDwUvQLP5/sm3h/yXx0IOvMcuk2doMDzn6IMlt8kP/9fA0qdOPYOj/c9ueTXRXmIvHyolev7+7k1q6aABXw+VWCV93ebYrLvUlkF9LrBCRVCALfX9xDWRKEqTu86vYPJIZOvzvljpAyYnB25g0=  ;
X-YMail-OSG: .nw1mdUVM1kDMDFE6Nm.qcCRcti8tsNnRbFj8PO01DKpVXW6e2jG_MqNpUGTGqFKKQ5rjStS.TtzMezWjlOzv3wmSKmWNAMNsawlrMRpr4vwGowFzBUR35Nq2NzyOnoHPjs4BhOZUA2kQPuKxeENJfBynpccgSbT55SQIrP7iakujalNquDRc9P5wHO.UNMtgbdX.TonyftBiIrz06bstDScMu1cDQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: Another Performance Regression in write() syscall
Date: Wed, 25 Feb 2009 14:49:37 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Salman Qazi <sqazi@google.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Dave Hansen <haveblue@us.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20090224060558.GA14812@google.com> <200902241947.53180.nickpiggin@yahoo.com.au> <1235494732.26788.256.camel@nimitz>
In-Reply-To: <1235494732.26788.256.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902251449.38361.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 February 2009 03:58:52 Dave Hansen wrote:
> On Tue, 2009-02-24 at 19:47 +1100, Nick Piggin wrote:
> > On Tuesday 24 February 2009 17:25:45 Dave Hansen wrote:
> > > On Mon, 2009-02-23 at 22:05 -0800, Salman Qazi wrote:
> > > > Analysis of profile data has led us to believe that the commit
> > > > 3d733633a633065729c9e4e254b2e5442c00ef7e has caused a performance
> > > > regression.  This commit provides for tracking of writers so that
> > > > read only bind mounts function correctly.
> > > >
> > > > We can verify this regression by applying the following patch to
> > > > partially disable the above-mentioned commit and then running the
> > > > fstime component of Unixbench.  The settings used were 256 byte
> > > > writes with MAX_BLOCK of 2000.
> > >
> > > I'm a bit surprised that write() is what is regressing.  Unless I
> > > screwed up, we do all the expensive accounting at open()/close() time.
> > > Is this a test that gets run in parallel on multiple cpus?
> >
> > Don't forget touch_atime...
>
> Yeah, that's a good point.  Are we sure that's what is happening here,
> though?  That's one thing a profile would hopefully help with.
>
> > Still, open/close isn't unimportant either.
>
> Yeah, that's true.  But, what I noticed was that all of the other
> open/close activity masked out any overhead from mnt_want/drop_write()
> since a big chunk of the overhead was just going and bringing the
> vfsmount pieces into the cache.

That's very true.


> > > Could you take a look at Nick's patches to speed this stuff up?
> > >
> > > 	http://thread.gmane.org/gmane.linux.file-systems/28186
> > >
> > > We may need to dust those off, although I'm still a bit worried about
> > > the complexities of open-coding all the barriers.
> >
> > I really need to do something about trying to push them upstream again
> > actually because we've got them in SLES11 tree.
>
> Were the patches that you integrated any different from the ones you
> posted a few months ago?

Don't think they were significantly changed. I'll take another look
and repost them.

