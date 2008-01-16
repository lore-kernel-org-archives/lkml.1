Return-Path: <linux-kernel-owner+w=401wt.eu-S1753609AbYAPV3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609AbYAPV3A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 16:29:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751194AbYAPV2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 16:28:51 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45588 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917AbYAPV2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 16:28:49 -0500
Message-ID: <478E76F4.3090605@sandeen.net>
Date: Wed, 16 Jan 2008 15:28:20 -0600
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Daniel Phillips <phillips@google.com>, Pavel Machek <pavel@ucw.cz>,
       David Chinner <dgc@sgi.com>, Theodore Tso <tytso@mit.edu>,
       Al Boldi <a1426z@gawab.com>, Valerie Henson <val.henson@gmail.com>,
       Rik van Riel <riel@redhat.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Patch] document ext3 requirements (was Re: [RFD] Incremental
 fsck)
References: <200801090022.55589.a1426z@gawab.com>	<200801090740.12989.a1426z@gawab.com>	<70b6f0bf0801082345vf57951ey642e35c3d6e5194f@mail.gmail.com>	<200801091452.14890.a1426z@gawab.com>	<20080112145140.GB6751@mit.edu>	<20080113171916.GB4132@ucw.cz>	<20080113174125.5f39ac64@lxorguk.ukuu.org.uk>	<20080115201653.GA5639@elf.ucw.cz>	<20080115214325.GN155407@sgi.com>	<20080115230714.GC3573@elf.ucw.cz>	<4d47a5d10801151544k3bc50223ob69c25d8732e3f12@mail.gmail.com> <20080116001503.3c0c97cf@lxorguk.ukuu.org.uk>
In-Reply-To: <20080116001503.3c0c97cf@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> Writeback cache on disk in iteself is not bad, it only gets bad if the
>> disk is not engineered to save all its dirty cache on power loss,
>> using the disk motor as a generator or alternatively a small battery.
>> It would be awfully nice to know which brands fail here, if any,
>> because writeback cache is a big performance booster.
> 
> AFAIK no drive saves the cache. The worst case cache flush for drives is
> several seconds with no retries and a couple of minutes if something
> really bad happens.
> 
> This is why the kernel has some knowledge of barriers and uses them to
> issue flushes when needed.

Problem is, ext3 has barriers off by default so it's not saving most people.

And then if you turn them on, but have your filesystem on an lvm device,
lvm strips them out again.

-Eric
