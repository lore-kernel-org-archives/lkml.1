Return-Path: <linux-kernel-owner+w=401wt.eu-S933258AbZJFV5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933258AbZJFV5f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 17:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758381AbZJFV5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 17:57:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57500 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758378AbZJFV5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 17:57:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] Massive ext4 filesystem corruption after a failed s2disk/ram cycle
Date: Tue, 6 Oct 2009 23:58:32 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc3-rjw; KDE/4.3.1; x86_64; ; )
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <1254863215.11577.23.camel@maxim-laptop>
In-Reply-To: <1254863215.11577.23.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910062358.32417.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 October 2009, Maxim Levitsky wrote:
> Hi,
> 
> Just prior to 2.6.32 cycle I tried -next tree and noticed that after a
> failed s2ram (here it works only once, and I test once in a whileto see
> if fixed accidentally) I got a minor filesystem corruption. I am sorry I
> didn't report that back then.
> 
> Now I have installed 2.6.32-rc2 (well -rc1...) and things were sort of
> ok, I have even thought that hibernation is once again stable
> (somewhere in the not that distinct past the hibernation which used to
> work, began to fail randomly on resume)
> 
> Few days ago, I got a read-only filesystem again, an fsck, few more
> corrupted files..., It should have had rung the bell for me (I have
> still used hibernation, trying to understand why it fails sometimes)
> 
> Yesterday, however, I have decided to fix that once and for all, and for
> that I have set up a loop + rtc wakealarm to make it cycle through
> hibernation.
> 
> Needless to say I didn't run that loop more that maybe 3 cycles (and no
> failures), but noticed that rtc clock is dead on resume. 
> 
> I sort of fixed that (this is hpet emulation that strikes again), I will
> post when I test the fix (trivial), because when I had rebooted the
> system into the modified kernel, I got that readonly filesystem again,
> and this time the damage had spread over lots of files.
> (I have even lost most of dpkg database..., many programs,
> libraries,..., settings)
> 
> Yet, thanks to Linux flexibility, after a day, and some study of
> nautilus source, I had the system recovered fully.
> (Now am doing backups.....)
> 
> But I don't want that to happen again...
> 
> Another clue that I have seen was that ext4 driver reported that it
> aborts journal replay.
> 
> I know that for now there is not much you can do, but just to let you
> know that something is there...
> 
> What is especially interesting is that there were no s2ram'disk faulure
> preceding the corruption, but my theory is that corruption wasn't
> detected for a while from last failure, probably giving such bad
> consequences.
> 
> You do sync file-systems before entering the hibernation, don't you?

Yes, a sync is there, but it is not effective on some filesystems.

Thanks,
Rafael
