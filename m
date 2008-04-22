Return-Path: <linux-kernel-owner+w=401wt.eu-S1761592AbYDVAy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761592AbYDVAy3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 20:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755028AbYDVAyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 20:54:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37979 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760468AbYDVAyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 20:54:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at ffffffffffffffff
Date: Tue, 22 Apr 2008 02:54:43 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: paulmck@linux.vnet.ibm.com, David Miller <davem@davemloft.net>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu, akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
       herbert@gondor.apana.org.au, Zdenek Kabelac <zdenek.kabelac@gmail.com>
References: <alpine.LFD.1.10.0804201410090.2779@woody.linux-foundation.org> <480D1CF1.7010300@gmail.com> <480D208A.9050909@gmail.com>
In-Reply-To: <480D208A.9050909@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804220254.45251.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 22 of April 2008, Jiri Slaby wrote:
> On 04/22/2008 01:02 AM, Jiri Slaby wrote:
> > On 04/22/2008 12:54 AM, Paul E. McKenney wrote:
> >> On Tue, Apr 22, 2008 at 12:26:04AM +0200, Jiri Slaby wrote:
> >>>> Having slub_debug enabled, tomorrow will be results, I guess...
> 
> OK, methinks it's tomorrow yet, at least here.
> 
> >>> Sorry, one more entry:
> >>>
> >>> 00000000000000f0 dentry.d_op (Zdenek, offset ? around 136)
> > 
> > Zdenek's is at offset 184.
> > 
> >>> 00f0000000000000 dentry.d_hash.next (me, offset 24)
> >>> ffff81f02003f16c dentry.d_name.name (me, offset 56)
> >>>         memory ORed by 000000f000000000
> >>> fffff0002004c1b0 file.f_mapping (me, offset 176)
> >>>         memory hole, it was something like
> >>>         (ffff81002004c1b0 & ~00000f0000000000) | 0000f00000000000?
> >>> ffffffffffffffff dentry.d_hash.next (Rafael, offset ? around 24)
> >>>         -1, ~0ULL
> 
> The same place, dentry.d_hash.next is 1. No slub debug clues... I think, I'll 
> give slab a try. Any other clues?

Well, SLUB uses some per CPU data structures.  Is it possible that they get
corrupted and which leads to the observed symptoms?
