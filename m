Return-Path: <linux-kernel-owner+w=401wt.eu-S1754879AbYLELsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879AbYLELsr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 06:48:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751283AbYLELsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 06:48:37 -0500
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:36922 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750895AbYLELsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 06:48:36 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AusAAAujOEnDDR8P/2dsb2JhbAAIzwqDBQ
Message-ID: <49391512.4000604@belbone.be>
Date: Fri, 05 Dec 2008 12:48:34 +0100
From: =?ISO-8859-1?Q?C=E9dric_Godin?= <cedric@belbone.be>
User-Agent: Thunderbird 2.0.0.18 (X11/20081121)
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: Keith Packard <keithp@keithp.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Xorg crash at first start
References: <4937E87C.6030106@belbone.be> <21d7e9970812042027w13271ceas91ecab87aa60562e@mail.gmail.com>
In-Reply-To: <21d7e9970812042027w13271ceas91ecab87aa60562e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Airlie wrote:
> On Fri, Dec 5, 2008 at 12:26 AM, Cédric Godin <cedric@belbone.be> wrote:
>   
>> Hello,
>>
>> With the v2.6.28-rc7-105-gfeaf384 kernel, when booting my compaq with
>> attached config, the screen switches in graphical mode but then switches
>> back in textual mode with an 'irq10 nobody cared' error in dmesg (attached).
>>
>> If I restart kdm by hand, all is ok (i have my kdm) but the error yet
>> appears in dmesg (at each X start in fact).
>>
>> I bisected the problem (git bisect log attached) and found the following
>> commit as "culprit" :
>>
>> commit 52440211dcdc52c0b757f8b34d122e11b12cdd50
>> Author: Keith Packard <keithp@keithp.com>
>> Date:   Tue Nov 18 09:30:25 2008 -0800
>>
>>    drm: move drm vblank initialization/cleanup to driver load/unload
>>
>>    drm vblank initialization keeps track of the changes in driver-supplied
>>    frame counts across vt switch and mode setting, but only if you let
>> it by
>>    not tearing down the drm vblank structure.
>>
>>    Signed-off-by: Keith Packard <keithp@keithp.com>
>>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>>
>> Reverting it brings back my X screen at first start.
>>     
>
> Just for testing, can you try without using vesafb....
>
> so remove the vga= line from the commandline or build the kernel
> without vesafb support.
>   
I can confirm the problem without vesafb
> Dave.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   

Cedric
