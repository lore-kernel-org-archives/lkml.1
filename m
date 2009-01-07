Return-Path: <linux-kernel-owner+w=401wt.eu-S1759934AbZAGCWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759934AbZAGCWU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 21:22:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757394AbZAGCWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 21:22:04 -0500
Received: from smtp114.mail.mud.yahoo.com ([209.191.84.67]:28099 "HELO
	smtp114.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752804AbZAGCWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 21:22:03 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=TzLkhOqXTtmEKE1CwizSZJTpJHvjBHSTOl4Ly4XuH1RX9m5+7IGIN9LRJpnQgFYPovkmhD6fkQLYrLbFcyHWMZ0dld5RR7v2wCV26KpO72qbVjapwWOuHqtSOj67kBJ3WHCQbbJKPi9XsRUoD7Al89C+XhOUSRjS/zeCbIBwXUw=  ;
X-YMail-OSG: vpoudOoVM1m8n9830Aj5G7kyci_GBE6Kx2MVFO99PP7xYECdvcveRA7l0s6mnsBIKg5a4Rj91.RI9PJQSXT47tVPWXayM9OACjbQ8xG7AJaUkJHHEqJCEGs0tjmiBRhlRq0WUf5VfTCCB_LFDpeSpbdRyuugZyDJWHSlZKbBBG_zfIkp85.lmmmO6gm4vXrrNm9Kk2zFm6UoKih6U1JBvTQzO8xfSdlYE40-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org
Subject: Re: 2.6.29 -mm merge plans
Date: Wed, 7 Jan 2009 13:21:42 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
References: <20090105004300.19ed52d1.akpm@linux-foundation.org> <20090106225744.GA10553@infradead.org> <20090106152829.43dab4a0.akpm@linux-foundation.org>
In-Reply-To: <20090106152829.43dab4a0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901071321.43068.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 January 2009 10:28:29 Andrew Morton wrote:
> Christoph Hellwig <hch@infradead.org> wrote:

> > BTW, the current influx of higher-complexity filesystems certainly
> > worries me a little.
>
> Well yes.  Each new filesystem (complex or not) is an additional
> boatanchor on development of core kernel: block, vfs, MM, etc.  So each
> filesystem should be justified on the basis that it adds sufficient
> benefit to justify that cost.  (And I got mau-muaed for pointing this
> out in the omfs context, I might add).

I've found that if the filesystems have active maintainers who are willing
to help eg. if some MM APIs need to change, then it isn't such a big problem.

It simply doesn't scale and will not work if an MM developer is expected to
go through and try to understand *every* filesystem, attempt to change them,
and test them even though it's non-trivial to even set up and mount a lot
of these things to test them.

Each individual filesystem development community already knows their fs code,
has test environments set up (or presumably can at least mount the thing),
and only need to understand one little changed aspect of the MM, with the
help from the MM developer.

Latter system is efficient and scales, former does not.

If a filesystem is merged it has to have a pretty good promise that it will
be well maintained. (obviously it still has to justify a cost, but that cost
becomes sane)


> Will nilfs bring enough value to justify it's cost?  Hard call.  What
> do you think?
>
> (otoh, we could probably randomly delete ten old filesystems and
> practically nobody would notice)

I don't know how stable fuse APIs are (ie. whether we'd just be handing the
anchors to FUSE), but if it is very stable, then it would be nice to push a
lot of them out of the kernel (although OTOH the old ones tend not to have
complex interactions with mm or block layer).

