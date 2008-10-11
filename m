Return-Path: <linux-kernel-owner+w=401wt.eu-S1754959AbYJKLmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959AbYJKLmu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 07:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751964AbYJKLmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 07:42:42 -0400
Received: from smtp120.mail.mud.yahoo.com ([209.191.84.77]:35904 "HELO
	smtp120.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751271AbYJKLmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 07:42:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=5Qea8jL+toeRfZ46LNjonAlHYL0P1gZ/PZXz7ZGAEZdiV1XaIO+U4eiCSyxGeR2u97xHUKq7Yc4Y0BNYDDyeARsTiEaYUVV/pNdXauGTdq/k7ofLSkcCQOjlhha/JNp+SnGQA/PjScXvpssujTKq0FcmjJErQRk9AMWAbfWAsek=  ;
X-YMail-OSG: Uxdp10AVM1kvpUY5vZg2jdKAXV6hQsEh1i4dPglY6Ua5lZiwDjyJ0Dxeh4oknyHBtKPHKcLb7T_QS80rutTigdPrhCJs20MorUqkJkfZAG4XlEkh9_88Zj2G3DKIKQ3.fwNLe5t9XtTQFaHafHPh_vzrzKpe2zO_yEf1BBch
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: Update cacheline size on X86_GENERIC
Date: Sat, 11 Oct 2008 22:42:27 +1100
User-Agent: KMail/1.9.5
Cc: Dave Jones <davej@redhat.com>, x86@kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
References: <20081009171453.GA15321@redhat.com> <200810111929.19891.nickpiggin@yahoo.com.au> <20081011112218.GA12131@one.firstfloor.org>
In-Reply-To: <20081011112218.GA12131@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810112242.28229.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 11 October 2008 22:22, Andi Kleen wrote:
> On Sat, Oct 11, 2008 at 07:29:19PM +1100, Nick Piggin wrote:
> > I also think there are reasonable arguments the other way, and I
> > personally also think it might be better to leave it 128 (even
> > if it is unlikely, introducing a regression is not good).
>
> The issue is also that the regression will be likely large.

Yeah, that is what I'm worried about. If it was a simple case of
1% loss on P4 for 1% gain on Core2, it would be a good change.
But it might be huge losses on P4s.


> False sharing can really hurt when it hits as you know, because
> the penalties are so large.
>
> > > There are millions and millions of P4s around.
> > > And they're not that old, they're still shipping in fact.
> >
> > Still shipping in anything aside from 1s systems?
>
> Remember the first Core2 based 4S (Tigerton) Xeon was only introduced last
> year and that market is quite conservative. For 2S it's a bit longer, but
> it wouldn't surprise me there if new systems are still shipping.
>
> Also to be honest I doubt the theory that older systems
> are never upgraded to newer OS.

Yeah, fair enough.


> > That would be nice. It would be interesting to know what is causing
> > the slowdown.
>
> At least that test is extremly cache footprint sensitive. A lot of the
> cache misses are surprisingly in hd_struct, because it runs
> with hundred of disks and each needs hd_struct references in the fast path.
> The recent introduction of fine grained per partition statistics
> caused a large slowdown. But I don't think kernel workloads
> are normally that extremly cache sensitive.

That's interesting. struct device is pretty big. I wonder if fields
couldn't be rearranged to minimise the fastpath cacheline footprint?
I guess that's already been looked at?
