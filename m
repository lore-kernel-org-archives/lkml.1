Return-Path: <linux-kernel-owner+w=401wt.eu-S1759362AbZCQQJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759362AbZCQQJN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 12:09:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755123AbZCQQI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 12:08:56 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:44534 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755203AbZCQQI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 12:08:56 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] deadlock when swapping to FAT
References: <Pine.LNX.4.64.0903120819010.26206@hs20-bc2-1.build.redhat.com>
	<87zlfqohfn.fsf@devron.myhome.or.jp>
	<Pine.LNX.4.64.0903142153330.23664@hs20-bc2-1.build.redhat.com>
	<878wn7h3la.fsf@devron.myhome.or.jp>
	<Pine.LNX.4.64.0903170815110.26754@hs20-bc2-1.build.redhat.com>
Date: Wed, 18 Mar 2009 01:08:49 +0900
In-Reply-To: <Pine.LNX.4.64.0903170815110.26754@hs20-bc2-1.build.redhat.com>
	(Mikulas Patocka's message of "Tue, 17 Mar 2009 08:23:28 -0400 (EDT)")
Message-ID: <87prgg6sj2.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikulas Patocka <mpatocka@redhat.com> writes:

> On Sun, 15 Mar 2009, OGAWA Hirofumi wrote:
>
>> Mikulas Patocka <mpatocka@redhat.com> writes:
>> 
>> > Note that the same race condition is happening in all the other 
>> > filesystems. Maybe move that i_alloc_sem up to ->bmap method caller?
>> 
>> It can be. However, I guess locking strategy would be per
>> filesystems. Because the fs may be using i_alloc_sem in get_block
>> already.
>
> Which ones take it in get_block? I grepped for i_alloc_sem and don't see 
> them. Besides, it is mostly taken only for read and recursive taking of 
> read-lock for read is allowed. It is taken for writes only in truncate.

I don't know which fs take it, and whether i_alloc_sem is enough for
which fs. It was just guess. And important one is locking strategy of
that would be per filesystems. E.g. it seems XFS is taking own lock.

Well, personally, I don't have objection to add i_alloc_sem, however I'm
not sure, what does i_alloc_sem guarantee for other fs.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
