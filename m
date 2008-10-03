Return-Path: <linux-kernel-owner+w=401wt.eu-S1754857AbYJCC7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857AbYJCC7e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 22:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754125AbYJCC70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 22:59:26 -0400
Received: from smtp112.mail.mud.yahoo.com ([209.191.84.65]:20773 "HELO
	smtp112.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754086AbYJCC7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 22:59:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=erytyjBEq655zk4nJaVfbINPpkrSEKN8b835yk+hlC54NppXztknNLzw+CIYs7ujJjPgVc/EMC9uu9v8W0TXHtTDInvW+qbOGYE5y9x62BWtf/PABhaKNJ2eS+bCQ6VlXwB42aV7kC5H5yrahv7AzNkSkApMivImf+MciHVwhws=  ;
X-YMail-OSG: _Bes5CQVM1mmo47mZdMX.pfa2vBdLmltCfS5tDZmApWEAurAmZ.ZVlpUdsubwKsyL24LY5WJwtJJk2urL1dTW67asPXrYVibniTYt8ENIdy031e6S2u_7.SZaJFDhWrlzgOqg143JOu8ctN4bAjPhqCe7.2L5QzpJi3w7pQp6d2xi2E0has-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Memory management livelock
Date: Fri, 3 Oct 2008 12:59:17 +1000
User-Agent: KMail/1.9.5
Cc: Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org, agk@redhat.com, mbroz@redhat.com,
       chris@arachsys.com
References: <20080911101616.GA24064@agk.fab.redhat.com> <200810031232.23836.nickpiggin@yahoo.com.au> <20081002194034.7957bccb.akpm@linux-foundation.org>
In-Reply-To: <20081002194034.7957bccb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810031259.17527.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 October 2008 12:40, Andrew Morton wrote:
> On Fri, 3 Oct 2008 12:32:23 +1000 Nick Piggin <nickpiggin@yahoo.com.au> 
wrote:
> > > yup, that's pretty much unfixable, really, unless new locks are added
> > > which block threads which are writing to unrelated sections of the
> > > file, and that could hurt some workloads quite a lot, I expect.
> >
> > Why is it unfixable? Just ignore nr_to_write, and write out everything
> > properly, I would have thought.
>
> That can cause fsync to wait arbitrarily long if some other process is
> writing the file.

It can be fixed without touching non-fsync paths (see my next email for
the way to fix it without touching fastpaths).


> This happens. 

What does such a thing? It would have been nicer to ask them to not do
that then, or get them to use range syncs or something. Now that's much
harder because we've accepted the crappy workaround for so long.

It's far far worse to just ignore data integrity of fsync because of the
problem. Should at least have returned an error from fsync in that case,
or make it interruptible or something.
