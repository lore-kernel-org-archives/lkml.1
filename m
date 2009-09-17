Return-Path: <linux-kernel-owner+w=401wt.eu-S1753132AbZIQW01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132AbZIQW01 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 18:26:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752552AbZIQW00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 18:26:26 -0400
Received: from mail-yx0-f199.google.com ([209.85.210.199]:37112 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496AbZIQW0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 18:26:25 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.01.0909171322210.4950@localhost.localdomain>
References: <m1y6oef08k.fsf@fess.ebiederm.org> <20090917125759.GA4045@kroah.com> 
	<m1ab0tcwep.fsf@fess.ebiederm.org> <20090917185306.GA28635@elte.hu> 
	<ac3eb2510909171218k4963fc7dv8fb7549007e511aa@mail.gmail.com> 
	<alpine.LFD.2.01.0909171322210.4950@localhost.localdomain>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 18 Sep 2009 00:26:14 +0200
Message-ID: <ac3eb2510909171526ga51ecfag74af1a34a0437189@mail.gmail.com>
Subject: Re: [bug] /etc/profile: line 30: /dev/null: Permission denied (Was: 
	Re: [PATCH] Remove broken by design and by implementation devtmpfs 
	maintenance disaster)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 22:26, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, 17 Sep 2009, Kay Sievers wrote:

> That may be "not supported", but the point is, we want to make the kernel
> be as self-sufficient as possible, and the whole _point_ of this devtmpfs
> seemed to be to increase self-sufficiency rather than decrease it by
> requiring 'udev' to have run very very early.

Yes, that's the point. We could try to push the limit even higher and
try to run without udev. A few embedded and linux-on-cell-phone people
already asked for the same thing.

> If you have udev running really early, then what's the point of devtmpfs?
> You might as well just have udev and tmpfs.

It still simplifies the bootstrapping of an empty mounted /dev tmpfs,
and makes the node creation synchronous, unlike udev. It also makes
rescue very easy and reliable. It solves a bunch of problems, at least
for system-level privileged tasks, like module loading with immediate
device access after modprobe returns.

> So I suspect /dev/null and /dev/zero should be special - just make them
> have 0666 permissions. Because they really _are_ special, and no other
> permissions ever make sense for them.

That's true. I guess there are a few more devices that need special
permissions. We could make that happen, so people could probably run a
system without udev on top, at least in a controlled environment. For
distros it's not that interesting, they will need all the hotplug
handling, and all the stuff that plugs into udev's event mechanisms.
We only thought about bootup and root users for now, but that could be
changed, if it makes things easier.

Kay
