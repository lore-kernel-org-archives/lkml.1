Return-Path: <linux-kernel-owner+w=401wt.eu-S1759419AbZBLNLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759419AbZBLNLk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 08:11:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759122AbZBLNLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 08:11:18 -0500
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:41556 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759096AbZBLNLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 08:11:17 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=0x0aInNqWIASve2UFzWa33nykqZCpslerDdhQtET1L1S2+9bL3q9LX3U5PZMPJWUnQl1CFSsoYIeGXB5JUeVGNt3nHiQi9D2Ku6YYSS7TnT3gYN5R7uJWINXrESpU+lskDAJrcBBU48whLuCQmh/bvbSALBn/RXkLZNQB/7FGg0=  ;
X-YMail-OSG: hd2dGGcVM1kDmVjJH7KainXGAdfpcPT2gM8ueUZo55UHVeXaI0IhNRHdQnhlNWcQt7jhXYsTt3yZ4qFbrYriafEgOwaYyBIRHmJmZQ_3zjvFX6AJLL4Tgjbvt79Xo6ik7CxlHaiSAvJtFS6nyIm_79excYHQSAkkCw.FVY2989Ur2FUQS6e7kAjgwItJgg--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] Export symbol ksize()
Date: Fri, 13 Feb 2009 00:10:45 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       Christoph Lameter <cl@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-crypto@vger.kernel.org,
       Geert.Uytterhoeven@sonycom.com
References: <1234272104-10211-1-git-send-email-kirill@shutemov.name> <1234435521.28812.165.camel@penberg-laptop> <20090212105034.GC13859@gondor.apana.org.au>
In-Reply-To: <20090212105034.GC13859@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902130010.46623.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 February 2009 21:50:34 Herbert Xu wrote:
> On Thu, Feb 12, 2009 at 12:45:21PM +0200, Pekka Enberg wrote:
> > Because the API was being widely abused in the nommu code, for example.
> > I'd rather not add it back for this special case which can be handled
> > otherwise.
>
> I'm sorry but that's like banning the use of heaters just because
> they can abused and cause fires.
>
> I think I've said this to you before but in networking we very much
> want to use ksize because the standard case of a 1500-byte packet
> has loads of extra room given by kmalloc which all goes to waste
> right now.

I'm not against the idea of exporting ksize. It is a fairly well
commented function.

I'd be up for nearly anything in the slab layer that speeds up
networking, to be honest ;)


> If we could use ksize then we can stuff loads of metadata in that
> space.

I would be interested to know how that goes. You always have this
circular issue that if a little more space helps significantly, then
maybe it is a good idea to explicitly ask for those bytes. Of course
that larger allocation is also likely to have some slack bytes.

So the benefit you get from using these slack bytes has to be larger
than the cost of using ksize, but smaller than the cost of explicitly
asking for more bytes at alloc time. Interesting...

