Return-Path: <linux-kernel-owner+w=401wt.eu-S1754748AbYH3Td0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748AbYH3Td0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 15:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752552AbYH3TdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 15:33:17 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:46536 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbYH3TdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 15:33:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=wSzdgaw6tFlSnzTU+HAy7KramECBpfluzi1ZFZIbeawEgIz505NXnWgK81hICBTGpy
         pBaQBi46XHrggAgkSA/VZ+JcxL3jkeqH8/LgGOxkggToT1iuI0143FpXAq3fprxJgeQ/
         G2X15TBZ98+m6nEPOrRcKW/PjnWFn0iVEPWVM=
Message-ID: <86802c440808301233q48ae725dt2f06e7f59712636@mail.gmail.com>
Date: Sat, 30 Aug 2008 12:33:16 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: 2.6.27-rc3: 'APIC error on CPU1: 00(40)', but only on resume!
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Frans Pop" <elendil@planet.nl>,
       linux-kernel@vger.kernel.org, "Andi Kleen" <andi@firstfloor.org>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <19f34abd0808210520q60357776xbfcf288018e04161@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 5:20 AM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> On Thu, Aug 21, 2008 at 1:51 PM, Maciej W. Rozycki <macro@linux-mips.org> wrote:
>>  Otherwise there is no correlation between the sequence of APIC writes and
>> an error triggering -- a bad vector in a LVT or interrupt redirection
>> entry will be reported whenever its associated interrupt line gets active
>> even though the entry might have been initialised long ago.  Depending on
>> the device signalling hardware interrupts may quite often be ignored for a
>> long time without affecting the stability of the rest of the system.
>
> Ah, right. Here is a dump of the LVT registers:
>
> [00000320] = 000100ef
> [00000330] = 00000200
> [00000340] = 00010000
> [00000350] = 00010700
> [00000360] = 00000400
> [00000370] = 000000fe
>
> Maybe I've misunderstood something (again), but should those vectors
> really be 0 for 330-360? (At least 330 + 360, which are not masked.)
>
> Intel manual says: "Receive Illegal Vector : Set when the local APIC
> detects an illegal vector in the message it received, including an
> illegal vector code in the local vector table interrupts or in a
> self-interrupt."
>
> And 0 is clearly an illegal value for the vector code: "When an
> interrupt vector in the range 0 to 15 is sent or received through the
> local APIC, the APIC indicates an illegal vector in its Error Status
> Register [...]".

can you try dump the io apic registers too?

YH
