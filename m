Return-Path: <linux-kernel-owner+w=401wt.eu-S1755572AbYIHVaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572AbYIHVaV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 17:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754212AbYIHVaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 17:30:09 -0400
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:29653 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754174AbYIHVaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 17:30:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=rYbx6nArM53aCywECbnHmidNynt5ErU7Nr8o5a3CaLVDxLNvK5pDb2uDNmUEuOVYOw1GVwxJN4jfCFlZDTgAIiOyM6lF3zm65KtQfMNqbMIh4Yvc1fHKSMnkHewqJLavg2jqQKPMBl0USyppsOqRPv+XA/Uq5bgzaXU5w4JbTFY=  ;
X-YMail-OSG: W5JhLdAVM1lfjNJt7nt4h7DtCRQfJ8Ts.mCFL5DFYCvpLiIhACNPgD9_85NejpekB8olEMU8XIttoZ2_wsbRErlgs.F4ephMyUMGNLLoPA--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH] fix RTC_CLASS regression with PARISC
Date: Mon, 8 Sep 2008 14:29:57 -0700
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Parisc List <linux-parisc@vger.kernel.org>
References: <1220889205.8074.16.camel@localhost.localdomain> <200809081213.37705.david-b@pacbell.net> <1220905689.8074.68.camel@localhost.localdomain>
In-Reply-To: <1220905689.8074.68.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200809081429.57805.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 September 2008, James Bottomley wrote:
> 
> > > OK, I can look at that, but in the mean time could we make the option
> > > that causes the damage unselectable?
> > 
> > I'd worry if "the mean time" takes too long.  But lacking a
> > PARISC laptop to fix this on, I'm unlikely to complain much.
> 
> What is the expectation?  If you're expecting all the architectures to
> migrate over to RTC_CLASS, actually telling linux-arch and saying why
> its a good idea would have been helpful.

Folk have been migrating already.  IMO there's no rush ... but
similarly, retrograde motion should be discouraged.  (Same issue
with essentially all legacy code in the tree.)


> All the PDC real time clock calls can do are read and set, nothing else,
> so it's idealy suited to the GEN_RTC infrastructure ... what's the
> benefit in moving it to RTC_CLASS?

The same benefit always found in sharing infrastructure.  Lots
of little differences/bugs go away.  Infrastructure improvements
and bugfixes get leveraged.  Dead and crufticious code can vanish.
And so forth.


> > >      This is technically a regression 
> > > because before your patch GEN_RTC would override RTC_CLASS, now it's the
> > > other way around.
> > 
> > Well, previously there was no override ... I think you mean
> > that parisc just completely ignored RTC_CLASS, treating it
> > like junk DNA.
> 
> No, it's a regression.  ...  This turns off the ability to select
> GEN_RTC if you've said yes to RTC_CLASS.  Since RTC_CLASS is currently
> unsupported on parisc, we need to fix that by making the RTC_CLASS
> option unselectable on parisc.

So you affirmed that there was no override, AND that it was
previously treated as junk DNA (ignored).  So just what were
you disagreeing with me about??

I have a hard time calling something a regression which
was never really a supported configuration.  And which
still *JUST WORKS* in those defconfigs ... given all that,
it's hard to argue that something is actually broken.

Kconfig is not about letting Aunt Tillie configure kernels
without being able to shoot herself in the foot.  That
discussion has been had (at length!) before.  Result, we
have a much better kernel config framework ... but still
don't facilitate "Kconfig-4-dummiez" audiences.

- Dave

