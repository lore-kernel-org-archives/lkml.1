Return-Path: <linux-kernel-owner+w=401wt.eu-S1761044AbYHFFiH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761044AbYHFFiH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 01:38:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbYHFFgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 01:36:42 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:22198 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751351AbYHFFgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 01:36:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=PXapd+2347CdULkhNJJWd11/lPSgOnP7niCEAv2xr7No3X4Y5cOCv6Ir8URbrmFmBz+yWUsLts+6zyS8djHG9Qt30QmoAamNagvOd1x3lXs6d67nAnavEvJSZlWDGXXFfbyB2fZJqFJby7wlolEyr2/u3MAGMWpIipm2+Ex6JO8=  ;
X-YMail-OSG: SbzOOqcVM1kzQOVuYAOXPvZ75TMv2Eef74r1meAIhu5X0H9ui7AmrLgWB3vBTEAIDWQwEXB1n1TxzGzJ7inrLEwWeFakoEHZBpe5A1O9r_kO7StG6CWBK8tVxaZTEcvK49g5SlRzSnkTtz4y_ByxZ.8A
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 12/17] vfs: pagecache usage optimization for pagesize!=blocksize
Date: Wed, 6 Aug 2008 15:36:31 +1000
User-Agent: KMail/1.9.5
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       hifumi.hisashi@oss.ntt.co.jp, jack@ucw.cz, linux-ext4@vger.kernel.org
References: <200807282246.m6SMkaHT032267@imap1.linux-foundation.org> <20080728230031.GA22218@infradead.org> <200808041719.43293.nickpiggin@yahoo.com.au>
In-Reply-To: <200808041719.43293.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808061536.32275.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any updates with this, please?

On Monday 04 August 2008 17:19, Nick Piggin wrote:
> On Tuesday 29 July 2008 09:00, Christoph Hellwig wrote:
> > On Mon, Jul 28, 2008 at 03:46:36PM -0700, akpm@linux-foundation.org wrote:
> > > From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
> > >
> > > When we read some part of a file through pagecache, if there is a
> > > pagecache of corresponding index but this page is not uptodate, read IO
> > > is issued and this page will be uptodate.
> >
> > I was under the impression we wanted to do this in a nicer way than
> > the hacky method?
>
> This patch unfortunately appears like it may introduce an
> uninitialized memory leak due to a data race between one
> thread initializing a buffer then marking it uptodate, and
> the other testing buffer uptodate then reading from the
> buffer (buffer, read as: page memory covered by buffer head).
>
> For reference, this is basically the same class of data race
> that I fixed 0ed361dec36945f3116ee1338638ada9a8920905
>
> I should have picked up on this before it was merged, but I
> was kind of rushed to review other things before they got
> merged.
>
> I don't think this patch got quite enough justification to
> warrant just blindly putting barriers in the buffer bitops.
> The best-case numbers for it were reasonable enough when the
> downside was only an extra branch or two in a relatively slow
> path. I don't really know how best to go from here (maybe
> someone can argue it is not a problem or come up with a better
> fix?).
>
> Thanks,
> Nick
