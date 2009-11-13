Return-Path: <linux-kernel-owner+w=401wt.eu-S1752845AbZKMGE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845AbZKMGE1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 01:04:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751754AbZKMGEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 01:04:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:32928 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbZKMGEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 01:04:21 -0500
Message-ID: <4AFCF6D6.6040607@zytor.com>
Date: Thu, 12 Nov 2009 22:04:06 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: "Ma, Ling" <ling.ma@intel.com>
CC: Pavel Machek <pavel@ucw.cz>, "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] [X86] performance improvement for memcpy_64.S by
 fast string.
References: <1257500482-16182-1-git-send-email-ling.ma@intel.com> <4AF457E0.4040107@zytor.com> <4AF4784C.5090800@zytor.com> <8FED46E8A9CA574792FC7AACAC38FE7714FCF772C9@PDSMSX501.ccr.corp.intel.com> <20091112121604.GC1394@ucw.cz> <8FED46E8A9CA574792FC7AACAC38FE7714FEB070EE@PDSMSX501.ccr.corp.intel.com>
In-Reply-To: <8FED46E8A9CA574792FC7AACAC38FE7714FEB070EE@PDSMSX501.ccr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2009 09:33 PM, Ma, Ling wrote:
>> Well, so you are running cache hot and it is only a win on huge
>> copies... how common are those?
>>
> Hi Pavel Machek
> Yes, we intend to introduce movsq for huge hot size(over 1024bytes)
> and avoid regression for less 1024bytes. I guess you suggest using
> prefetch instruction for cold data (if I was wrong please correct me).
> memcpy don't know whether data has been in cache or not,
> so only when copy size is over (first level 1 cache)/2 and lower
> (last level cache)/2 , prefetch will get benefit. Currently first
> level cache size of most cpus is around 32KB, so it is useful for prefetch 
> when copy size is over 16KB, but as H. Peter Anvin mentioned in last email,
> over 16KB copy in kernel is rare.
> 

What it sounds to me is that for Nehalem, we want to use memcpy_c for >=
1024 bytes and the old code for < 1024 bytes; for Core2 it might be the
exact opposite.

Either way, whatever we do should use the appropriate static replacement
mechanism.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

