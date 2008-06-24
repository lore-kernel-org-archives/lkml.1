Return-Path: <linux-kernel-owner+w=401wt.eu-S1758565AbYFXGPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758565AbYFXGPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 02:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751992AbYFXGPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 02:15:43 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:27711 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbYFXGPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 02:15:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=fOzI+Hf5qLAORdAn0KYi9csxSnCrvfHHZ2OqgvkL52nwgvRFC0fm87gaLTK4ubWEnC
         g8vk14+TBf7RaB/8/r5n+qVobnwlKpJSCxZGCmwIKC2ZEcOzpjofStHbx7+8LD2OCEi1
         dZ+icmygJI7WzFyXMcG96w6SscHV3RCCFKAmg=
Message-ID: <84144f020806232315q1ee89300v9a96384fb64492df@mail.gmail.com>
Date: Tue, 24 Jun 2008 09:15:41 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Joris van Rantwijk" <jorispubl@xs4all.nl>
Subject: Re: Physical memory disappeared from /proc/meminfo
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <2c84b89ef40f92173a026b8d95e889ad@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2c84b89ef40f92173a026b8d95e889ad@xs4all.nl>
X-Google-Sender-Auth: e07ef50ee27b5d21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2008 at 8:09 AM, Joris van Rantwijk <jorispubl@xs4all.nl> wrote:
> My system got into a situation where a lot of physical memory is
> in use. I want to know where this memory is being used, but it
> seems to have become untraceable somehow.
>
> My total physical memory is 1 GB.
> Adding up all VSZ numbers from "ps auxw" gets me to about 75 MB,
> so I should have a lot of free memory but I don't see it.
>
> My kernel is Linux 2.6.25.4 for x86_64 with a 32-bit userland.
> I disabled swap to make it easier to investigate this issue.
>
> One problem is that I can't really make sense of /proc/meminfo.
> As far as I understand the numbers, I find that about 640 MB is
> unaccounted for.
>
> For example I would expect that
> MemTotal = MemFree + Buffers + Cached + AnonPages + Mapped + Slab.
>
> Is that a valid assumption?

Yes.

> Why does it not hold for my machine?
> Is this a bug in the memory statistics?
> What part of the system is using all this untraceable memory?

Likely a driver leaking full pages. Your config and dmesg would be
helpful. Last time I bumped into this, though, was with a proprietary
module...

> /proc/meminfo:
> MemTotal:     996320 kB
> MemFree:       67708 kB
> Buffers:       17716 kB
> Cached:        62412 kB
> SwapCached:        0 kB
> Active:        27320 kB
> Inactive:      58720 kB
> SwapTotal:         0 kB
> SwapFree:          0 kB
> Dirty:            12 kB
> Writeback:         0 kB
> AnonPages:      5932 kB
> Mapped:         3916 kB
> Slab:         193560 kB
> SReclaimable:  26076 kB
> SUnreclaim:   167484 kB
> PageTables:      464 kB
> NFS_Unstable:      0 kB
> Bounce:            0 kB
> CommitLimit:  498160 kB
> Comitted_AS:   15536 kB
> VmallocTotal: 34359738367 kB
> VmallocUsed:     600 kB
> VmallocChunk: 34359736326 kB
>
> Please help.
>
> Joris.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
