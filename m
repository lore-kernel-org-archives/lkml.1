Return-Path: <linux-kernel-owner+w=401wt.eu-S1762029AbYEAQfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762029AbYEAQfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 12:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753678AbYEAQfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 12:35:39 -0400
Received: from rv-out-0708.google.com ([209.85.198.246]:19592 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753167AbYEAQfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 12:35:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=i+aVUebnHvPh5mLA0nZwEvgU8gjSzs7cfLbLGx3mkdaVeHWKXekFF7q/sC2IRT3Ffka0V+qiHvGbIeXK7RBU3BFcdSI8idKO+8lBTK0vI5GV/B0EnoWXXxVL2DaatOHs7mj81tTEHvK0KDRD+ANVl+Q1zeq6c3KTgRsqjg87Afg=
Message-ID: <86802c440805010935w5a74f132l639d7b794804bb9e@mail.gmail.com>
Date: Thu, 1 May 2008 09:35:38 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Mika Fischer" <mika.fischer@zoopnet.de>
Subject: Re: [PATCH] x86: mtrr cleanup for converting continuous to discrete - auto detect
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Gabriel C" <nix.or.die@googlemail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4819B2E0.406@zoopnet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804272337.40130.yhlu.kernel@gmail.com>
	 <200804290352.33543.yhlu.kernel@gmail.com>
	 <200804292025.58268.yhlu.kernel@gmail.com>
	 <200805010100.34751.yhlu.kernel@gmail.com> <4819B2E0.406@zoopnet.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 1, 2008 at 5:09 AM, Mika Fischer <mika.fischer@zoopnet.de> wrote:
> Yinghai Lu schrieb:
>
> > loop mtrr chunk_size and gran_size from 1M to 2G to find out optimal value.
>  >
>  > so user don't need to add mtrr_chunk_size and mtrr_gran_size,
>  >
>  > if optimal value is not found, print out all list to help select less optimal
>  > value.
>  >
>  > add mtrr_spare_reg_nr= so user could set 2 instead of 1, if the card need more entries.
>
>  On my system x86-latest + this patch and using no boot options gives me
>  this /proc/mtrr:
>  reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
>  reg01: base=0x80000000 (2048MB), size= 512MB: write-back, count=1
>  reg02: base=0xa0000000 (2560MB), size= 256MB: write-back, count=1
>  reg03: base=0xb0000000 (2816MB), size= 256MB: write-back, count=1
>  reg04: base=0xbf700000 (3063MB), size=   1MB: uncachable, count=1
>  reg05: base=0xbf800000 (3064MB), size=   8MB: uncachable, count=1
>  reg06: base=0x100000000 (4096MB), size=1024MB: write-back, count=1
>
>  Which is OK. It could probably collapse reg01-reg03 into one but that's
>  a minor issue (for me at least, there are probably cases where
>  collapsing them might save the user from having to specify the
>  mtrr_spare_reg_nr boot option).

yes. please try mtrr_spare_reg_nr=3 or etc.

YH
