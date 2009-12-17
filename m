Return-Path: <linux-kernel-owner+w=401wt.eu-S1764755AbZLQNdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764755AbZLQNdT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 08:33:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764740AbZLQNdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 08:33:14 -0500
Received: from 007.netroom.de ([194.0.247.207]:13393 "EHLO 007.netroom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764742AbZLQNdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 08:33:12 -0500
Message-ID: <4B2A3312.104@draisberghof.de>
Date: Thu, 17 Dec 2009 14:33:06 +0100
From: Josua Dietze <digidietze@draisberghof.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Dan Williams <dcbw@redhat.com>,
       Stefan Seyfried <stefan.seyfried@googlemail.com>,
       linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
       Stefan Seyfried <seife@sphairon.com>
Subject: Re: [PATCH] move eject code from zd1211rw to usb-storage
References: <1260878800-14691-1-git-send-email-stefan.seyfried@googlemail.com> <1260993048.2179.68.camel@localhost.localdomain> <20091216195258.GJ16426@one-eyed-alien.net> <200912171402.42168.oliver@neukum.org>
In-Reply-To: <200912171402.42168.oliver@neukum.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum schrieb:

> Am Mittwoch, 16. Dezember 2009 20:52:58 schrieb Matthew Dharm:
>>>> If this is the case, then the only reasonable answer to is to push the
>>>> modeswitch code for both into udev and out of the kernel.  It will take
>>> you mean usb_modeswitch, not udev actually.
>> That is correct; I had mis-typed.  Tho, the actual implementation is udev
>> calling usb_modeswitch and/or eject.
> 
> Can storage tell the devices apart so that it knows which ones to leave
> to the kernel solution and which devices to accept so that udev can
> issue an eject command?

If you are thinking about the two specific devices at hand there is 
no need to tell them apart. Same IDs on plugin, same switching 
procedure, different IDs on return, different drivers take care.

If you are thinking generally, there is already a case when:
same IDs on plugin, different switching procedures.
See "option_ms.c"; the solution was to check for SCSI ID strings and 
only act if there's a match. I filed this patch to enable userspace 
handling for a different device with the same IDs.

This is also the way usb_modeswitch (via wrapping script) is 
handling ambiguities right now.
(BTW, the next version has no more compiler warnings. No big deal.)


Cheers,
Josua
