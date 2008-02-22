Return-Path: <linux-kernel-owner+w=401wt.eu-S932468AbYBVVRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468AbYBVVRT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 16:17:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756133AbYBVVRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 16:17:06 -0500
Received: from gw.goop.org ([64.81.55.164]:34272 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757421AbYBVVRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 16:17:04 -0500
Message-ID: <47BF3B10.7070402@goop.org>
Date: Fri, 22 Feb 2008 13:13:52 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [Xen-devel] [PATCH] let XEN depend on PAE
References: <47BEAB48.7050900@nets.rwth-aachen.de> <47BEFA4C.6030400@goop.org> <47BEFE55.7020703@nets.rwth-aachen.de> <47BF1B8F.5090701@goop.org> <47BF266F.5020806@nets.rwth-aachen.de>
In-Reply-To: <47BF266F.5020806@nets.rwth-aachen.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Hannemann wrote:
> Jeremy Fitzhardinge wrote:
>   
>> Arnd Hannemann wrote:
>>     
>>> This is with 2.6.24.2, but latest-git looks the same:
>>> I also tried with 2.6.23 which crashes instantly, without any output
>>> of the guest.
>>>   
>>>       
>> I'm not too surprised.  Non-PAE Xen is a bit of a rarity, and it only
>> gets tested rarely.  Chris Wright did spend some time on it a while ago,
>> but I don't know that its had any real attention since.  I've been
>> making sure non-PAE compiles, but I've been lax about testing it.
>> This is the first usermode exec, I guess?  The backtrace is a bit odd;
>> I've never seen a problem in move_page_tables before.
>>     
>
> Yes its trying to execute the first script in initramfs, I also tried with initramdisk
> and got a similar error. (move_page_tables also involved)
>
>   
>> Does "xm dmesg" tell you what Xen is complaining about?  You may need to
>> compile with debug=y in Config.mk.
>>     
>
> (XEN) mm.c:645:d44 Non-privileged (44) attempt to map I/O space 00000000
>
> I will recompile with debug=y and post the output.
> If I reduce the dom0 memory with dom0_mem=200000 I see something like
> 00000080 with dom0_mem=800000 I always see 00000000.
>   

That's helpful.  Looks like the mfn is getting mushed to 0.

    J
