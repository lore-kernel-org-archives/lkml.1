Return-Path: <linux-kernel-owner+w=401wt.eu-S1756769AbXLSXe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769AbXLSXe5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 18:34:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753580AbXLSXet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 18:34:49 -0500
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:34513 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752319AbXLSXes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 18:34:48 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=pobFPFw3QGXAaTLAHVEMrY03QpPr1snVzElhmeIvyf4tiy6oCMRHljGtP+dhObYk8WP0vAT4HwVp+rQcjrAETHTdklZISIsg7nYvJKF3nCyWMHs0I1W4AbKbUTsRf2Gs7Ovv2wcpF7isMenkJmFRSe1cvlGJSInVLighm0Bq6u8=  ;
X-YMail-OSG: 7VXKBhkVM1lX6WPryCZ9Kn.RtI7EJFRtktDC7BY9gch1nNer
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Rik van Riel <riel@redhat.com>
Subject: Re: [patch 17/20] non-reclaimable mlocked pages
Date: Thu, 20 Dec 2007 10:34:22 +1100
User-Agent: KMail/1.9.5
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Lee Schermerhorn <lee.schermerhorn@hp.com>
References: <20071218211539.250334036@redhat.com> <200712191156.48507.nickpiggin@yahoo.com.au> <20071219084534.4fee8718@bree.surriel.com>
In-Reply-To: <20071219084534.4fee8718@bree.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712201034.22668.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 December 2007 00:45, Rik van Riel wrote:
> On Wed, 19 Dec 2007 11:56:48 +1100
>
> Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > On Wednesday 19 December 2007 08:15, Rik van Riel wrote:
> > > Rework of a patch by Nick Piggin -- part 1 of 2.
> > >
> > > This patch:
> > >
> > > 1) defines the [CONFIG_]NORECLAIM_MLOCK sub-option and the
> > >    stub version of the mlock/noreclaim APIs when it's
> > >    not configured.  Depends on [CONFIG_]NORECLAIM.
> >
> > Hmm, I still don't know (or forgot) why you don't just use the
> > old scheme of having an mlock count in the LRU bit, and removing
> > the mlocked page from the LRU completely.
>
> How do we detect those pages reliably in the lumpy reclaim code?

They will have PG_mlocked set.


> > These mlocked pages don't need to be on a non-reclaimable list,
> > because we can find them again via the ptes when they become
> > unlocked, and there is no point background scanning them, because
> > they're always going to be locked while they're mlocked.
>
> Agreed.
>
> The main reason I sent out these patches now is that I just
> wanted to get some comments from other upstream developers.
>
> I have gotten distracted by other work so much that I spent
> most of my time forward porting the patch set, and not enough
> time working with the rest of the upstream community to get
> the code moving forward.
>
> To be honest, I have only briefly looked at the non-reclaimable
> code.  I would be more than happy to merge any improvements to
> that code.

I haven't had too much time to look at it either, although it does
seem like a reasonable idea.

However the mlock code could be completely separate from the slow
scan pages (and not be on those LRUs at all).
