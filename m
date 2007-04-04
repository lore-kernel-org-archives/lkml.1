Return-Path: <linux-kernel-owner+w=401wt.eu-S2992602AbXDDFKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992602AbXDDFKY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 01:10:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992617AbXDDFKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 01:10:24 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:56335 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992602AbXDDFKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 01:10:22 -0400
Message-ID: <4613330C.1020701@cosmosbay.com>
Date: Wed, 04 Apr 2007 07:09:32 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Ulrich Drepper <drepper@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
Subject: Re: getting processor numbers
References: <461286D6.2040407@redhat.com> <Pine.LNX.4.64.0704031152370.23808@alien.or.mcafeemobile.com> <4612ABD7.3000201@redhat.com> <4612F1F0.5070209@zytor.com> <4612F2BF.7080704@goop.org> <4612F394.6040105@zytor.com>
In-Reply-To: <4612F394.6040105@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Wed, 04 Apr 2007 07:09:41 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin a écrit :
> Jeremy Fitzhardinge wrote:
>> H. Peter Anvin wrote:
>>> Sounds like it would need a device which can be waited upon for changes.
>>
>> A vdso-like shared page could have a futex in it.
> 
> Yes, but a futex couldn't be waited upon with a bunch of other things as 
> part of a poll or a select.  The cost of reading the information is 
> minimal.
>

There is one thing that always worried me.

Intel & AMD manuals make clear that mixing data and program in the same page 
is bad for performance.

In particular, x86_64 vsyscall put jiffies and other vsyscall_gtod_data_t 
right in the midle of code. That is certainly not wise.

A probably sane implementation should use two pages, one for code, one for data.

