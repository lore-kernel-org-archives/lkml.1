Return-Path: <linux-kernel-owner+w=401wt.eu-S932243AbYBBRnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932243AbYBBRnY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 12:43:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbYBBRnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 12:43:17 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:28985 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbYBBRnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 12:43:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=v6fKHBxvuNMwTAy5uhfWs0Qmgh3sX3XnkLuS/I5Qoir3P8CB/WirHKoOHsRsfhpF7BtSJxkKganjSRpS2/oHBSAmUUXOq1bP8sfk1vRm+c1+g0MOgw91xAvRla9yp3pZ85Yfj1lXnosrTQKeJwXPo+runxTDstyok3RkylXe1Uo=
Message-ID: <86802c440802020943t7f32133ew24ae946efd7474f5@mail.gmail.com>
Date: Sat, 2 Feb 2008 09:43:14 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: What's the status of x2APIC support in Linux kernel?
Cc: "Jike Song" <albcamus@gmail.com>, "Rijndael Cosque" <rijcos@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080202044318.GC12644@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <26e10850802010043m7375a110t6428d637ed1872bc@mail.gmail.com>
	 <df9815e70802010053n4565397dofd847373df522e5c@mail.gmail.com>
	 <p73fxwc50s5.fsf@bingen.suse.de>
	 <df9815e70802011855p29c10787lcee23bc9fab181d4@mail.gmail.com>
	 <20080202044318.GC12644@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 1, 2008 8:43 PM, Andi Kleen <andi@firstfloor.org> wrote:
> > Section 5 and section 9.5 describe 'I/OxAPIC'. I'm not sure if it is
> > already supported by Linux, I guess it is not.
>
> I'm not sure what the point of your questions is.  Do you want to
> do something concrete or are you just interested in random buzzwords?
>
> Anyways as far as I know Linux supports the IO APICs implemented in all
> x86 chipsets fully. That is it doesn't use every possible feature they have,
> but I'm not aware of any particular limitation caused by Linux
> not supporting some IO APIC feature.
>
> The reason for the local x/APIC was that the original non x APIC did not support
> more than 8 logical CPUs being active in the system. Presumably IO xAPIC
> refers to the IO APIC without this limitation too.

APIC: 4bit
xAPIC: 8bit?
x2APIC: 32bit? 4g logical cpu?

patch from SGI for 4096cpu/512node will use apicid as 16 bits, but
actually still use only from 8 bit.
they may wait from Intel release code for x2APIC support for extend
that to 16 bit.
x2APIC will use MSR instead of MMIO to access. that is good.
we don't need to go over mptable or ACPI madt to find phyaddress for local apic.

current code could work well with 8bit local APIC, and 4 bit IOAPIC.
I tried with lifting local apic id to 0x80 or 0x40 above, and io apic
for 0 in linuxbios then load kernel 2.6.21 ( one year ago). it worked
well

YH
