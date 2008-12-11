Return-Path: <linux-kernel-owner+w=401wt.eu-S1756538AbYLKMdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538AbYLKMdd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 07:33:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755560AbYLKMdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 07:33:13 -0500
Received: from mail.inf.tu-dresden.de ([141.76.2.1]:52716 "EHLO
	mail.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755300AbYLKMdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 07:33:11 -0500
Message-ID: <494107D5.2070905@inf.tu-dresden.de>
Date: Thu, 11 Dec 2008 13:30:13 +0100
From: Mario Schwalbe <schwalbe@inf.tu-dresden.de>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Richard Purdie <rpurdie@rpsys.net>
CC: Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org,
       Mario Schwalbe <schwalbe@inf.tu-dresden.de>
Subject: Re: [PATCH] video: mbp_nvidia_bl: Fix brightness after	suspend/hibernation
References: <494026CD.5020102@inf.tu-dresden.de> <1228948313.5423.34.camel@dax.rpnet.com>
In-Reply-To: <1228948313.5423.34.camel@dax.rpnet.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Richard Purdie schrieb:
> On Wed, 2008-12-10 at 21:30 +0100, Mario Schwalbe wrote:
>> The mbp_nvidia_bl driver allows to change the display brightness on
>> Apple MacBook Pro with Nvidia graphics adapters. However, after
>> resuming from suspend the brightness is at its maximum instead of
>> the last recently used value. This patch converts the driver into a
>> platform_driver in order to register a resume hook to re-send brightness.
>> In addition, resources will be allocated through platform_driver means
>> instead of calling request_region/release_region directly.
> 
> I understand the problem, I'm not sure adding more platform devices and
> drivers into the equation is a good way to solve it.

I don't know what the problem of adding platform_drivers is. I just thought
it's a reasonable solution after looking at the drivers next to it.

> I've been thinking
> of adding suspend/resume support into the backlight core for a while and
> this would solve this problem. How about the following patch (only
> compile tested so far)?

That looks like it could work. (Well, I didn't even compile the code.)
However, i'd like to note:

1. props.flags and ops->flags is somewhat confusing. i had to read several
   times to see the difference. what about calling props.flags props.state?
   what it actually is.
2. props.power, props.fb_blank, and the newly props.flags looks quite confusing
   to me. what is it all used for? they are all about the current state?
3. Right now it's possible to add code specific for the resume process, e.g.,
   to circumvent hardware bugs. after applying your patch the drivers won't
   see a difference to normal updates anymore, due to backlight_resume clearing
   the BL_CORE_SUSPENDED flag before calling backlight_update_status, and there's
   no 'resume in progress' flag. i wouldn't need it anyway, but maybe someone else.

What about the remaining patches for 5th gen models support? They are against
the last patch. Am I supposed to send them now? Or wait and adapt them to your
patch once it's in Linus's tree (the one I cloned).

ciao,
Mario

-- 
 Wo das Chaos auf die Ordnung trifft, gewinnt meist das Chaos,
 weil es besser organisiert ist.
     - Friedrich Nietzsche -

--
    _____    ________
   /     \  /   ____/  Mario Schwalbe
  /  \ /  \ \____  \
 /    Y    \/       \  eMail: schwalbe@inf.tu-dresden.de,
 \____|__  /______  /         ms790178@inf.tu-dresden.de
         \/       \/

          key ID: 7DA9 DAFF
      public key: https://www1.inf.tu-dresden.de/~ms790178/key.asc
 key fingerprint: 2979 AA20 4A93 B527 90CC  45E5 4B28 511A 7DA9 DAFF
