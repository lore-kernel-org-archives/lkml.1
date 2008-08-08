Return-Path: <linux-kernel-owner+w=401wt.eu-S1755461AbYHHJsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461AbYHHJsL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 05:48:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753403AbYHHJr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 05:47:57 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:54111 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064AbYHHJr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 05:47:57 -0400
X-IronPort-AV: E=Sophos;i="4.31,327,1215388800"; 
   d="scan'208";a="1334077"
Message-ID: <489C169F.9030907@eu.citrix.com>
Date: Fri, 08 Aug 2008 10:49:19 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: kernel list <linux-kernel@vger.kernel.org>, krzysztof.h1@poczta.fm,
       adaplas@pol.net, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: 2.6.27-rc1: softcursor behaviour changed
References: <20080805212004.GA1592@elf.ucw.cz> <20080807085733.GA1560@elf.ucw.cz> <489AD9C1.8020405@eu.citrix.com> <20080807220755.GA11460@elf.ucw.cz>
In-Reply-To: <20080807220755.GA11460@elf.ucw.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Aug 2008 09:47:55.0493 (UTC) FILETIME=[D52CD150:01C8F93B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:

>> The problem is not a matter of taste but a matter of correctness: the
>> build_attr function in drivers/char/vt.c stores the blink attribute as
>> the forth bit of the background color.
>> Then in fbcon we are interpreting the same forth bit of the background
>> color as intensity bit.
> 
> ...which works pretty well. We can't reasonably blink in fbcon, so we
> highlight it with bright background, instead. Even old VGA had option
> to do that.
> 
>> My patch fixes that.
> 
> AFAICS high bit is now completely ignored now. That makes it
> useless...

- an application wants to do X
- I don't like X and X is not even implemented here
- let's do Y instead!

I think this is not the correct way of doing things, we could implement
blinking in fbcon instead.
In fact I posted another patch a while ago to implement blinking in
fbcon, but it wasn't accepted, not sure why yet :)
Maybe I'll try to talk with the fbcon devs to understand the problem
better, and reasonably soon you'll be able to see your blinking cursor
in fbcon.

> For example I can no longer see my cursor.
> 
> So, if 2.6.26 behaviour is "incorrect", can you show example where it
> matters, and how your patch "helps"?
> 


We have some ncurses applications that print a blinking white on blue
warning message.
Without the patch the message is static and with a pink background
(applications can change color settings, if they do that only for the
normal colors and not for the intensive colors because they think they
are not using them, this is what happens).

