Return-Path: <linux-kernel-owner+w=401wt.eu-S1756002AbYIIHzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002AbYIIHzu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 03:55:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753532AbYIIHzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 03:55:41 -0400
Received: from smtp113.mail.mud.yahoo.com ([209.191.84.66]:20968 "HELO
	smtp113.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753070AbYIIHzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 03:55:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=jD53m5EXkUYkgZ+QHwy05fvRlrtHYQuMnWqEXRHG2BZUWLgx+gIeOtAzJWmTTZi69jVI8VCkLrxdM9fOhLAsdnaeJnDA3XEtf3bhv3EKinP84BN52gGqgv6rjAcc2E/w5gMNACKipa21xNAGwXAokzCLzRa7AVINXPtVOblTQKw=  ;
X-YMail-OSG: lmjNFwAVM1nRtNSPFzG1DlsvH39IGUp3AgV2zANdONDXyWH.0DzLlv2xaA3FMo.Wt6S2DgKFI2M5un04wK7U3mWVCtmTPsldEBG01.u6L5cbxksTfkus4EfQKG1jA4djNaFXxkcWosPLF3LqC1Jch820
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Krzysztof Helt <krzysztof.h1@poczta.fm>
Subject: Re: 2.6.27-rc5-mm1: 3 WARN_ON dumps during boot (acpi + vmap_pte_range)
Date: Tue, 9 Sep 2008 17:55:23 +1000
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Dave Airlie <airlied@linux.ie>, Rusty Russell <rusty@rustcorp.com.au>
References: <20080906084558.dff614d4.krzysztof.h1@poczta.fm> <200809091304.47769.nickpiggin@yahoo.com.au> <20080909070501.244d06ab.krzysztof.h1@poczta.fm>
In-Reply-To: <20080909070501.244d06ab.krzysztof.h1@poczta.fm>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809091755.23379.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 September 2008 15:05, Krzysztof Helt wrote:
> On Tue, 9 Sep 2008 13:04:47 +1000
>
> Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > On Tuesday 09 September 2008 03:52, Krzysztof Helt wrote:
> > > alloc_vmap_area within(e07f0000-fffb7000) size=801000
> > > returns=(e0880000-e1081000)
> > > alloc_vmap_area within(e07f0000-fffb7000) size=2000
> > > returns=(e07f0000-e07f2000)
> > > alloc_vmap_area within(e07f0000-fffb7000) size=2000
> > > returns=(e0822000-e0824000)
> > > vunmap_page_range (e07f0000-e07f2000 size=2000)
> > > free_vmap_area (e07f0000-e07f2000 size=2000)
> > >
> > > alloc_vmap_area within(e07f0000-fffb7000) size=5000
> > > returns=(e07f0000-e07f5000)
> > > ------------[ cut here ]------------
> > > WARNING: at mm/vmalloc.c:40 check_pte_range+0x83/0x90()
> >
> > Thanks for that, it clearly shows the virtual address allocator
> > is allowing an overlapping allocation after a vm_unmap_aliases()
> > call. Unfortunately, my "random" test case happened not to
> > trigger that... I should have paid more attention to edge cases
> > rather than just random testing.
> >
> > Anyway, I hope this fix should solve the problem for you? (it
> > fixes it here)
>
> Your patch fixes two WARN_ON dumps from my original dmesg (agp
> related and module loading related).
> The remaining one is the acpi kobject duplication.
>
> Tested-by: Krzysztof Helt <krzysztof.h1@wp.pl>
>
> Thanks a lot Nick,
> Krzysztof

Great, thanks very much for reporting and testing.
