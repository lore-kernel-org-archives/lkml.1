Return-Path: <linux-kernel-owner+w=401wt.eu-S1757841AbZFCPN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757841AbZFCPN4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 11:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754295AbZFCPNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 11:13:48 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:48699 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbZFCPNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 11:13:47 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: linux-kernel@vger.kernel.org
Cc: "linux-fsdevel\@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "Hunter Adrian \(Nokia-D\/Helsinki\)" <adrian.hunter@nokia.com>,
       "Bityutskiy Artem \(Nokia-D\/Helsinki\)" <Artem.Bityutskiy@nokia.com>
Subject: Re: [PATCH 0/5] FAT errors, user space notifications
References: <1243866494-31011-1-git-send-email-ext-denis.2.karpov@nokia.com>
	<87bpp6nhet.fsf@devron.myhome.or.jp>
	<20090603113617.GA9917@smart.research.nokia.com>
Date: Thu, 04 Jun 2009 00:13:45 +0900
In-Reply-To: <20090603113617.GA9917@smart.research.nokia.com> (Denis Karpov's
	message of "Wed, 3 Jun 2009 14:36:17 +0300")
Message-ID: <87oct5l592.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denis Karpov <ext-denis.2.karpov@nokia.com> writes:

> I realise that, but in this particular case I deal with non-critical data 
> on a large FAT partition and can probably afford certain risk of damaging
> the data. What I can't afford is to spend several minutes fsck'ing huge FAT
> partition on slow SD/MMC media during bootup.
>
> So I choose to optionally receive notification of errors encountered 
> during 'run time' and act upon them.
>
> Otherwise, nothing stops you from doing proper fsck before mounting.

I think fsckless is to add the reliability to fs driver (logging,
softupdate, etc.). Yes, it's not easy, and it needs time. Anyway, I
actually thought about softupdate (and some others) before, I think it's
_not_ nothing.

> IMO, receivng notification of errors is benefitial in any case:
> together with the 1st patch above it gives full flexibility to user space
> to implement fs 'run-time' errors handling policy (at least for FAT,EXT2),
> e.g.:
>
> - do nothing: remount r/o on errors, don't monitor kernel notifications (old/default
>  behavior)
> - remount-ro on errors, get notified; unmount partition, fsck, mount
>   partition back r/w;
> - ignore errors (continue), get notified: unmount the partition later at
> suitable time, fsck, mount back r/w

If this is monitoring interface, I guess it should be more generic. And
I guess it will tell what happened in kernel, not fs_clean. (There is no
guarantee about fs state)

If not, some errors can not be detected by fs driver. User may know some
run-time errors by fs_clean, but some run-time errors is not. So, user
can not trust fs_clean.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
