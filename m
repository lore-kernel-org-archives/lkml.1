Return-Path: <linux-kernel-owner+w=401wt.eu-S1762039AbZC3WM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762039AbZC3WM0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 18:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759681AbZC3WMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 18:12:05 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38339 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756153AbZC3WME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 18:12:04 -0400
Date: Tue, 31 Mar 2009 00:11:52 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Artem Bityutskiy <dedekind@yandex.ru>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: replace() system call needed (was Re: EXT4-ish "fixes" in
	UBIFS)
Message-ID: <20090330221152.GD17800@elf.ucw.cz>
References: <49CCCB0A.6070701@nokia.com> <20090329122600.GA13737@elf.ucw.cz> <49CF6CBB.7070907@yandex.ru> <20090329124959.GD15492@elf.ucw.cz> <49D0FF1E.3010804@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D0FF1E.3010804@redhat.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>> My proposal is 
>>
>> rename() stays.
>>
>> replace(src, bar) is rename that ensures that bar will contain valid
>> data after powerfail.
>>   
>
> Surely the only way to "insure" this is to spin up the drive, write the  
> meta-data and data back and make sure that it is not held in volatile  
> write cache?

Well, no. "will contain valid data" but may contain _old_ valid data.

So the way to do that would be "wait until you have to spin disk up
anyway or until timeout, then write data first, then do rename".

AFAICT that's semantics gnome (etc) wants.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
