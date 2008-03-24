Return-Path: <linux-kernel-owner+w=401wt.eu-S1753597AbYCXFQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597AbYCXFQS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 01:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbYCXFQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 01:16:07 -0400
Received: from qmta06.westchester.pa.mail.comcast.net ([76.96.62.56]:48215
	"EHLO QMTA06.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751964AbYCXFQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 01:16:06 -0400
X-Authority-Analysis: v=1.0 c=1 a=bF9fCXb2cRsA:10 a=rYCjJyBKhAE3ljmMp6MA:9
 a=UuyJ2vQ3Fk8Dkos1vh5rGZR3rXIA:4 a=l29vjEC0CZ8A:10 a=si9q_4b84H0A:10
 a=WuK_CZDBSqoA:10
Subject: Re: [PATCH prototype] [0/8] Predictive bitmaps for ELF executables
From: Nicholas Miell <nmiell@comcast.net>
To: Ulrich Drepper <drepper@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <a36005b50803232120j63fb08d8p4a6cfdc8df2a3f21@mail.gmail.com>
References: <20080318104437.966c10ec.akpm@linux-foundation.org>
	 <20080319020440.80379d50.akpm@linux-foundation.org>
	 <a36005b50803191545h33d1a443y57d09176f8324186@mail.gmail.com>
	 <20080320090005.GA25734@one.firstfloor.org>
	 <a36005b50803211015l64005f6emb80dbfc21dcfad9f@mail.gmail.com>
	 <20080321172644.GG2346@one.firstfloor.org>
	 <a36005b50803212136s78dc2e4bx5ac715ebc7a6e48a@mail.gmail.com>
	 <20080322071755.GP2346@one.firstfloor.org>
	 <1206170695.2438.39.camel@entropy>
	 <20080322091001.GA7264@one.firstfloor.org>
	 <a36005b50803232120j63fb08d8p4a6cfdc8df2a3f21@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 23 Mar 2008 22:16:01 -0700
Message-Id: <1206335761.2438.63.camel@entropy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8.0.njm.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-03-23 at 21:20 -0700, Ulrich Drepper wrote:
> On Sat, Mar 22, 2008 at 2:10 AM, Andi Kleen <andi@firstfloor.org> wrote:
> > > Why not stick the bitmap in an xattr?
> >
> >  xattrs are too small for potentially large binaries and a mess to manage
> >  (a lot of tools don't know about them)
> 
> It does not matter a bit whether any other tool know about the xattrs.
>  Binaries will not change after they are created to require changing
> the attributes.  And it is no problem to not back the data up etc.
> One really doesn't want to waste these resources.

Actually, yeah, the tools issue is a bit of a red herring now that you
mention it -- the only thing that's going to create and use these
bitmaps is the kernel, and if bitmap gets lost due to the use of ancient
tools, the kernel will just recreate the bitmap the next time the binary
runs.

> And as far as the size limitation is concerned.  It depends on the
> limit, which I don't know off hand.  But really, really big binaries
> don't have to be treated like this anyway.  They are not started
> frequently enough to justify this.

The limit is filesystem dependent -- I think ext2/3s is something like
4k total for attribute names and values per inode.

That's more than enough space for the largest executable on my system
(emacs at 36788160 bytes) which would have a 1123 byte predictive bitmap
(plus space for the name e.g. "system.predictive_bitmap"). The bitmap
also could be compressed.

-- 
Nicholas Miell <nmiell@comcast.net>

