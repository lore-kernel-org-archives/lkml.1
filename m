Return-Path: <linux-kernel-owner+w=401wt.eu-S1764534AbXEWQQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764534AbXEWQQu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 12:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757071AbXEWQQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 12:16:43 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:33150 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756921AbXEWQQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 12:16:42 -0400
Date: Wed, 23 May 2007 09:16:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Nitin Gupta" <nitingupta910@gmail.com>
Cc: "Michael-Luke Jones" <mlj28@cam.ac.uk>, linux-kernel@vger.kernel.org,
       "Richard Purdie" <richard@openedhand.com>, linux-mm-cc@laptop.org
Subject: Re: [RFC] LZO de/compression support - take 3
Message-Id: <20070523091601.f8c6b833.akpm@linux-foundation.org>
In-Reply-To: <4cefeab80705230721i492b5f1ehfa2d775344b1c04e@mail.gmail.com>
References: <4cefeab80705230127r58e8f9e1sa644092e95eb81eb@mail.gmail.com>
	<0F6CEFD7-86F2-4903-B4F7-F723DF88BE9A@cam.ac.uk>
	<4cefeab80705230439n6bbb1259le3c3b9704ce49b75@mail.gmail.com>
	<624FD7A7-5552-415F-96D8-4353453EA2A3@cam.ac.uk>
	<4cefeab80705230703vdb3c414s250a61c4c2d70c51@mail.gmail.com>
	<1CF43BBC-79EF-449B-A398-AE374E399573@cam.ac.uk>
	<4cefeab80705230721i492b5f1ehfa2d775344b1c04e@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2007 19:51:44 +0530 "Nitin Gupta" <nitingupta910@gmail.com> wrote:

> On 5/23/07, Michael-Luke Jones <mlj28@cam.ac.uk> wrote:
> > On 23 May 2007, at 15:03, Nitin Gupta wrote:
> >
> > >> Perhaps a rename is in order:
> > >> lzo1x_decompress() => lzo1x_decompress_unsafe()
> > >> lzo1x_decompress_safe => lzo1x_decompress()
> > >
> > > Or perhaps make reiserfs use _safe() instead - I think Richard has
> > > already submitted patch for same.
> >
> > If someone's already made this mistake once, then it'll happen again.
> > In-kernel memory corruption is no fun.
> >
> > Safe/Secure == Default
> 
> If I rename 'nonsafe' version as such then it will seem like its a
> 'broken' implementation which is not the case. If somebody is upto
> including compression he must be having head to use the right
> decompress version depending on this scenario :-)
> 

<wakes up>

What's "unsafe" here?  If you fed it bad data, the decompressor will
scribble on memory or crash the kernel or hang up?

If so, it was quite inappropriate that a filesystem be using the unsafe
version.

I'd agree with the proposed renaming.  In fact I'd suggest that the unsafe
APIs just be removed - it's hard to imagine a situation in which they're OK
to be used in the kernel.

