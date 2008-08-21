Return-Path: <linux-kernel-owner+w=401wt.eu-S1757441AbYHUNOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441AbYHUNOT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 09:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752857AbYHUNOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 09:14:06 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:34784 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888AbYHUNOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 09:14:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=r7GK3URsiL+5uUjiCGhM0dRnwe1ppFcC1fC7LoakzvTNSo3FZQ5iBjFuj8/O9uMCIb
         RVfByYQn4W9CwSllchiHqYRtRero/272ONPbxCa8Fq8OE7k3wnSyyEYS3gblStlBowPL
         /i1m7vLtNO8hivTE9v56XAzqhTIZ4JdGiiPAY=
Message-ID: <19f34abd0808210614g15330a02u7a0625f88dfe4798@mail.gmail.com>
Date: Thu, 21 Aug 2008 15:14:03 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: 2.6.27-rc3: 'APIC error on CPU1: 00(40)', but only on resume!
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "Frans Pop" <elendil@planet.nl>,
       linux-kernel@vger.kernel.org, "Andi Kleen" <andi@firstfloor.org>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <Pine.LNX.4.55.0808211340100.22938@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200808202106.41058.elendil@planet.nl>
	 <200808202138.13302.rjw@sisk.pl>
	 <200808202226.45655.elendil@planet.nl>
	 <200808202356.33036.rjw@sisk.pl>
	 <Pine.LNX.4.55.0808211023020.22938@cliff.in.clinika.pl>
	 <19f34abd0808210418w39341d05p43712356b352cdc9@mail.gmail.com>
	 <Pine.LNX.4.55.0808211240090.22938@cliff.in.clinika.pl>
	 <19f34abd0808210520q60357776xbfcf288018e04161@mail.gmail.com>
	 <Pine.LNX.4.55.0808211340100.22938@cliff.in.clinika.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 2:57 PM, Maciej W. Rozycki <macro@linux-mips.org> wrote:
> On Thu, 21 Aug 2008, Vegard Nossum wrote:
>
>> Ah, right. Here is a dump of the LVT registers:
>>
>> [00000320] = 000100ef
>> [00000330] = 00000200
>> [00000340] = 00010000
>> [00000350] = 00010700
>> [00000360] = 00000400
>> [00000370] = 000000fe
>>
>> Maybe I've misunderstood something (again), but should those vectors
>> really be 0 for 330-360? (At least 330 + 360, which are not masked.)
>
>  Masked entries should be fine long-term, although I have a vague
> recollection at least some implementations do send a vector error when an
> LVT register is written with a masked entry implying an invalid vector,
> e.g. a value like 0x00010000.
>
>  Overall the issue of the validity of the vector exists for interrupts
> using the native APIC priority model only, that is ones using the Fixed
> and LoPri delivery modes.  All the others either ignore the vector
> altogether, such as the ExtINTA delivery mode, or assign a special meaning
> to it, such as the StartUp mode.
>
>  In this case the thermal entry at 0x330 uses the SMI delivery mode and
> the LINT1 entry at 0x360 uses the NMI mode, so the vector is ignored for
> both.
>
>  Thus this LVT is entirely valid and if you receive invalid vector
> interrupts, then the reason must be elsewhere.  Of course you cannot
> exclude a possibility where at some intermediate stage the LVT of your
> system has not been correctly initialised.

Thank you for the excellent explanations! I've double-checked and
everything you said makes perfect sense.

The reason must be elsewhere.


Vegard

PS: My APICs have version 0x20, which according to the Intel manual is
a reserved value. My book is from 2005, though.

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
