Return-Path: <linux-kernel-owner+w=401wt.eu-S1753925AbYISW2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbYISW2h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 18:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750945AbYISW23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 18:28:29 -0400
Received: from gw.goop.org ([64.81.55.164]:59817 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876AbYISW22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 18:28:28 -0400
Message-ID: <48D4278C.8020409@goop.org>
Date: Fri, 19 Sep 2008 15:28:28 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Bryan Donlan <bdonlan@gmail.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: Kernel OOPS and panic on boot in advantech watchdog init
References: <3e8340490809181902q31e8227fq72a7bea688b594c1@mail.gmail.com> <20080919113356.111ce79f@lxorguk.ukuu.org.uk>
In-Reply-To: <20080919113356.111ce79f@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> Looks like yet another Xen bug
>   

No, we've been over this before.

>> [   30.328280] BUG: unable to handle kernel paging request at d6023220
>> [   30.332244] IP: [<c021f6f3>] xen_set_pte+0x3/0x10
>>     
>
> sc520 tries to make an ioremap to read 0xfffefcb0
>
>   
>> [   30.332244]  [<c037be42>] ioremap_page_range+0x1e2/0x280
>> [   30.332244]  [<c023d311>] __ioremap_caller+0x1e1/0x340
>>     
>
> The Xen glue should have either permitted the mapping or failed the
> ioremap attempt with NULL.

Xen glue doesn't get in at that level.  The first Xen knows about the
mapping is the attempt to set a pte with meaningless contents.

I still think the sc520 driver should make some rudimentary attempt to
see if its actually running on a relevant system (ie, an AMD Elan)
before creating iomappings.  I don't know if DMI, cpuid or some other
mechanism would be best though.

    J
