Return-Path: <linux-kernel-owner+w=401wt.eu-S1756008AbYH3T00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008AbYH3T00 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 15:26:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753500AbYH3T0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 15:26:17 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:46097 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979AbYH3T0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 15:26:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=IZ1bBlzFnVCxQuL3BlyvK9/WJIazL746al2IMNkRpcaELv3SMjxLIrQXccGJrVzOrj
         9MuibahiZtBUTwyfw4qZ7O1r9FAgqZB3asK8lSss+B7zj/g0vuRdhJoTLGrOV11ZW+LH
         Bdyg6duLUXxUVunD+QDol6Z4WIrOuDlQGSEO4=
Message-ID: <86802c440808301226h1e7a9bb6g721ecdb0f93c5220@mail.gmail.com>
Date: Sat, 30 Aug 2008 12:26:15 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.27-rc5: System boot regression caused by commit a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>, "Tejun Heo" <htejun@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "David Witbrodt" <dawitbro@sbcglobal.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Kernel Testers" <kernel-testers@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.10.0808301150150.3290@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org>
	 <200808292157.24179.rjw@sisk.pl>
	 <alpine.LFD.1.10.0808291434110.3300@nehalem.linux-foundation.org>
	 <200808300030.32905.rjw@sisk.pl>
	 <alpine.LFD.1.10.0808301012060.3290@nehalem.linux-foundation.org>
	 <86802c440808301107n4561e815ldf53183c92a7bc93@mail.gmail.com>
	 <alpine.LFD.1.10.0808301141590.3290@nehalem.linux-foundation.org>
	 <alpine.LFD.1.10.0808301150150.3290@nehalem.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2008 at 12:14 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Sat, 30 Aug 2008, Linus Torvalds wrote:
>>
>> We simply shouldn't try to compare the BAR start with randomly chosen
>> things.
>
> Btw, looking at that bogus BAR#3 some more: I don't actually think it's
> even an MCFG resource.
>
> I think it's literally the resource that describes the HT window for the
> host bridge. So it's literally like the "root" resource - all external
> MMIO resources that go over HT have to be in that window.

his system only has one HT chain...

>
> IOW, I'm starting to think that it's not even broken. It is probably
> perfectly real. It's not a "PCI bridge" in the sense that it doesn't
> bridge one PCI bus to another, but it's a host bridge, and it bridges the
> CPU memory accesses to another bus.
>
> The fact that the MCFG area happens to be at the start of that window is
> probably just a random detail.

AMD CPU/NB (quad core aka fam 10h later) has MSR to state MMCONFIG, and
 the ATI bridge BAR that have same address for MMCONFIG not even have
chance to decode that.
because NB intercept that already.

>
> Does anybody know how to find chipset docs for AMD/ATI chipsets? I find
> CPU docs, and the GPU docs, but not the 790 chipset docs anywhere (yeah,
> it looks promising with a link that says "AMD 790FX Chipset
> Specifications", but the link just takes you to some trivial overview, not
> any actual specs.

it seems ATI chipset doesn't have public version of doc...like reg
info and BIOS/Kernel porting guide.

YH
