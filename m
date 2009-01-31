Return-Path: <linux-kernel-owner+w=401wt.eu-S1754978AbZAaSMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978AbZAaSMQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 13:12:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbZAaSMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 13:12:00 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:43121 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbZAaSL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 13:11:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=vwfJcsTYfZiT+4Z0GUK6js5AVqWZYSFIuq36KYLuJuypVJ9RV4eCfVsTbHxIFTx5E9
         3xX+D3WZa5w5cRg6op42m9ZDelIPVM7e0eGFnMfwYJm4PhtGFnSsQxo1ml/4IOt7I9XR
         ymSSh6gm6tUha1+Iw+4w1daZrkrok2NVvdLV0=
Message-ID: <4984946B.5000205@gmail.com>
Date: Sat, 31 Jan 2009 19:11:55 +0100
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Andrey Borzenkov <arvidjaar@mail.ru>,
       Linux Frame Buffer Device Development 
	<linux-fbdev-devel@lists.sourceforge.net>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       linux-pm@lists.linux-foundation.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [Linux-fbdev-devel] [2.6.29-rc2] fb_mmap: circular locking dependency
 on hibernation
References: <200901272137.57757.arvidjaar@mail.ru> <Pine.LNX.4.64.0901291009220.13600@anakin> <200901300716.06137.arvidjaar@mail.ru> <498485E0.4080501@gmail.com> <Pine.LNX.4.64.0901311843450.21273@anakin>
In-Reply-To: <Pine.LNX.4.64.0901311843450.21273@anakin>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009-01-31 18:44, Geert Uytterhoeven wrote:
> On Sat, 31 Jan 2009, Andrea Righi wrote:
>> On 2009-01-30 05:15, Andrey Borzenkov wrote:
>>> On 29 of January 2009 12:10:11 Geert Uytterhoeven wrote:
>>>> On Tue, 27 Jan 2009, Andrey Borzenkov wrote:
>> fbcon: avoid circular locking dependency between fb_info->lock and mm->mmap_sem
>>
>> In fbcon notifier the handler for FB_EVENT_SET_CONSOLE_MAP doesn't need
>> to hold fb_info->lock.
>>
>> Simply unlock it before calling set_con2fb_map(), that could try to
>> acquire mm->mmap_sem to avoid a circular locking dependency with
>> fb_mmap() (that acquires mm->mmap_sem -> fb_info-lock).
> 
> However, set_con2fb_map() accesses the array of fb_info pointers
> registered_fb[], which seems to be a bit unsafe now the BKL is no longer held.

mmmh.. not sure about that, registered_fb[] was never accessed with
fb_info->lock held, see register/unregister_framebuffer().

But maybe this is another issue, and anyway, the array and also
num_registered_fb don't seem to be protected at all...

-Andrea
