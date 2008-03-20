Return-Path: <linux-kernel-owner+w=401wt.eu-S1163459AbYCTAhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163459AbYCTAhc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934322AbYCTAQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 20:16:54 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:38180 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S944094AbYCTAQv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 20:16:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=qZrWXhXdTsb5f8FxLHn7COPZfLs4t+/KcLOMPpzJVB2kYVBB8H48vUJAkVls10ZHv/K+453MaYZWT0YYyQiDbt1nVUYK4bSiMXBxYQ7HkCDQt7sk2HnffmG8KLNKzDBoJmV8074gORtQcqaJj1pZHXKQjOIgr9NyTUEBarZQlPI=
Date: Thu, 20 Mar 2008 01:15:20 +0100
From: Diego Calleja <diegocg@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH prototype] [0/8] Predictive bitmaps for ELF executables
Message-Id: <20080320011520.60e151be.diegocg@gmail.com>
In-Reply-To: <20080319020440.80379d50.akpm@linux-foundation.org>
References: <20080318209.039112899@firstfloor.org>
	<20080318003620.d84efb95.akpm@linux-foundation.org>
	<20080318141828.GD11966@one.firstfloor.org>
	<20080318095715.27120788.akpm@linux-foundation.org>
	<20080318172045.GI11966@one.firstfloor.org>
	<20080318104437.966c10ec.akpm@linux-foundation.org>
	<20080319083228.GM11966@one.firstfloor.org>
	<20080319020440.80379d50.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Wed, 19 Mar 2008 02:04:40 -0700, Andrew Morton <akpm@linux-foundation.org> escribió:

> Assuming that all users have the same access pattern might be inefficient,
> a little bit.  There might be some advantage to making it per-user, dunno.

In the Dark Side of operating systems, the prefetching system they use
can log several access patterns for a single executable, because a single
executable can have different behaviours even for the same user, depending
on what parameters the executable is passed and what COM machinery it
uses. For example, wmplayer.exe can play a dvd, rip a CD, listen to a music
stream, etc...diferent usages, different access patterns. Linux probably faces
the same problem (bash, cat...)

A alternative design for a userspace solution that doesn't needs LD_PRELOAD
is to use CONFIG_PROC_EVENTS to get notifications of what processes are
started, which can be used to poll its /proc files or try to preload data
(asynchronously, and a bit hacky maybe).

But if a kernel patch is really needed to implement this properly, maybe
it'd be worth to take a look at the prefetch project that the Ubuntu guys
are apparently going to merge in the next ubuntu development release (8.10)...
https://wiki.ubuntu.com/DesktopTeam/Specs/Prefetch

There are even kernel patches:
http://code.google.com/p/prefetch/source/browse/tags/soc2007-end/trunk/kernel-patches/2.6.22/submitted/0001-prefetch-core.diff
http://code.google.com/p/prefetch/source/browse/tags/soc2007-end/trunk/kernel-patches/2.6.22/submitted/0002-prefetch-boot.diff
