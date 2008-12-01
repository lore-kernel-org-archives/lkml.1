Return-Path: <linux-kernel-owner+w=401wt.eu-S1752919AbYLAIzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919AbYLAIzh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 03:55:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750930AbYLAIz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 03:55:29 -0500
Received: from wf-out-1314.google.com ([209.85.200.175]:55244 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbYLAIz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 03:55:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=cYCVIxrTsYzNcFZs6MyjG6C2/ZagxXsh0VKhAcQvxu38/xlHP2MemLCp6Dq/GOXwat
         yscbmRsy3rVI3JjPgrPDoph3pSigmE9wbY+bA0nvZlRFhtma3CfyeFvXK5Y+n+ceHyAL
         bKekrWoU5ZFDa2o5ovhsa+EYO+4HDZmOkQPvM=
Subject: Re: [PATCH-mm 1/8] ntfs: remove private wrapper around endian
 helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Anton Altaparmakov <aia21@cam.ac.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <72F61C56-4613-4369-9319-09A0A8C90F7C@cam.ac.uk>
References: <1227733970.5511.123.camel@brick>
	 <B9FA83C0-9993-44BB-86AA-FA8B97A2D6A2@cam.ac.uk>
	 <1227814545.5511.143.camel@brick>
	 <72F61C56-4613-4369-9319-09A0A8C90F7C@cam.ac.uk>
Content-Type: text/plain
Date: Mon, 01 Dec 2008 00:55:26 -0800
Message-Id: <1228121726.5482.5.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-12-01 at 08:50 +0000, Anton Altaparmakov wrote:
> Hi,
> 
> On 27 Nov 2008, at 19:35, Harvey Harrison wrote:
> > On Thu, 2008-11-27 at 08:22 +0000, Anton Altaparmakov wrote:
> >> On 26 Nov 2008, at 21:12, Harvey Harrison wrote:
> >>> The base versions handle constant folding just fine.
> >>> Done with sed other than the mft.c and inode.c one-liners.
> >>
> >> Have you checked the compiler output?  And on all architectures?  And
> >> on all gcc versions?
> >
> > Yes I've checked the compiler output for the new byteorder helpers
> > for gcc 3.4, 4, 4.2 on x86.
> >
> > Notice this depends on the byteorder bits in -mm.  The failure of
> > the old bits to properly compile-time swap I've only seen at -O0,
> > which the new bits do properly.  If you can cite a particular
> > version/arch that you know of where the bug arose, please let me
> > know.
> 
> Ah, I failed to notice this required some new byteorder code!  Sorry.

No worries, if you do happen to recall what compilers or arches you've
seen the constant folding fail to happen, I'd still like to know just
what landmines are out there ;-)  If it was an -O0 build I'm comfortable
the new version won't suffer from the same problem, otherwise I'm all
ears.

> >> Also you are breaking sparse checking with this patch as you remove
> >> some of the necessary endianness conversions (e.g. your one liner in
> >> mft.c which causes us to apply a binary 'not' operator on a little
> >> endian which sparse complains about - in fact that is the reason the
> >> endianness conversions are in there in the first place - I added them
> >> because sparse was complaining about them).
> >
> > No, sparse does not complain about it.  Bitwise operations are just
> > fine on types such as le16 etc.  Try running sparse again with
> > my changes, there are no new warnings.
> 
> Interesting.  Sparse must have grown up then.  It used to complain  
> (although I always thought it was complaining incorrectly given that  
> binary bit operations are endianness agnostic).
> 

I imagine that must be the case, but I run sparse fairly regularly, so
I'd have noticed ;-)


Cheers,

Harvey

