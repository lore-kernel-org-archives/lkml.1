Return-Path: <linux-kernel-owner+w=401wt.eu-S1757518AbZC2NBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518AbZC2NBx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 09:01:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754864AbZC2NB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 09:01:28 -0400
Received: from mo-p05-ob.rzone.de ([81.169.146.180]:30273 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756466AbZC2NB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 09:01:27 -0400
X-RZG-AUTH: :LWIQcGC8af5qXkYNYt77sURZEFmV4M3TAgvB+Qeh4tE+44JfzNbYav6UBdLY
X-RZG-CLASS-ID: mo05
Message-ID: <49CF7120.4090503@ursus.ath.cx>
Date: Sun, 29 Mar 2009 15:01:20 +0200
From: "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Artem Bityutskiy <dedekind@yandex.ru>, Pavel Machek <pavel@ucw.cz>
CC: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: replace() system call needed (was Re: EXT4-ish "fixes" in UBIFS)
References: <49CCCB0A.6070701@nokia.com> <20090329122600.GA13737@elf.ucw.cz> <49CF6CBB.7070907@yandex.ru>
In-Reply-To: <49CF6CBB.7070907@yandex.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 29.03.2009 14:42 Artem Bityutskiy wrote:
> Pavel Machek wrote:
>
>>> 1. truncate/write/close leads to empty files
>>
>> this is buggy.
>
> In FS, or in application?
In application of course. If you rewrite a huge file that way, you have
a long-time risk of loosing data in a crash, even with sychronous writes.
>
>>> 2. create/write/rename leads to empty files
In the that case the time for the risk is reduced to the rename from the
viewpoint of the application developers, which don't know modern
re-ordering filesystems.

>> ..but this should not be. If we want to make that explicit, we should
>> provide "replace()" operation; where replace is rename that makes sure
>> that source file is completely on media before commiting the rename.
It is a hard task to change all the applications, there a lot of
orphaned projects, which are still used.
> Well, OK, we can fsync() before rename, we just need clean rules
> for this, so that all Linux FSes would follow them. Would be nice
> to have final agreement on all this stuff.
>
This slows down things, but you could also delay the writing of the
metadata pointing to non-existing data. Or is there any use for it after
the crash?

