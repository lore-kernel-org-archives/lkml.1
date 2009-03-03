Return-Path: <linux-kernel-owner+w=401wt.eu-S1755975AbZCCDxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975AbZCCDxf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 22:53:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754013AbZCCDx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 22:53:26 -0500
Received: from smtp111.mail.mud.yahoo.com ([209.191.84.64]:21205 "HELO
	smtp111.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753631AbZCCDxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 22:53:25 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=CagJXu8G2MocxoO8uHD9QD8umNMu7uFMPH2zNxC48M42igK1Z/JBYfyPdz6kW2qAt1ODkjMgZVRBuiGNQh6GnKsVp8ZKJwqimtO4Uyh2wJ7ArvPe1IAawUTetB0D6rQgd9fEoqL74731OuMEKX6rl8/WDRqkcE+nXPK/+K8Nyqo=  ;
X-YMail-OSG: 5lmN84kVM1mZmCZCsfbBirrdAmi7LFmyQ_BHiGjP4TKfHGyI486brjQ5S2gucUoLRiHQ.u0ALV_cK5QZzXGtewpQPYcB9u2fZriMffb00KZLdJSIkuy2pwmD2kmMG.ds3_RCVZVj5XCs3iQG8R4nMyGmEPYSfK3YLp0xt3jPoFJWctS15FLYAzxF5.Opx_Nd72_1370l8tic6MRDNhuBd4w.NuJ7Y23..UQ-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Francis Moreau <francis.moro@gmail.com>
Subject: Re: Question regarding concurrent accesses through block device and fs
Date: Tue, 3 Mar 2009 14:52:42 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <m2hc2yulrw.fsf@gmail.com> <200903021811.43653.nickpiggin@yahoo.com.au> <38b2ab8a0903020530j18921202r32f73382ff5f0aa@mail.gmail.com>
In-Reply-To: <38b2ab8a0903020530j18921202r32f73382ff5f0aa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903031452.43086.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 March 2009 00:30:18 Francis Moreau wrote:
> Nick Piggin <nickpiggin@yahoo.com.au> writes:
> > On Monday 02 March 2009 08:07:30 Francis Moreau wrote:
> >> This is the case where I can't find when the metadata are actually
> >> written back to the disk by the flushers. I looked at
> >> writback_inodes() but I fail to find this out.
> >>
> >> Could you point out the place in the code where this happen ?
> >
> > I guess it picks them up via their block device inodes.
>
> Probably but I don't find the actual place.

It was an educated guess ;) I'm quite sure it does.


> I looked at the place where page are normally written back to disk (ie
> in background_writeout()) but I can see only the writeback of data, not
> metadata...

What are you expecting writeback of metadata to look like? To the
core kernel it looks the same as writeback of data.


> >> This sounds very weird to me but I need to learn how things work
> >> before doing any serious comments.
> >
> > Why would they? They just operate on their metadata, and the buffer
> > cache is basically a transparent writeback cache to them.
>
> Well the fact that metadata are written back to disk at an unknown point
> in the time means that we don't know in which order metadata and data
> are written. So it means that data can be written before or after
> metadata or they can be mixed up.

But the cache layer on top of that ensures it *appears* not to be mixed
up. A problem arises when the system crashes in the middle of this, and
we lose that information and see a mixed up filesystem. Hence journalling
filesystems.


