Return-Path: <linux-kernel-owner+w=401wt.eu-S933382AbXCOCSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933382AbXCOCSR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 22:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933383AbXCOCSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 22:18:17 -0400
Received: from gw.goop.org ([64.81.55.164]:47156 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933382AbXCOCSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 22:18:16 -0400
Message-ID: <45F8ACE8.5030704@goop.org>
Date: Wed, 14 Mar 2007 19:18:16 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Jaya Kumar <jayalk@intworks.biz>
Subject: Geode cs5530a magic (Was: Re: [PATCH] clean up mach_reboot_fixups)
References: <45F8761F.8010203@goop.org> <200703142342.13639.ak@suse.de>
In-Reply-To: <200703142342.13639.ak@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Wednesday 14 March 2007 23:24, Jeremy Fitzhardinge wrote:
>   
>> The reboot_fixups stuff seems to be a bit of a mess, specifically the
>> header is in linux/ when its a purely i386-specific piece of code.  I'm
>> not sure why it has its config option; its only currently needed for
>> "geode-gx1/cs5530a", so perhaps whatever config option controls that
>> hardware should enable this?
>>     
>
> Thanks. Looks good.

It looks like a cs5530a is a PATA driver in drivers/ata/pata_cs5530.c. 
Seems to me the cleanest fix is to register a reboot notifier in the
driver and have it do the magic rather than have the special
mach_reboot_fixups mechanism at all.

Assuming it needs to be done at all...

Alan? Jaya?

    J
