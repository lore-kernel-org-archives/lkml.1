Return-Path: <linux-kernel-owner+w=401wt.eu-S1763307AbXEWQt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763307AbXEWQt4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 12:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756613AbXEWQts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 12:49:48 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:33496 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756494AbXEWQts (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 12:49:48 -0400
Subject: Re: [RFC] LZO de/compression support - take 3
From: Richard Purdie <richard@openedhand.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nitin Gupta <nitingupta910@gmail.com>,
       Michael-Luke Jones <mlj28@cam.ac.uk>, linux-kernel@vger.kernel.org,
       linux-mm-cc@laptop.org
In-Reply-To: <20070523091601.f8c6b833.akpm@linux-foundation.org>
References: <4cefeab80705230127r58e8f9e1sa644092e95eb81eb@mail.gmail.com>
	 <0F6CEFD7-86F2-4903-B4F7-F723DF88BE9A@cam.ac.uk>
	 <4cefeab80705230439n6bbb1259le3c3b9704ce49b75@mail.gmail.com>
	 <624FD7A7-5552-415F-96D8-4353453EA2A3@cam.ac.uk>
	 <4cefeab80705230703vdb3c414s250a61c4c2d70c51@mail.gmail.com>
	 <1CF43BBC-79EF-449B-A398-AE374E399573@cam.ac.uk>
	 <4cefeab80705230721i492b5f1ehfa2d775344b1c04e@mail.gmail.com>
	 <20070523091601.f8c6b833.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 23 May 2007 17:49:20 +0100
Message-Id: <1179938960.5864.26.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-23 at 09:16 -0700, Andrew Morton wrote:
> On Wed, 23 May 2007 19:51:44 +0530 "Nitin Gupta" <nitingupta910@gmail.com> wrote:
> > On 5/23/07, Michael-Luke Jones <mlj28@cam.ac.uk> wrote:
> > If I rename 'nonsafe' version as such then it will seem like its a
> > 'broken' implementation which is not the case. If somebody is upto
> > including compression he must be having head to use the right
> > decompress version depending on this scenario :-)
> > 
> 
> <wakes up>
> 
> What's "unsafe" here?  If you fed it bad data, the decompressor will
> scribble on memory or crash the kernel or hang up?

It can scribble on memory it shouldn't.

> If so, it was quite inappropriate that a filesystem be using the unsafe
> version.

Yes, I'll give you a patch to change the resier4 code in -mm then (if
its not already been changed).

> I'd agree with the proposed renaming.  In fact I'd suggest that the unsafe
> APIs just be removed - it's hard to imagine a situation in which they're OK
> to be used in the kernel.

The compressed cache code might be one exception since it does the
compression itself and shouldn't get corrupted. If it does get
corrupted, you have bigger problems.

I'll provide a patch to update the LZO code in -mm to add unsafe to the
name.

Cheers,

Richard


