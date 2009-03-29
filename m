Return-Path: <linux-kernel-owner+w=401wt.eu-S1757654AbZC2NH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757654AbZC2NH4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 09:07:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757293AbZC2NHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 09:07:46 -0400
Received: from smtp.nokia.com ([192.100.105.134]:23889 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754526AbZC2NHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 09:07:44 -0400
Message-ID: <49CF7297.4020201@nokia.com>
Date: Sun, 29 Mar 2009 16:07:35 +0300
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Artem Bityutskiy <dedekind@yandex.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: replace() system call needed (was Re: EXT4-ish "fixes" in UBIFS)
References: <49CCCB0A.6070701@nokia.com> <20090329122600.GA13737@elf.ucw.cz> <49CF6CBB.7070907@yandex.ru> <20090329124959.GD15492@elf.ucw.cz> <49CF70FD.7050802@nokia.com> <20090329130251.GF15492@elf.ucw.cz>
In-Reply-To: <20090329130251.GF15492@elf.ucw.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 29 Mar 2009 13:07:36.0749 (UTC) FILETIME=[54CF25D0:01C9B06F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Sun 2009-03-29 16:00:45, Artem Bityutskiy wrote:
>> Pavel Machek wrote:
>>>>>> 2. create/write/rename leads to empty files
>>>>> ..but this should not be. If we want to make that explicit, we should
>>>>> provide "replace()" operation; where replace is rename that makes sure
>>>>> that source file is completely on media before commiting the rename.
>>>> Well, OK, we can fsync() before rename, we just need clean rules
>>>> for this, so that all Linux FSes would follow them. Would be nice
>>>> to have final agreement on all this stuff.
>>> My proposal is 
>>>
>>> rename() stays.
>> It stays and:
>>
>> 1. does _not_ fsync
> 
> Does not fsync. If someone wants to make sure one of the files is on
> the disk, he should use replace(). [On non-linux systems, replace()
> should be implemented as fsync/rename in libc or something.]

I would be happy with these rules. But the fact is, application
people just refuse to add fsync before rename. They say that the
FS has to do this. And they say that even Linus supports them,
which is an argument I find difficult to fight against. This is
why I want clean rules.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
