Return-Path: <linux-kernel-owner+w=401wt.eu-S965341AbXA3Nib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965341AbXA3Nib (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 08:38:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965357AbXA3Nia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 08:38:30 -0500
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:43571 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965341AbXA3Nia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 08:38:30 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=Utu97zRN7C8THZ1v0qQe8pHVc34WDrlZgnJYhB3f5ofiqAunOXAvoXevFc4vvBRTAqtsEC8s05BGF3mg1VXbRrfLCoelp/qcpODHw1cC2nIp7tRsilAy1zJ2h1YiJLwnuzLs2qVGXeyYzHucUwolECByYklKLBBWpAL7KWASxV0=  ;
X-YMail-OSG: qapu4CoVM1kG6_pvVnQoWx90PC6UjI4WFYEpJ9bqCSSp2HgGcG9yauDeVgC.TAXgwG7Yx8qcUE5oYqsZnbaXKEVadSyQuo2hSU5e..tMUDXPz55EqXA-
Message-ID: <45BF4A3A.2040001@yahoo.com.au>
Date: Wed, 31 Jan 2007 00:38:02 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Jean Delvare <jdelvare@suse.de>
CC: Sergey Vlasov <vsu@altlinux.ru>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Daniel Drake <dsd@reactivated.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] VIA IRQ quirk breakage fix
References: <45B6A94A.3010006@yahoo.com.au> <200701300854.06083.jdelvare@suse.de> <20070130144701.e793c222.vsu@altlinux.ru> <200701301325.58843.jdelvare@suse.de>
In-Reply-To: <200701301325.58843.jdelvare@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare wrote:
> Hi Sergey,
> 
> Le Mardi 30 Janvier 2007 12:47, Sergey Vlasov a écrit :
> 

>>The VT82C686 is very different from other devices, because it is
>>a PCI chip, and its device number is determined by IDSEL wiring.
>>Google shows that several different assignments are in use:
>>
>>00:01.0:
>>http://ozlabs.org/pipermail/linuxppc-embedded/2005-January/016642.html
>>(but that's PPC)
>>
>>00:04.0: http://www.cs.helsinki.fi/linux/linux-kernel/2001-36/0083.html
>>00:05.0: http://lkml.org/lkml/2003/12/11/78
>>00:07.0: this example and lots of other links
>>00:14.0: http://forum.freespire.org/showthread.php?t=2998
> 
> 
> Ah, OK. Thanks for the exhaustive search and explanation. This explains
> why Alan and Nick disagreed on the device number.

...

> Yes, this sounds like the right thing to do. So here comes the third
> (and hopefully last) iteration of the patch:

Thanks Jean, this patch works fine for me.

Is this 2.6.20 material? Might it cause more regressions than it fixes?

Andrew, can you pick up this patch in place of the old one you got
(fix-via-irq-quirk-breakage.patch). It was sent to lkml just now.

> Fix VIA quirks that were recently broken by Alan Cox in the upstream
> kernel (commit 1597cacbe39802d86656d1f2e6329895bd2ef531).
> 
> My understanding is that pci_find_present() doesn't work yet at the
> time the quirks are run. So I used a two-step quirk as is done for
> some other quirks already. First we detect the VIA south bridges
> and set the right low and high device limits, then we are ready to
> actually run the quirks on the affected devices.
> 
> Signed-off-by: Jean Delvare <jdelvare@suse.de>
> Acked-by: Alan Cox <alan@redhat.com>
> ---
>  drivers/pci/quirks.c |   80 +++++++++++++++++++++++++++-----------------------
>  1 files changed, 44 insertions(+), 36 deletions(-)

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
