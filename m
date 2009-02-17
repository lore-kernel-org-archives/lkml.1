Return-Path: <linux-kernel-owner+w=401wt.eu-S1754069AbZBQTJM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069AbZBQTJM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 14:09:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752798AbZBQTI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 14:08:56 -0500
Received: from rv-out-0506.google.com ([209.85.198.235]:36143 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbZBQTIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 14:08:55 -0500
Message-ID: <499B0B3E.3070101@gawab.com>
Date: Tue, 17 Feb 2009 11:08:46 -0800
From: Justin Madru <jdm64@gawab.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090213)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux IDE <linux-ide@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: [Bug #12263] Sata soft reset filling log
References: <sTyoMUwdm9B.A.QCH.U40lJB@chimera> <200902152221.43834.rjw@sisk.pl> <20090215223045.GC29300@elte.hu> <200902160012.57584.rjw@sisk.pl> <499983DF.5050503@ru.mvista.com> <49998480.3090408@ru.mvista.com> <499986D0.3000205@ru.mvista.com> <4999BD1A.1060101@gawab.com> <4999C195.5050905@ru.mvista.com> <4999DD31.4010504@gawab.com> <Pine.LNX.4.64.0902171102260.15234@blonde.anvils>
In-Reply-To: <Pine.LNX.4.64.0902171102260.15234@blonde.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Mon, 16 Feb 2009, Justin Madru wrote:
>   
>> Sergei Shtylyov wrote:
>>     
>>> If 12609 is truly a post-2.6.28 regression and 12263 is post-2.6.27
>>> regresssion, this just cannot be.
>>>       
>> Maybe the reporter of #12609 didn't notice/test kernels 28-rc1 to 28. Or maybe
>> the difference in hardware is
>> the issue, but the bug is still the same. Don't know.
>>     
>
> Sorry Justin, you must be confused: as Sergei says,
> #12609 and #12263 can only be different.
>
> I was one of the reporters of #12609, and I do know it's a post-2.6.28
> regression (and Larry said so too), and one fix (not the preferred fix)
> is to revert the ata_bmdma32_port_ops from 2.6.29-rc, and the preferred
> fix is to improve the ata_sff_data_xfer32() introduced in 2.6.29-rc1.
>
> 2.6.28 does not contain any ata_bmdma32_port_ops, nor ata_sff_data_xfer32(),
> not did 2.6.28-rc1 contain them.  So it is impossible for the reversion of
> the patch that introduced them to fix any problem on 2.6.28.
>
> I'm quite prepared to believe that your #12263 manifests similarly to
> #12609, and that a tip tree which contains a fix for #12609 contains
> a fix for #12263; but please, those bugs are not the same, and they
> don't have the same fix.
>
> Hugh
>
>   
Well, like I said: "[I] Don't know". I'm not a kernel developer (or even 
any developer... yet).
I'm just someone that tests the -rc kernels to see if there's any 
problems with my hardware.
I try to report any regressions to lkml, and hopefully help the developers.

To me, who has no knowledge of all these low level issues, the following 
error messages
look strikingly similar with a quick glance.

# bug 12609
# http://marc.info/?l=linux-kernel&m=123254501314058&w=4
#
ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata2.00: cmd a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
         cdb 00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
         res 51/20:03:00:00:00/00:00:00:00:00/a0 Emask 0x5 (timeout)
ata2.00: status: { DRDY ERR }
ata2: soft resetting link
ata2.00: configured for UDMA/33
ata2: EH complete

# bug 12263
# http://marc.info/?l=linux-kernel&m=122913412608533&w=4
#
ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata2.00: ST_FIRST: !(DRQ|ERR|DF)
ata2.00: cmd a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
         cdb 1e 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
         res 50/00:01:00:00:00/00:00:00:00:00/a0 Emask 0x2 (HSM violation)
ata2.00: status: { DRDY }
ata2: soft resetting link
ata2.00: configured for UDMA/33
ata2: EH complete

# bug 12609
# http://marc.info/?l=linux-kernel&m=123275478111406&w=4
#
ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata2.00: cmd a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
         cdb 00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
         res 51/20:03:00:00:00/00:00:00:00:00/a0 Emask 0x3 (HSM violation)
ata2.00: status: { DRDY ERR }
ata2: soft resetting link
ata2.00: configured for PIO4
ata2: EH complete

So, will the patch for 12609 fix my issue also, or does there need to be 
another patch?

Justin Madru
