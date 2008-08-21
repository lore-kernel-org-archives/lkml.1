Return-Path: <linux-kernel-owner+w=401wt.eu-S1754574AbYHUMUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574AbYHUMUg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 08:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752624AbYHUMU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 08:20:28 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:21015 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240AbYHUMU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 08:20:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=nYkbaaFSxDa/3pNro9c9E/garOWgBW7Mfr9reSQNtW8lV1ZB3FN/XH4Sy1cAoY/QjT
         a9o2RkkhuaAEbNgmDgWGK9EWHIxU4uGwWfu+DJsATtq/E+1DdHUmY4wEIYiTjCuFiQvB
         wVN5uM9zTaETFIRG2ASrXg1OHjQT5lyqNtDsc=
Message-ID: <19f34abd0808210520q60357776xbfcf288018e04161@mail.gmail.com>
Date: Thu, 21 Aug 2008 14:20:26 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: 2.6.27-rc3: 'APIC error on CPU1: 00(40)', but only on resume!
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "Frans Pop" <elendil@planet.nl>,
       linux-kernel@vger.kernel.org, "Andi Kleen" <andi@firstfloor.org>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <Pine.LNX.4.55.0808211240090.22938@cliff.in.clinika.pl>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 1:51 PM, Maciej W. Rozycki <macro@linux-mips.org> wrote:
>  Otherwise there is no correlation between the sequence of APIC writes and
> an error triggering -- a bad vector in a LVT or interrupt redirection
> entry will be reported whenever its associated interrupt line gets active
> even though the entry might have been initialised long ago.  Depending on
> the device signalling hardware interrupts may quite often be ignored for a
> long time without affecting the stability of the rest of the system.

Ah, right. Here is a dump of the LVT registers:

[00000320] = 000100ef
[00000330] = 00000200
[00000340] = 00010000
[00000350] = 00010700
[00000360] = 00000400
[00000370] = 000000fe

Maybe I've misunderstood something (again), but should those vectors
really be 0 for 330-360? (At least 330 + 360, which are not masked.)

Intel manual says: "Receive Illegal Vector : Set when the local APIC
detects an illegal vector in the message it received, including an
illegal vector code in the local vector table interrupts or in a
self-interrupt."

And 0 is clearly an illegal value for the vector code: "When an
interrupt vector in the range 0 to 15 is sent or received through the
local APIC, the APIC indicates an illegal vector in its Error Status
Register [...]".

But I still find the whole thing slightly confusing. Will play a bit
with the LVT, maybe I can learn something more :-) Thanks for the
help!


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
