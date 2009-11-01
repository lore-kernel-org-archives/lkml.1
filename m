Return-Path: <linux-kernel-owner+w=401wt.eu-S1753500AbZKAVNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500AbZKAVNM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 16:13:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753453AbZKAVNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 16:13:11 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49240 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435AbZKAVNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 16:13:10 -0500
Date: Sun, 1 Nov 2009 22:13:06 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: Doug Thompson <norsk5@yahoo.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] amd64_edac: syndromes loading
Message-ID: <20091101211305.GB2085@ucw.cz>
References: <20091028163534.GA625@aftab> <143841.81095.qm@web50110.mail.re2.yahoo.com> <20091028172853.GE625@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091028172853.GE625@aftab>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-10-28 18:28:53, Borislav Petkov wrote:
> On Wed, Oct 28, 2009 at 10:15:03AM -0700, Doug Thompson wrote:
> > Where does the syndrome table/module/firmware live in the file system?
> > In with the amd64 module area or elsewhere?
> 
> Yeah, I was thinking maybe drivers/edac/amd64_x(4|8).bin or so.
> 
> Alternatively, we could make the syndromes builtin thus removing the
> requirement to go to userspace for the loading. For that we'll need
> two new .c files in drivers/edac/ which represent the x4 and x8 tables
> respectively:
> 
> unsigned short x8_raw_data[] = {
>         0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
>         0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
>         0x0000, 0x0100, 0x0001, 0x0101, 0x01B8, 0x015C, 0x012E, 0x01C6, 0x0163,
>         0x01FD, 0x0189, 0x019D, 0xB801, 0x5C01, 0x2E01, 0xC601, 0x6301, 0xFD01,
>         0x8901, 0x9D01, 0x0200, 0x0002, 0x0202, 0x0201, 0x02B8, 0x025C, 0x02FD,
> 	....
> 
> The drawback with these is that they'll always be builtin, enlarging
> kernel code by 10-15K although only one of them is in use.

I believe that 15K is reasonable price to pay for not having to
install another 'firmware' file.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
