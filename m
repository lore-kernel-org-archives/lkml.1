Return-Path: <linux-kernel-owner+w=401wt.eu-S1760118AbXIKV6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760118AbXIKV6x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 17:58:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755912AbXIKV6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 17:58:43 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:34521 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751905AbXIKV6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 17:58:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=6k6LY8WpYNFh92MJ+mZpazbr/6zKsNMK2qvELxazPfRmLwFS75Uns2BqEaGlnhDtjQ36zajg2JMHPnf5/o4ysU0iGpwzr+0CmgeHodXF7v0NP8JPFHvGjRYgNOChdrm6py67mv0gNBlJApzL8bSGOfQDV0okJ9JPB2u049ieHdQ=  ;
X-YMail-OSG: aIoNiVwVM1mJhLUNT0k0uVxbb_3jsX5QvjfWw8i_j8tmp79BWUxYsutUDhnwww_y_l7gNDZNng--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Date: Tue, 11 Sep 2007 16:17:02 +1000
User-Agent: KMail/1.9.5
Cc: Mel Gorman <mel@skynet.ie>, andrea@suse.de, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
References: <20070911060349.993975297@sgi.com> <200709111600.18756.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0709111446080.27023@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0709111446080.27023@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709111617.03586.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 September 2007 07:48, Christoph Lameter wrote:
> On Tue, 11 Sep 2007, Nick Piggin wrote:
> > But that's not my place to say, and I'm actually not arguing that high
> > order pagecache does not have uses (especially as a practical,
> > shorter-term solution which is unintrusive to filesystems).
> >
> > So no, I don't think I'm really going against the basics of what we
> > agreed in Cambridge. But it sounds like it's still being billed as
> > first-order support right off the bat here.
>
> Well its seems that we have different interpretations of what was agreed
> on. My understanding was that the large blocksize patchset was okay
> provided that I supply an acceptable mmap implementation and put a
> warning in.

Yes. I think we differ on our interpretations of "okay". In my interpretation,
it is not OK to use this patch as a way to solve VM or FS or IO scalability
issues, especially not while the alternative approaches that do _not_ have
these problems have not been adequately compared or argued against.


> > But even so, you can just hold an open fd in order to pin the dentry you
> > want. My attack would go like this: get the page size and allocation
> > group size for the machine, then get the number of dentries required to
> > fill a slab. Then read in that many dentries and pin one of them. Repeat
> > the process. Even if there is other activity on the system, it seems
> > possible that such a thing will cause some headaches after not too long a
> > time. Some sources of pinned memory are going to be better than others
> > for this of course, so yeah maybe pagetables will be a bit easier (I
> > don't know).
>
> Well even without slab targeted reclaim: Mel's antifrag will sort the
> dentries into separate blocks of memory and so isolate the issue.

So even after all this time you do not understand what the fundamental
problem is with anti-frag and yet you are happy to waste both our time
in endless flamewars telling me how wrong I am about it.

Forgive me if I'm starting to be rude, Christoph. This is really irritating.
