Return-Path: <linux-kernel-owner+w=401wt.eu-S1758801AbYFXMWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758801AbYFXMWL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 08:22:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbYFXMV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 08:21:57 -0400
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:34466 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751647AbYFXMV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 08:21:56 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=t2Ceciyg+R38DBChrSEE16mHIhHItuOeqTZMtYx4RrpsablQUFxrmNr8Ql4mF7I9Grf+z6fsUFuMiFggliL7I8fgN8dZ/L2N2qHYUwzia4rzIuVmmHf1o+9r4H0HOoJGpRwNRvZZUFmN18fqFRU2CQxHirMtLtvJPiPxjsdLg1s=  ;
X-YMail-OSG: sHSdpFMVM1lh6O11B9X1e2okuKkXGo5mxDYZx_IsSyQ_n4BPjNTwskTNSYiqWR5OptzIl6ge2TZ0zxVXJjK_g8X1lLJoIVLGu5ExLDKdkCMqlUQQuxDz703eDetygLqaP6Q-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [rfc patch 2/4] splice: remove steal from pipe_buf_operations
Date: Tue, 24 Jun 2008 22:21:34 +1000
User-Agent: KMail/1.9.5
Cc: jens.axboe@oracle.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       torvalds@linux-foundation.org, npiggin@suse.de
References: <20080621154607.154640724@szeredi.hu> <20080624080152.GI20851@kernel.dk> <E1KB4EV-0000u3-5j@pomaz-ex.szeredi.hu>
In-Reply-To: <E1KB4EV-0000u3-5j@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806242221.35304.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 June 2008 18:50, Miklos Szeredi wrote:
> > On Sat, Jun 21 2008, Miklos Szeredi wrote:
> > > From: Miklos Szeredi <mszeredi@suse.cz>
> > >
> > > The 'steal' operation hasn't been used for some time.  Remove it and
> > > the associated dead code.  If it's needed in the future, it can always
> > > be easily restored.
> >
> > I'd rather not just remove this, it's basically waiting for Nick to make
> > good on his promise to make stealing work again (he disabled it).
>
> Yes, I read the commit log.  He disabled it with the intent that we
> may or may not want this interface back, and possibly in some other
> form.
>
> Jens, does somebody need this feature?  What for?  If not, then I
> guess nobody will bother implementing it.
>
> (Nick CC-d)

I've kind of wanted to implement it "because it is cool", but also
because I hoped to ensure the new write_begin/write_end APIs would
be general enough to support it.

Unfortunately I'm not aware of a killer feature so it's kept going
down the todo pile. However it really is one of those things where
you need the API to work before you get programs emerging that make
interesting uses out of it. I think if it can be done without adding
complication to pagecache/filesystem code, then it would be nice.
