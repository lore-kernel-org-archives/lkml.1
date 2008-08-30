Return-Path: <linux-kernel-owner+w=401wt.eu-S1752139AbYH3FCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139AbYH3FCo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 01:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750849AbYH3FCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 01:02:35 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:52548 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbYH3FCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 01:02:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Z5E1vIQkMXqZ8D7gHqJq2CURnJaIw0z6wSSwN2Tuw4o0xbrGQ58pIOlgAXPbck65lC
         gYoE7oglUZQMU/lcelaNh0DUWQnixq/H+OEJ6tkklgTjaqxO9fjB9VYzGSgFOfKpWqvv
         PIipICI5TDp187v3Evr60ShO35jJoSR9ogZn0=
Message-ID: <86802c440808292202v235e66bcr42f3727a3665a71e@mail.gmail.com>
Date: Fri, 29 Aug 2008 22:02:33 -0700
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
In-Reply-To: <86802c440808292141g6ffd1329p54e58ee04c26540a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org>
	 <86802c440808291711t32d3e76dsf804856b0a8f4939@mail.gmail.com>
	 <alpine.LFD.1.10.0808291733260.3300@nehalem.linux-foundation.org>
	 <alpine.LFD.1.10.0808291751480.3300@nehalem.linux-foundation.org>
	 <86802c440808291830t4547140dx9b12353649edd975@mail.gmail.com>
	 <alpine.LFD.1.10.0808291919080.3300@nehalem.linux-foundation.org>
	 <alpine.LFD.1.10.0808291954410.3300@nehalem.linux-foundation.org>
	 <86802c440808292007t3588edfnef95b723320ff023@mail.gmail.com>
	 <alpine.LFD.1.10.0808292017440.5010@nehalem.linux-foundation.org>
	 <86802c440808292141g6ffd1329p54e58ee04c26540a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2008 at 9:41 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> On Fri, Aug 29, 2008 at 8:24 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>>
>> On Fri, 29 Aug 2008, Yinghai Lu wrote:
>>>
>>> we need to use insert_resource_split_to_fit instead...
>>>
>>> otherwise __request_region will not be happy.
>>
>> Are you really really sure?
>>
>> Try just removing the IORESOURCE_BUSY. As mentioned, if we expect the PCI
>> BAR's to work with the e820 resources, then BUSY really is simply not
>> right any more. Not that I think it should matter either..
>>
>> The ones that are added _early_ should be IORESOURCE_BUSY (ie the ones
>> that cover RAM), but the others we now expect to nest with PCI BARs.
>
> not all. some are MMCONF, some are for GART, and some for fixed lapic,
> and fixed ioapic, and fixed HPET.

we may not need put reserve entries from e820 into resource tree.
and only insert those sticky resources (with _BUSY) before
pci_assign_unassign and _request_region etc.

YH
