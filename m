Return-Path: <linux-kernel-owner+w=401wt.eu-S1760975AbYEEUpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760975AbYEEUpA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 16:45:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754439AbYEEUov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 16:44:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38765 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753844AbYEEUou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 16:44:50 -0400
Date: Mon, 5 May 2008 16:44:46 -0400
From: Rik van Riel <riel@redhat.com>
To: "Kevin Burton" <burton@tailrank.com>
Cc: "FD Cami" <francois.cami@free.fr>, linux-kernel@vger.kernel.org
Subject: Re: Ability to limit or disable page caching?
Message-ID: <20080505164446.2ec9a543@cuia.bos.redhat.com>
In-Reply-To: <30c6373b0805051242o2f38f0a3v62bd43f4fa01559e@mail.gmail.com>
References: <30c6373b0805050012o505c0540i116a31bc1ab9ce9f@mail.gmail.com>
	<20080505131607.5556b1f2@olorin>
	<30c6373b0805051134m634efbbdn45167c1eae29df4a@mail.gmail.com>
	<20080505212831.22371732@olorin>
	<30c6373b0805051242o2f38f0a3v62bd43f4fa01559e@mail.gmail.com>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 May 2008 12:42:31 -0700
"Kevin Burton" <burton@tailrank.com> wrote:

> What's happening is that the kernel is deciding to swap out some
> memory to disk in the (false) belief that it can free some up for
> cache.
> 
> The problem is my database is already using its own cache so these are
> conflicting philosophies here which make Linux perform in a
> pathological way..

One of the problems is that the process pages (anonymous memory) and
page cache pages live on the same LRU, so the kernel cannot always
easily find the page cache pages when it is trying to evict something.

Once that is fixed, and replacement is biased towards evicting page
cache pages, the system may do the right thing by itself.

I realize that this is no quick fix for your issue, but I am working
on a split LRU patch series to make sure Linux does the right thing in
the future.

You can find the latest patch at http://people.redhat.com/riel/splitvm/
and info on the design at http://linux-mm.org/PageReplacementDesign

> What I want to do is either disable the page cache entirely or just
> tell the OS to cache at max 10% of the available memory.

I have no such tunable in my code (yet), because I would like the
kernel to do the right thing automatically.  I will post a 2.6.25 based
kernel RPM for Fedora 9 soon with the split LRU patch series applied.
If you feel like testing/breaking it, I would be interested to see if
it does indeed do the right thing for your workload or if it needs more
tuning.

-- 
All Rights Reversed
