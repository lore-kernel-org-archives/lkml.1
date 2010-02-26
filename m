Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964815Ab0BZOB5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 09:01:57 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:14492 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964794Ab0BZOBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 09:01:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=KAt26vL2I9MEHB164AsdNqcaQ/IDBk+TLBkGYU+Z1RS4tyg1FzSC/xKoxQwVG9xo7n
         re2uHng/zYe1JvJsybKg7u5wZp+BnpoAbWcaBUcARktsIcNI0WiO9eI5m02yqd73WX+r
         03UpM7zu5IKQ83Veqp5KgZ61SUgw7GexPL4GU=
MIME-Version: 1.0
In-Reply-To: <201002261232.28686.elendil@planet.nl>
References: <201002261232.28686.elendil@planet.nl>
Date: Fri, 26 Feb 2010 16:01:49 +0200
X-Google-Sender-Auth: 86fc6ae24a33c219
Message-ID: <84144f021002260601o7ab345fer86b8bec12dbfc31e@mail.gmail.com>
Subject: Re: Memory management woes - order 1 allocation failures
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Mel Gorman <mel@skynet.ie>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 26, 2010 at 1:32 PM, Frans Pop <elendil@planet.nl> wrote:
> Attached a long series of order 1 (!) page allocation failures with .33-rc7
> on an arm NAS box (running Debian unstable).
>
> The first failure occurred while running aptitude (Debian package manager)
> only ~20 minutes after booting the system, and I've seen that happen twice
> before.
>
> The other failures were all 1.5 days later while rsyncing a lot of music
> files (ogg/mp3) from another box to this one.
> They occurred when I was trying to also do something in an SSH session. The
> first ones from a simple 'sudo vi /etc/exports', some of the later ones
> while creating a new SSH session from my laptop.
>
> As can be seen from the attached munin graph [1] the system has only 256 MB
> memory, but that's quite normal for a simple NAS system. Only very little
> of that was in use by apps; most was being used for cache.
> The errors occurred in the area immediately above the "Thu 12:00" label,
> where the cache increases dramatically.
>
> Isn't it a bit strange that cache claims so much memory that real processes
> get into allocation failures?

All of the failed allocations seem to be GFP_ATOMIC so it's not _that_
strange. Dunno if anything changed recently. What's the last known
good kernel for you?
