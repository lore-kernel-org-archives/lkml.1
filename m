Return-Path: <linux-kernel-owner+w=401wt.eu-S1756524AbYFPRlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524AbYFPRlb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 13:41:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752711AbYFPRlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 13:41:23 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:36449 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666AbYFPRlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 13:41:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Gi8s1AuRUfJczsl8MnjTq9Iq/lsTBev4cL3JizfV9M8xk8O69V6dz84cHC2v1sWcj5
         C8WSs+DR/349tdFMn+tpC+dSAruFGZD+VRwyumztM79WBX4Cci7MJaIOQ724OKuXqp1Y
         PUa/bmsQVffVt1cFSuoY8VD9mKqCPIOw3Demk=
Message-ID: <86802c440806161041v5f582d4y2a65adf57451a6d9@mail.gmail.com>
Date: Mon, 16 Jun 2008 10:41:22 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: [PATCH 4/8] x86 boot: allow overlapping ebda and efi memmap memory ranges
Cc: "H. Peter Anvin" <hpa@zytor.com>, ying.huang@intel.com, mingo@elte.hu,
       tglx@linutronix.de, steiner@sgi.com, travis@sgi.com,
       linux-kernel@vger.kernel.org, andi@firstfloor.org,
       akpm@linux-foundation.org
In-Reply-To: <20080616123721.bb9195e6.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080616062945.14597.78009.sendpatchset@polaris-admin.engr.sgi.com>
	 <20080616063001.14597.96170.sendpatchset@polaris-admin.engr.sgi.com>
	 <1213600062.11185.13.camel@caritas-dev.intel.com>
	 <20080616032457.718f4d87.pj@sgi.com>
	 <1213606435.12968.14.camel@caritas-dev.intel.com>
	 <48568B56.7060307@zytor.com> <20080616113806.2ff4c1a4.pj@sgi.com>
	 <48569D62.9050107@zytor.com> <20080616123721.bb9195e6.pj@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2008 at 10:37 AM, Paul Jackson <pj@sgi.com> wrote:
> hpa, replying to pj:
>> >> Would you recommend doing this with code in arch/x86/kernel/head.c,
>> >> that did not invoke reserve_ebda_region() if efi_enabled was set?
>>
>> I disagree with it
>
> Ok - that's clear.
>
> So it would seem that I am getting conflicting advice.
>
> One person recommends code that only makes this safety reservation of
> the ebda region in the non-EFI case:
>
>    if (!efi_enabled)
>        reserve_ebda_region();
>
> and the other recommends code that always makes this safety reservation,
> and that handles the possible resulting overlap with the EFI memmap:
>
>    if (!range_in_ebda_area(pmap, pmap + memmap.nr_map * memmap.desc_size))
>        reserve_early(pmap, pmap + memmap.nr_map * memmap.desc_size,
>            "EFI memmap");
>
> (The above code should be adjusted in light of Yinghai's suggestion
> that it handle partial overlap.)
>
> The resolution of this conflict might be easy, however.
>
> I will readily accept that there exist some 'classic' PCs for which
> we need to reserve a 'safe' ebda area.
>
> The question to me is this.  Are there PCs which (1) need such a safety
> reservation of an ebda area -and- (2) boot with EFI enabled?  I am not
> asking if there -could- be (in the abstract, there certainly is no law
> of government or physics prohibiting such).  Rather I am asking as a
> practical matter if there is, or is likely to be, such PCs "in the wild."

like to see to make
reserve_ebda_region() more smart like the old way when andi introduced
ebda_size...
instead of reserve 0x9000 to 0x100000 all the way.

YH
