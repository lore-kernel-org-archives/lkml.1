Return-Path: <linux-kernel-owner+w=401wt.eu-S1760780AbXGJBAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760780AbXGJBAT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 21:00:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760759AbXGJA7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 20:59:49 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40969 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761675AbXGJA7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 20:59:48 -0400
Date: Mon, 9 Jul 2007 17:59:47 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <npiggin@suse.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [RFC] fsblock
In-Reply-To: <20070710005419.GB8779@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0707091756020.2348@schroedinger.engr.sgi.com>
References: <20070624014528.GA17609@wotan.suse.de>
 <Pine.LNX.4.64.0707091002170.15696@schroedinger.engr.sgi.com>
 <20070710005419.GB8779@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007, Nick Piggin wrote:

> > Hmmm.... I did not notice that yet but then I have not done much work 
> > there.
> 
> Notice what?

The bad code for the buffer heads.

> > > - A real "nobh" mode. nobh was created I think mainly to avoid problems
> > >   with buffer_head memory consumption, especially on lowmem machines. It
> > >   is basically a hack (sorry), which requires special code in filesystems,
> > >   and duplication of quite a bit of tricky buffer layer code (and bugs).
> > >   It also doesn't work so well for buffers with non-trivial private data
> > >   (like most journalling ones). fsblock implements this with basically a
> > >   few lines of code, and it shold work in situations like ext3.
> > 
> > Hmmm.... That means simply page struct are not working...
> 
> I don't understand you. jbd needs to attach private data to each bh, and
> that can stay around for longer than the life of the page in the pagecache.

Right. So just using page struct alone wont work for the filesystems.

> There are no changes to the filesystem API for large pages (although I
> am adding a couple of helpers to do page based bitmap ops). And I don't
> want to rely on contiguous memory. Why do you think handling of large
> pages (presumably you mean larger than page sized blocks) is strange?

We already have a way to handle large pages: Compound pages.

> Conglomerating the constituent pages via the pagecache radix-tree seems
> logical to me.

Meaning overhead to handle each page still exists? This scheme cannot 
handle large contiguous blocks as a single entity?

