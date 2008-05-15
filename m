Return-Path: <linux-kernel-owner+w=401wt.eu-S1754098AbYEOCLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbYEOCLc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 22:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751204AbYEOCLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 22:11:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58079 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbYEOCLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 22:11:22 -0400
Date: Wed, 14 May 2008 22:10:54 -0400 (EDT)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Trent Piepho <xyzzy@speakeasy.org>
cc: Adrian Bunk <bunk@kernel.org>, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org, linux-dvb-maintainer@linuxtv.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [v4l-dvb-maintainer] [GIT PATCHES] V4L/DVB fixes for 2.6.26
In-Reply-To: <Pine.LNX.4.58.0805141749470.23876@shell4.speakeasy.net>
Message-ID: <Pine.LNX.4.64.0805142154410.12257@bombadil.infradead.org>
References: <20080514114910.4bcfd220@gaivota> <20080514165434.GC22115@cs181133002.pp.htv.fi>
 <20080514145554.10e3385c@gaivota> <20080514193822.GA21795@cs181133002.pp.htv.fi>
 <Pine.LNX.4.58.0805141749470.23876@shell4.speakeasy.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2008, Trent Piepho wrote:

> On Wed, 14 May 2008, Adrian Bunk wrote:
>>> It would be nice if you could help on fixing those issues.
>>>
>>> One dependency that will probably solve is to add "depends on VIDEO_MEDIA &&
>>> I2C" to all devices that are hybrid (bttv, saa7134, cx88, pvrusb, em28xx).
>>
>> What about converting all dependencies on I2C to select's?
>
> Doesn't that just increase the problems with failing to have correct
> dependencies?  Anything that selects I2C needs to depend on everything I2C
> depends on.
>

True. Currently, the only dependency is this one:

menuconfig I2C
         tristate "I2C support"
         depends on HAS_IOMEM

HAS_IOMEM is true on every architecture, except usermode linux (um) and 
s390. Also, Multimedia menu is already dependent of HAS_IOMEM, so, this 
currently won't add any extra complexity.

I agree that this may add an extra issue to concern, since future changes 
at I2C dependencies will need to be addressed.

-- 
Cheers,
Mauro Carvalho Chehab
http://linuxtv.org
mchehab@infradead.org
