Return-Path: <linux-kernel-owner+w=401wt.eu-S1756794AbYCVO1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794AbYCVO1F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 10:27:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754669AbYCVO04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 10:26:56 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46504 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679AbYCVO0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 10:26:55 -0400
Date: Sat, 22 Mar 2008 15:29:49 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Nicholas Miell <nmiell@comcast.net>
Cc: Andi Kleen <andi@firstfloor.org>, Ulrich Drepper <drepper@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH prototype] [0/8] Predictive bitmaps for ELF executables
Message-ID: <20080322142949.GB10687@one.firstfloor.org>
References: <20080319020440.80379d50.akpm@linux-foundation.org> <a36005b50803191545h33d1a443y57d09176f8324186@mail.gmail.com> <20080320090005.GA25734@one.firstfloor.org> <a36005b50803211015l64005f6emb80dbfc21dcfad9f@mail.gmail.com> <20080321172644.GG2346@one.firstfloor.org> <a36005b50803212136s78dc2e4bx5ac715ebc7a6e48a@mail.gmail.com> <20080322071755.GP2346@one.firstfloor.org> <1206170695.2438.39.camel@entropy> <20080322091001.GA7264@one.firstfloor.org> <1206180991.2438.43.camel@entropy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206180991.2438.43.camel@entropy>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 22, 2008 at 03:16:31AM -0700, Nicholas Miell wrote:
> 
> *sigh* this is probably true

Actually it is a relatively weak argument assuming the standard
4k xattrs, but still an issue.

The other stronger argument against it is that larger xattrs tend to be
outside the inode so you would have another seek again.

> > and a mess to manage (a lot of tools don't know about them)
> 
> At this point in time, all tools that don't support xattrs are
> defective,

Good joke.

> I just have an instinctive aversion towards the kernel mucking around in
> ELF objects -- for one thing, you're going to have to blacklist
> cryptographically signed binaries.

What signed binaries? 

Anyways there are two ways to deal with this:

- Run the executable through a little filter that zeroes the bitmap before
computing the checksum.  That is how rpm -V deals with prelinked binaries which 
have a similar issue. You can probably reuse the scripts from rpm.
- Disable the pbitmap header before you sign, either by never adding
one or disabling it by turning the phdr type into a nop (should be very simple) 

-Andi
