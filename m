Return-Path: <linux-kernel-owner+w=401wt.eu-S1758407AbXE2NnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758407AbXE2NnX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 09:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbXE2NnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 09:43:16 -0400
Received: from keil-draco.com ([216.193.185.50]:50076 "EHLO mail"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750699AbXE2NnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 09:43:15 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Michael-Luke Jones <mlj28@cam.ac.uk>
Subject: Re: JFFS2 using 'private' zlib header (was [RFC] LZO de/compression support - take 6)
Date: Tue, 29 May 2007 09:43:10 -0400
User-Agent: KMail/1.9.6
Cc: Satyam Sharma <satyam.sharma@gmail.com>,
       Nitin Gupta <nitingupta910@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, linux-mm-cc@laptop.org,
       linuxcompressed-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Richard Purdie <richard@openedhand.com>, Bret Towe <magnade@gmail.com>,
       dwmw2@infradead.org
References: <4cefeab80705280734i37df1742k6738cd4200813684@mail.gmail.com> <a781481a0705290427n3bad472aqf4e0b8276780b405@mail.gmail.com> <231C137C-D0BF-44F7-B2D5-AE610284D00A@cam.ac.uk>
In-Reply-To: <231C137C-D0BF-44F7-B2D5-AE610284D00A@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705290943.11176.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 May 2007 09:33:51 Michael-Luke Jones wrote:
> On 29 May 2007, at 12:27, Satyam Sharma wrote:
> > Right, actually, zlib could be switched over to [using a common
> > directory].
> > Because zlib_deflate/ and zlib_inflate/ too share a private header
> > zutil.h which has unfortunately been stuck into include/linux/ with
> > a big
> > /* WARNING: this file should *not* be used by applications. */
> > comment ...
>
> Well, unfortunately zutil.h is currently being used in-kernel by fs/
> jffs2/compr_zlib.c despite the "WARNING: this file should *not* be
> used by applications" notice.
>
> So moving this header to a truly private location isn't possible
> right now, unfortunately,
>
> Michael-Luke Jones
> [added David Whitehouse to cc]

I've looked at that code and it seems to need that file for one constant. 
Perhaps it'd be better for jffs2/compr_zlib.c to define that constant itself 
(or use it as a "Magic Number") rather than include the zlib private header. 
Another possibility would be to move that constant out of zutil.h and into 
zconf.h or zlih.b - doing any of those would allow the zlib private header to 
be moved such that zlib could be changed to use a common directory *and* have 
said private header in that directory.

DRH


