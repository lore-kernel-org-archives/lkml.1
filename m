Return-Path: <linux-kernel-owner+w=401wt.eu-S1762661AbYDNQhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762661AbYDNQhN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 12:37:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759001AbYDNQg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 12:36:59 -0400
Received: from rn-out-0910.google.com ([64.233.170.186]:27392 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909AbYDNQg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 12:36:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=H4M25k2TQQt+vHcKBQBUqCTufvs1Fj5pOdDzIFcBRZi7qNRrZkT6uoWoXF/Y+PdcllNHQm+LMbjkP1YZYyjHn+6bOSz6PJ7Iqm4q2a4j4Tce3ML/UfFEwVm3u58HCSfVE3oo4ftAnZMCrixxHst5gM+t9js715dWKrBjVxie0vQ=
Message-ID: <b6c5339f0804140936s3dcce48en59a270dc86bf7dc8@mail.gmail.com>
Date: Mon, 14 Apr 2008 12:36:54 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Chris Mason" <chris.mason@oracle.com>
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
Cc: "Christoph Hellwig" <hch@infradead.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "David Woodhouse" <dwmw2@infradead.org>,
       "Miklos Szeredi" <miklos@szeredi.hu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <200804141020.37271.chris.mason@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080412205544.5e12a7d4.akpm@linux-foundation.org>
	 <20080414091639.4bd3879d@core> <20080414084141.GA29113@infradead.org>
	 <200804141020.37271.chris.mason@oracle.com>
X-Google-Sender-Auth: 236ecefe30b0316e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 10:20 AM, Chris Mason <chris.mason@oracle.com> wrote:
>  Thanks to Bob Copeland for taking the time to submit this for mainline.
>  Please don't mistake the resulting debate as a sign we don't appreciate the
>  effort of making it available and getting it reviewed.

Sure, no worries...

>  Unlike all the device drivers we don't want floating around out of the tree,
>  filesystem authors do have a choice between FUSE and being in-kernel.  Since
>  OMFS has been maintained out of tree since 2.6.12 or so, Bob probably has a
>  very good idea of how much time he has needed to spend updating things for
>  each release.

The recent deprecation of iget was probably the most involved of any.  It
wasn't that bad, but the #ifdef jungle going back to at least .17 is getting
somewhat hairy (I have 19 of them).  I would say over the past year or so
most of the changes have been <10 liners with kmem_cache_* interface changes.
Luckily through review here, that got zapped anyway.

In the normal case, I'll grab an -rc3 kernel or so, try to compile it, if
it fails, look at minix to see the minimum set of changes I need to make.
The challenge for me maintaining it out-of-tree is that sometimes the git
logs do not carry enough context to know why XYZ changed and if there's a
better, new way to do things.  Then it's time to scour the mailing lists.

>  So, there are two big questions I'd ask:
>
>  * Which setup (kernel or fuse) would Bob find easier to maintain things?
>  * Is this a first step toward more development and an increased user base?

Well, FUSE is easier from the standpoint of having somewhat more control.
On the other hand, that also results in an inferior product if it isn't given
the many-eyes treatment.  For the code itself, it's really not that much
different since FUSE is so close to the VFS API anyway.

For your second question:

More users are always welcome.  At present, the FUSE version implements a few
things that the kernel module does not - better/different block allocation
algorithm, growing truncate, automatic byte-swapping for the ReplayTV model
that had a busted block layer.  However, the FUSE version is known to be buggy
with respect to every day use (I had one MD5 fail among 20G of files in one
copy test).

I could see adding 1 and 2 to the kernel version, but probably not the
byte-swapping bit.  I'm not sure what to do from there on.

As a user, I use the kernel module because it works, it's faster, and the
other bells and whistles aren't that important to me.  It's hard to tell
what the user community prefers, because the kernel module was first and
so far no one has had a reason to try the FUSE implementation (if they
have, I don't know about it).

-- 
Bob Copeland %% www.bobcopeland.com
