Return-Path: <linux-kernel-owner+w=401wt.eu-S1755184AbXE3Nmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184AbXE3Nmz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 09:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbXE3Nmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 09:42:47 -0400
Received: from smtp.nokia.com ([131.228.20.171]:25528 "EHLO
	mgw-ext12.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281AbXE3Nmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 09:42:46 -0400
Message-ID: <465D7EFB.8090609@yandex.ru>
Date: Wed, 30 May 2007 16:41:15 +0300
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: Daniel Hazelton <dhazelton@enter.net>,
       Michael-Luke Jones <mlj28@cam.ac.uk>,
       lkml <linux-kernel@vger.kernel.org>, dwmw2@infradead.org,
       madler@alumni.caltech.edu, jloup@gzip.org
Subject: Re: JFFS2 using 'private' zlib header (was [RFC] LZO de/compression
 support - take 6)
References: <4cefeab80705280734i37df1742k6738cd4200813684@mail.gmail.com>	 <a781481a0705290427n3bad472aqf4e0b8276780b405@mail.gmail.com>	 <231C137C-D0BF-44F7-B2D5-AE610284D00A@cam.ac.uk>	 <200705290943.11176.dhazelton@enter.net> <a781481a0705290815y32758055te52cb8657f34acc@mail.gmail.com>
In-Reply-To: <a781481a0705290815y32758055te52cb8657f34acc@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 30 May 2007 13:41:15.0715 (UTC) FILETIME=[31DA2930:01C7A2C0]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
> Hmmm, either jffs2 thinks the zlib interfaces exposed through
> include/linux/zlib.h are insufficient, or it isn't using zlib properly
> (or at least the way it was supposed to be used :-)
> 

I do not remember many details, but yes, JFFS2 uses zlib trickily.

Traditionally, zlib is used like this: you have an input buffer, and you have
a large enough out put buffer, you compress whole input buffer to the output
buffer.

JFFS2 needs: it has _big_ input buffer, and _small_ output buffer, and it wants
zlib to compress as much as possible from the input buffer, and make the output
buffer full or nearly full of compressed data.

This is why JFFS2 uses different hacks, but I do not remember details anymore.
Otherwise it could just use cryptoapi instead. In fact, I tried this 2
years ago, but gave up: http://lkml.org/lkml/2005/3/25/104

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
