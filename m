Return-Path: <linux-kernel-owner+w=401wt.eu-S1757411AbZC2Nz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757411AbZC2Nz5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 09:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754981AbZC2Nzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 09:55:47 -0400
Received: from smtp.nokia.com ([192.100.122.233]:40775 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702AbZC2Nzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 09:55:47 -0400
Message-ID: <49CF7DD6.6050109@nokia.com>
Date: Sun, 29 Mar 2009 16:55:34 +0300
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>
CC: Pavel Machek <pavel@ucw.cz>, Artem Bityutskiy <dedekind@yandex.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: replace() system call needed (was Re: EXT4-ish "fixes" in UBIFS)
References: <49CCCB0A.6070701@nokia.com> <20090329122600.GA13737@elf.ucw.cz> <49CF6CBB.7070907@yandex.ru> <20090329124959.GD15492@elf.ucw.cz> <49CF70FD.7050802@nokia.com> <20090329130251.GF15492@elf.ucw.cz> <49CF7297.4020201@nokia.com> <49CF761E.3030500@ursus.ath.cx>
In-Reply-To: <49CF761E.3030500@ursus.ath.cx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 29 Mar 2009 13:55:35.0862 (UTC) FILETIME=[08E4ED60:01C9B076]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas T.Auer wrote:
> On 29.03.2009 15:07 Artem Bityutskiy wrote:
>> Pavel Machek wrote:
>>> Does not fsync. If someone wants to make sure one of the files is on
>>> the disk, he should use replace(). [On non-linux systems, replace()
>>> should be implemented as fsync/rename in libc or something.]
> As a user I will avoid using any fs, which requires the tons of
> applications to be changed for a reasonable amount of data safety.
>> I would be happy with these rules. But the fact is, application
>> people just refuse to add fsync before rename.
> Because it slows down the performance.
>> They say that the
>> FS has to do this. 
> They say that FS should not write metadata for non-existing data and
> even overwrite "clean" metadata with "dirty" metadata. It is up to the
> fs to decide, whether fsync is needed to achieve this.
 
Well, this makes sense, but the fact is that FS developers did
not keep this in mind. And when we have been developing UBIFS,
we also naively assumed that user-space would just call fsync
if needed. And it was easier to implement stuff this way. And
it looked like POSIX and other Linux FSes assumed that.

But well, we can change UBIFS behavior, but it would be nice
to have some agreement on all this.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
