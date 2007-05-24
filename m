Return-Path: <linux-kernel-owner+w=401wt.eu-S1753275AbXEXUqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbXEXUqu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 16:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751067AbXEXUqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 16:46:43 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:40994 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841AbXEXUqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 16:46:43 -0400
Message-ID: <4655F9B8.8080703@drzeus.cx>
Date: Thu, 24 May 2007 22:46:48 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Olaf Hering <olaf@aepfle.de>
CC: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Make prepare_namespace() wait for devices
References: <4655834F.3050301@drzeus.cx> <20070524183509.GA30518@aepfle.de>
In-Reply-To: <20070524183509.GA30518@aepfle.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Olaf Hering wrote:
> On Thu, May 24, Pierre Ossman wrote:
>
>   
>> init: wait for asynchronously scanned block devices
>>     
>
> init/do_mounts.c:242:__setup("rootdelay=", root_delay_setup);
>
> Why does that not work for you and how does your patch fix it?
>   

The problem isn't really mine, I just got the ball when it came to
fixing it. :)

The problem with rootdelay= is that it's a hammer when the problem
requires a screw driver. In order to get reliability, you need to whack
it hard and give it a long delay. But that has the unpleasant side
effect of having the boot taking way much more time than it really needs.

The original thread is here:

http://marc.info/?t=117879392100022&r=1&w=2

At the end of that thread I suggest a more universal approach, which I
submitted for comments here:

http://marc.info/?t=117914570700004&r=1&w=2

I believe this is a more clean approach than forcing all subsystems to
be synchronous.

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

