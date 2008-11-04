Return-Path: <linux-kernel-owner+w=401wt.eu-S1754043AbYKDV0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbYKDV0j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 16:26:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752901AbYKDV0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 16:26:31 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:53577 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbYKDV0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 16:26:30 -0500
Date: Tue, 4 Nov 2008 22:28:11 +0100
From: Pavel Machek <pavel@suse.cz>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: data corruption: revalidating a (removable) hdd/flash on
	re-insert
Message-ID: <20081104212811.GC8349@elf.ucw.cz>
References: <490B2659.9010304@msgid.tls.msk.ru> <ac3eb2510810310910w603d90bai8c23b34fb517f21a@mail.gmail.com> <20081104195728.GC5862@ucw.cz> <ac3eb2510811041213l4a20fa12h3c5beb3c2d317574@mail.gmail.com> <20081104202011.GA7135@ucw.cz> <4910BD2B.1020808@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4910BD2B.1020808@msgid.tls.msk.ru>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-11-05 00:22:51, Michael Tokarev wrote:
> Pavel Machek wrote:
>>>>> Every access to removable media is guarded by this revalidation check.
>>>>> If you don't see these events, you should not trust this reader, and
>>>>> at least never change the media while it is connected.
>>>> This is rather nasty data-corrupter.
>>> Sure, it is.
>>>
>>>> Could we at least blacklist
>>>> broken device, and force revalidation on each close or something like
>>>> that?
>>> What's your idea of revalidation if the hardware does not tell you?
>>> Get an md5 of the disk content? :)
>>
>> Well... you should not eject media while fs is mounted or blockdev is
>> open, correct?
>>
>> So can we simply claim 'media changed' on last close/unmount? Sure,
>> sometimes media was not changed, but that only hurts performance, not
>> correctness... ?
>
> Well, that's what my tiny proggy, which I used here to work around the
> problem, does.  It constantly opens/closes the /dev/sdFOO, every 0.5s
> currently (I don't think I will be able to replace a media faster than
> half a second :), in order to catch REMOVALs of media -- because when
> the drive does not see the media anymore, it correctly reports that
> the media has changed...

Ok, so we you need to do is to put it into kernel and activate it
via blacklist...?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
