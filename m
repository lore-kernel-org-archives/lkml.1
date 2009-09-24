Return-Path: <linux-kernel-owner+w=401wt.eu-S1752409AbZIXEmJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409AbZIXEmJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 00:42:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751623AbZIXEmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 00:42:07 -0400
Received: from mail-yx0-f199.google.com ([209.85.210.199]:36059 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbZIXEmG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 00:42:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TIF4XL398rtNKaKmUOlNUq1n7XKAwBTDKyDiLTYdZZihYQS66rQbcxrUVf//fLhC41
         JQmszs1+v29rqMxXRzhMi0PLansEb9ezL71ljm20/5JbU2cGJJxzvmu9Vka6s2S0nSIP
         hkmLWV5UH37QDugP92me75Y/Xld4eV5X367Y8=
MIME-Version: 1.0
In-Reply-To: <1253762502.12653.4.camel@dc7800.home>
References: <200909161715.24376.bjorn.helgaas@hp.com>
	 <200909211520.56800.bjorn.helgaas@hp.com>
	 <4AB95F41.1070500@lwfinger.net>
	 <200909231723.31786.bjorn.helgaas@hp.com>
	 <86802c440909231628t6b35aae4u706c0c35590bc0d3@mail.gmail.com>
	 <1253762502.12653.4.camel@dc7800.home>
Date: Wed, 23 Sep 2009 21:42:09 -0700
Message-ID: <86802c440909232142p3e5d4974g51eb519d5d0ef58e@mail.gmail.com>
Subject: Re: fixing "pci=use_crs"
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, Gary Hade <garyhade@us.ibm.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 23, 2009 at 8:21 PM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> On Wed, 2009-09-23 at 16:28 -0700, Yinghai Lu wrote:
>> On Wed, Sep 23, 2009 at 4:23 PM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
>
>> > P.S.  Yinghai, you posted some patches earlier dealing with "only one
>> > HT chain."  You apparently have some insight into what's going on here,
>> > but unfortunately, the changelogs mean absolutely nothing to me.  Can
>> > you give me any clues?
>>
>> which commit?
>>
>> normally we only need to have split root resource into several pieces
>> when we have two HT chains or other io chains...
>
> I meant the patches here:
>  http://lkml.org/lkml/2009/6/24/557
>
> My opinion is that ACPI is there to give us an abstract description of
> the machine, and we shouldn't have to introduce knowledge like "this
> machine has two HT chains" or add checks in amd_bus.c about
> "pci_root_num <= 1".
>
> But maybe if I knew what an HT chain was and why you think it affects
> the description returned by _CRS, it would give me a clue about how to
> deal with this in a generic way.

we could use _CRS, but lots of BIOS just provide messed up resources
in _CRS to OS.

for example, the HW conf register does have mmio high range there, but
_CRS doesn't report them.

thought we can use whilelist to use _CRS for them.

YH
