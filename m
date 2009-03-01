Return-Path: <linux-kernel-owner+w=401wt.eu-S1756754AbZCAOHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754AbZCAOHs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 09:07:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754151AbZCAOHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 09:07:38 -0500
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:25525 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753883AbZCAOHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 09:07:37 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=IkA2m8Swlvem4AigT5z/0ZbrljVNgjSIn6J0+8o60XqOvpeVncvH6eoasLIGosZkubddMvQraMTii+jpbHEU5eV9T25Sgx4wpxHdL1B/1GzLsIud9rb45fwMEUjjk/jgS+mXeZOZGK/FmdC7fS2vnoUEuUGspO4Bg15MjVUNSo0=  ;
X-YMail-OSG: UlN_EkYVM1nU8vYraQJuOrbIn8SdUsF7aCbXPIgswzigwdyyDYKEXg8vdx39ZI1LbSqbnwEQksmIoc_iyGnovusKaTatigzevAva9wEVX3MbgILRg4kiseniwlRoQOG_Md9J9599mWl2LfsLuxCIF3GUYXmsHsl7ee0004GDT2mZpNnj5KUnjv30gG4mJA--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch] x86, mm: pass in 'total' to __copy_from_user_*nocache()
Date: Mon, 2 Mar 2009 01:06:51 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Arjan van de Ven <arjan@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       mingo@elte.hu, sqazi@google.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
References: <alpine.LFD.2.00.0902280904271.3111@localhost.localdomain> <20090228173813.6d86c0ef@infradead.org> <49A9E7A3.4050102@zytor.com>
In-Reply-To: <49A9E7A3.4050102@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903020106.51865.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 01 March 2009 12:40:51 H. Peter Anvin wrote:
> Arjan van de Ven wrote:
> > the reason that movntq and co are faster is because you avoid the
> > write-allocate behavior of the caches....
> >
> > the cache polluting part of it I find hard to buy for general use (as
> > this discussion shows)... that will be extremely hard to measure as
> > a real huge thing, while the WA part is like a 1.5x to 2x thing.
>
> Note that hardware *can* (which is not the same thing as hardware
> *will*) elide the write-allocate behavior.  We did that at Transmeta for
> rep movs and certain other instructions which provably filled in entire
> cache lines.  I haven't investigated if newer Intel CPUs do that in the
> "fast rep movs" case.

I would expect any high performance CPU these days to combine entries
in the store queue, even for normal store instructions (especially for
linear memcpy patterns). Isn't this likely to be the case?

