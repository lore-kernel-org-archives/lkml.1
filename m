Return-Path: <linux-kernel-owner+w=401wt.eu-S1758982AbZBMNVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758982AbZBMNVd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 08:21:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753219AbZBMNVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 08:21:25 -0500
Received: from smtp113.mail.mud.yahoo.com ([209.191.84.66]:25682 "HELO
	smtp113.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753399AbZBMNVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 08:21:24 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=jQhaUo32+vfcCpkZv46x9fIv+J5Ty5bgh0uRO4U/Ow1MxMxx3S4fhAM44fAxq31sL1PfuB5FifSZgJ/GU7UFH+hyMePHQ7t6XoaBxRJp5Kh+T5PGl+ln0Ed5oAdYLyQWbcRzzAoKdbNozmC+1fcf4DdYtOF2WnVaMJaySXkCypk=  ;
X-YMail-OSG: ueOuK.MVM1mDV96htmXW15pqCsyAmczdp3WWd6fOcUVBKtBBt1ECsPwKNhkcFXALUZSvZ1um8V6xO3c4gIa.EgHiwaf5pXhUyGic36xsZUjxabfccEirxKn1Y3XPgVSfSVBflUK2vFOFNpZBiKAc9_btsdAh.bdvWkdxrJiGZ93O8wvN9m6o3JRJ0lSOJg--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH] Export symbol ksize()
Date: Sat, 14 Feb 2009 00:20:44 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-crypto@vger.kernel.org, Geert.Uytterhoeven@sonycom.com
References: <1234272104-10211-1-git-send-email-kirill@shutemov.name> <20090212230934.GA21609@gondor.apana.org.au> <1234481821.3152.27.camel@calx>
In-Reply-To: <1234481821.3152.27.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902140020.45522.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 February 2009 10:37:01 Matt Mackall wrote:
> On Fri, 2009-02-13 at 07:09 +0800, Herbert Xu wrote:
> > On Fri, Feb 13, 2009 at 12:10:45AM +1100, Nick Piggin wrote:
> > > I would be interested to know how that goes. You always have this
> > > circular issue that if a little more space helps significantly, then
> > > maybe it is a good idea to explicitly ask for those bytes. Of course
> > > that larger allocation is also likely to have some slack bytes.
> >
> > Well, the thing is we don't know apriori whether we need the
> > extra space.  The idea is to use the extra space if available
> > to avoid reallocation when we hit things like IPsec.
>
> I'm not entirely convinced by this argument. If you're concerned about
> space rather than performance, then you want an allocator that doesn't
> waste space in the first place and you don't try to do "sub-allocations"
> by hand. If you're concerned about performance, you instead optimize
> your allocator to be as fast as possible and again avoid conditional
> branches for sub-allocations.

Well, my earlier reasoning is no longer so clear cut if eg. there
are common cases where no extra space is required, but rare cases
where extra space might be a big win if it eg avoids extra
alloc, copy, free or something.

Because even with performance oriented allocators, there is a non-zero
cost to explicitly asking for more memory -- queues tend to get smaller
at larger object sizes, and page allocation orders can increase. So if
it is very uncommon to need extra space you don't want to burden the
common case with it.


