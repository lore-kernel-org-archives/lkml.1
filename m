Return-Path: <linux-kernel-owner+w=401wt.eu-S1754125AbZKCQvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125AbZKCQvI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 11:51:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752898AbZKCQvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 11:51:08 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58967 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750879AbZKCQvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 11:51:06 -0500
Date: Tue, 3 Nov 2009 08:50:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "NeilBrown" <neilb@suse.de>
Cc: "device-mapper development" <dm-devel@redhat.com>,
       linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org,
       "Laurent CORBES" <laurent.corbes@smartjog.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] Re: Ext3 sequential read performance drop 2.6.29 ->
  2.6.30,2.6.31,...
Message-Id: <20091103085030.6c2f3304.akpm@linux-foundation.org>
In-Reply-To: <d6aea4636eac5a7c065f8c1a83c0dbe2.squirrel@neil.brown.name>
References: <20091013120955.6bd5844b@smartjog.com>
	<20091102135554.b10ece3e.akpm@linux-foundation.org>
	<20091103100645.GA13118@infradead.org>
	<d6aea4636eac5a7c065f8c1a83c0dbe2.squirrel@neil.brown.name>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Nov 2009 21:42:30 +1100 "NeilBrown" <neilb@suse.de> wrote:

> On Tue, November 3, 2009 9:06 pm, Christoph Hellwig wrote:
> > On Mon, Nov 02, 2009 at 01:55:54PM -0800, Andrew Morton wrote:
> >> On Tue, 13 Oct 2009 12:09:55 +0200
> >> Laurent CORBES <laurent.corbes@smartjog.com> wrote:
> >>
> >> > Hi all,
> >> >
> >> > While benchmarking some systems I discover a big sequential read
> >> performance
> >> > drop using ext3 on ~ big files. The drop seems to be introduced in
> >> 2.6.30. I'm
> >> > testing with 2.6.28.6 -> 2.6.29.6 -> 2.6.30.4 -> 2.6.31.3.
> >>
> >> Seems that large performance regressions aren't of interest to this
> >> list :(
> >
> > No sure which list you mean, but dm-devel is for dm, not md.

bah.

>  We're also
> > seeing similarly massive performance drops with md and ext3/xfs as
> > already reported on the list.  Someone tracked it down to writeback
> > changes as usual, but there it got stuck.
> 
> I'm still looking - running some basic tests on 4 filesystems over
> half a dozen recent kernels to see what has been happening.
> 
> I have a suspicion that there a multiple problems.
> In particular, XFS has a strange degradation which was papered over
> by commit c8a4051c3731b.
> I'm beginning to wonder if it was caused by commit 17bc6c30cf6bf
> but I haven't actually tested that yet.

I think Laurent's workload involves only reads, with no writes.
