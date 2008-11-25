Return-Path: <linux-kernel-owner+w=401wt.eu-S1753133AbYKYX0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133AbYKYX0E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 18:26:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752356AbYKYXZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 18:25:53 -0500
Received: from gw.goop.org ([64.81.55.164]:49159 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348AbYKYXZw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 18:25:52 -0500
Message-ID: <492C897E.1010509@goop.org>
Date: Tue, 25 Nov 2008 15:25:50 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Ian Campbell <ijc@hellion.org.uk>
CC: Stable Kernel <stable@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       =?UTF-8?B?RGFuaWVsIFNjaHLDtmRlcg==?= <mail@dschroeder.info>,
       Yinghai Lu <yinghai@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Change 5c371b31be3203 in stable breaks Xen
References: <492C6D8D.3040600@goop.org> <1227654364.27529.3.camel@localhost.localdomain>
In-Reply-To: <1227654364.27529.3.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Campbell wrote:
> On Tue, 2008-11-25 at 13:26 -0800, Jeremy Fitzhardinge wrote:
>   
>> I have a report of Xen breaking between 2.6.27.5 and .6.  I bisected
>> it 
>> down to change:
>>
>> commit 5c371b31be32033b0a4a993431484da8a2305369
>> Author: Yinghai Lu <yhlu.kernel@gmail.com>
>> Date:   Mon Sep 22 02:52:26 2008 -0700
>>
>>     x86: fix CONFIG_X86_RESERVE_LOW_64K=y
>>    
>>     commit 2216d199b1430d1c0affb1498a9ebdbd9c0de439 upstream
>>     
>
> Looks like 5dc64a3442b98eaa0e3730c35fcf00cf962a93e7 might be needed in
> stable too?
>   

Ah, yes, that looks like the right fix.  I'll see if it helps.

    J

>         
>         commit 5dc64a3442b98eaa0e3730c35fcf00cf962a93e7
>         Author: Ian Campbell <Ian.Campbell@citrix.com>
>         Date:   Fri Oct 10 11:27:38 2008 +0100
>         
>             xen: do not reserve 2 pages of padding between hypervisor and fixmap.
>             
>             When reserving space for the hypervisor the Xen paravirt backend adds
>             an extra two pages (this was carried forward from the 2.6.18-xen tree
>             which had them "for safety"). Depending on various CONFIG options this
>             can cause the boot time fixmaps to span multiple PMDs which is not
>             supported and triggers a WARN in early_ioremap_init().
>             
>             This was exposed by 2216d199b1430d1c0affb1498a9ebdbd9c0de439 which
>             moved the dmi table parsing earlier.
>                 x86: fix CONFIG_X86_RESERVE_LOW_64K=y
>             
>                 The bad_bios_dmi_table() quirk never triggered because we do DMI setup
>                 too late. Move it a bit earlier.
>             
>             There is no real reason to reserve these two extra pages and the
>             fixmap already incorporates FIX_HOLE which serves the same
>             purpose. None of the other callers of reserve_top_address do this.
>
>
>   

