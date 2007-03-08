Return-Path: <linux-kernel-owner+w=401wt.eu-S933287AbXCHUpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933287AbXCHUpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 15:45:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933297AbXCHUpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 15:45:45 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:49187 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933287AbXCHUpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 15:45:43 -0500
Date: Thu, 8 Mar 2007 21:43:46 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Christoph Hellwig <hch@infradead.org>
cc: Deepak Saxena <dsaxena@plexity.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix building kernel under Solaris
In-Reply-To: <20070308083543.GA5213@infradead.org>
Message-ID: <Pine.LNX.4.61.0703082142240.521@yvahk01.tjqt.qr>
References: <20070306180940.GA3240@plexity.net> <20070307094229.GG14863@infradead.org>
 <Pine.LNX.4.61.0703072342310.2448@yvahk01.tjqt.qr> <20070308083543.GA5213@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 8 2007 08:35, Christoph Hellwig wrote:
>On Wed, Mar 07, 2007 at 11:45:11PM +0100, Jan Engelhardt wrote:
>> 
>> On Mar 7 2007 09:42, Christoph Hellwig wrote:
>> >>  #include <sys/time.h>
>> >>  #include <sys/ioctl.h>
>> >>  #include <sys/types.h>
>> >> +#ifndef __sun__
>> >>  #include <asm/types.h>
>> >>  #endif
>> >> +#endif
>> >
>> >So if solaris doesn't need it, why do we need it on Linux?
>> 
>> For __s32 and __s16.
>
>We shouldn't use those from asm/types.h on Linux either, but
>get them consitantly by defining them to the C99 or BSD types
>from the libc headers.

It's a bit icky. file2alias.c includes "../../include/linux/input.h" and it is
_input.h_ that requires __s16/__s32 and hence includes <asm/types.h>.
If you ask me, it's file2alias.c that's broken.


Jan
-- 
