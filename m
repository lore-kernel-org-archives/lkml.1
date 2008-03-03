Return-Path: <linux-kernel-owner+w=401wt.eu-S1759773AbYCCTZH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759773AbYCCTZH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 14:25:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755707AbYCCTYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 14:24:55 -0500
Received: from n29.bullet.mail.mud.yahoo.com ([68.142.200.152]:26628 "HELO
	n29.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755590AbYCCTYz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 14:24:55 -0500
X-Yahoo-Newman-Id: 383688.18930.bm@omp401.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=QMahkevlYryT9HNtVkTPTvRLjTFMb6GFd2yYs3einFQdBcA9G7klB08H+mm6WNYdOyJdHptK8QB2shZDu+PZcp5rdxOK2PWFJkTpgxetqAQVVd53RmqZ6y2V1I2Hp2KaMlJ4ZicuSEJ9AweHVu/78AIHTwiHGWd6Cx/8dhBwFLg=  ;
X-YMail-OSG: nRJVTUEVM1kKUmdnSOYrotdreCmNa5M5vJDbdmjI_InsXESjAMTKw.Dz1dv7gXOmNcO4PKHxnih8xtrFdgwnMlu4xHf2Gc9VER4IW0HLGfOc7.Wh1Wc-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Cyrus Massoumi <cyrusm@gmx.net>
Subject: Re: Performance versus FreeBSD 7.0
Date: Tue, 4 Mar 2008 06:24:23 +1100
User-Agent: KMail/1.9.5
Cc: Diego Calleja <diegocg@gmail.com>, Stephen Cuppett <cuppett@gmail.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, a.p.zijlstra@chello.nl
References: <316a20a40802290538g55c4171y7cdbcb3a9c1d0f1b@mail.gmail.com> <200803040004.52299.nickpiggin@yahoo.com.au> <47CC4B3F.8060405@gmx.net>
In-Reply-To: <47CC4B3F.8060405@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803040624.24119.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 March 2008 06:02, Cyrus Massoumi wrote:
> Nick Piggin wrote:
> > On Saturday 01 March 2008 01:54, Diego Calleja wrote:
> >> El Fri, 29 Feb 2008 08:38:00 -0500, "Stephen Cuppett"
> >> <cuppett@gmail.com>
> >
> > escribió:
> >>> loads and 1500% at high loads. When compared with the best performing
> >>> Linux kernel (2.6.22 or 2.6.24) performance is 15% better. Results are
> >>
> >> There has been some performance problems with sysbench performance in
> >> linux which made it slower than freebsd, there were some patches to
> >> speed things up, not sure if they have been merged.
> >
> > There definitely were performance problems with threaded malloc/free
> > in the Linux kernel and glibc. Fixes have been merged in both packages,
> > and AFAIK the FreeBSD guys tested with those fixes in place.
> >
> > I think these were never really run into before in part due to MySQL's
> > unscalable heap design makes it not scale well on higher numbers of
> > CPUs anyway, and also made the malloc problems more pronounced (ie.
> > they added a bit to the contention of the single heap lock, which is
> > the big killer here).
>
> IIRC, going to fine-grained file locking gave them a huge boost in this
> particular benchmark (and maybe others).
> As I said on lwn.net Peter Zijlstra posted a patch to break the global
> file list lock about a year ago [1], but I don't think it was ever
> merged. Here [2] are some numbers for the patchset.
>
> [1] http://lkml.org/lkml/2007/1/28/29
> [2] http://lkml.org/lkml/2007/1/28/116

The mysql workload is not constrained by this lock. The important
part (where freebsd saw their gain) is probably fd lookups, which
are lockless in Linux for a long time.

