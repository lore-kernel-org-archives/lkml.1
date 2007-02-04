Return-Path: <linux-kernel-owner+w=401wt.eu-S1752436AbXBDQuH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436AbXBDQuH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 11:50:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752438AbXBDQuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 11:50:07 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:36865 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752436AbXBDQuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 11:50:06 -0500
Message-ID: <45C60EB6.1060104@drzeus.cx>
Date: Sun, 04 Feb 2007 17:49:58 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20070131)
MIME-Version: 1.0
To: Alex Dubov <oakad@yahoo.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH] Fix up needless kmap:s
References: <147773.6460.qm@web36702.mail.mud.yahoo.com>
In-Reply-To: <147773.6460.qm@web36702.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Dubov wrote:
> The patch looks ok.
>
> However, due to certain peculiarities with memorystick and xd I have to emulate a scatter-gather
> in software. Considering that this particular aspect of implementation is the same for all card
> types on this TI chip, it can be shared by tifm_sd driver as well. In this case highmem won't be
> needed to be avoided and kmap_atomic will come back (may be).
>
>   

Fair enough. Just make sure you handle the big problem case (kmap only
maps a single page, not the entire sg entry).

> And, by the way, to what extent pagefault_enable/pagefault_disable calls are needed? They are
> present in k(u)map_atomic even for non-highmem pages/architectures.
>
>   

They tell the page fault handler that it may not sleep on a page fault.
Currently it only has the behaviour of disabling preemption though. I'd
guess it is present for non-highmem so that things behave somewhat
similar for both the highmem and non-highmem cases.

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

