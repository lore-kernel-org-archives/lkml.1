Return-Path: <linux-kernel-owner+w=401wt.eu-S1758964AbZKEWR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758964AbZKEWR3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 17:17:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758937AbZKEWR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 17:17:28 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33789 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758848AbZKEWR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 17:17:27 -0500
Date: Thu, 5 Nov 2009 23:17:25 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Doug Thompson <norsk5@yahoo.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] amd64_edac: syndromes loading
Message-ID: <20091105221725.GA3683@elf.ucw.cz>
References: <20091028163534.GA625@aftab>
 <143841.81095.qm@web50110.mail.re2.yahoo.com>
 <20091028172853.GE625@aftab>
 <20091101211305.GB2085@ucw.cz>
 <4AEE0CAA.4070403@zytor.com>
 <20091105132758.GC17984@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091105132758.GC17984@aftab>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> sorry for the delay, I had to talk to the hardware guys about those
> tables.
> 
> On Mon, Nov 02, 2009 at 07:33:14AM +0900, H. Peter Anvin wrote:
> > >>Alternatively, we could make the syndromes builtin thus removing the
> > >>requirement to go to userspace for the loading. For that we'll need
> > >>two new .c files in drivers/edac/ which represent the x4 and x8 tables
> > >>respectively:
> > >>
> > >>unsigned short x8_raw_data[] = {
> > >>         0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
> > >>         0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
> > >>         0x0000, 0x0100, 0x0001, 0x0101, 0x01B8, 0x015C, 0x012E, 0x01C6, 0x0163,
> > >>         0x01FD, 0x0189, 0x019D, 0xB801, 0x5C01, 0x2E01, 0xC601, 0x6301, 0xFD01,
> > >>         0x8901, 0x9D01, 0x0200, 0x0002, 0x0202, 0x0201, 0x02B8, 0x025C, 0x02FD,
> > >>	....
> > >>
> > >>The drawback with these is that they'll always be builtin, enlarging
> > >>kernel code by 10-15K although only one of them is in use.
> > >
> > >I believe that 15K is reasonable price to pay for not having to
> > >install another 'firmware' file.
> > 
> > a) aren't these computable somehow?  If so, it's probably easier to
> > include the algorithm in the kernel rather than a table.
> 
> That's a no-go since it would involve IP disclosure.

Then you should really talk to the lawyers. Is AMD willing to risk GPL
violation by merging something other than "form preferable for
editing"?

> > b) "I believe that 15K is reasonable price to pay for not having to
> > install another 'firmware' file."  I think that's a tradeoff a lot
> > of people would *not* choose to make.  This is of course why we have
> > (or at least, should have) to either compile in firmware blobs or
> > not.
> 
> The good news is they've come up with a modified algorithm which will
> require a smaller table, roughly 1/4th the size of the current 10K one.
> Now, on a second thought and IMHO, we should simply add another .c file
> instantiating those two x4 and x8 tables statically and linking them
> into the edac code. This way you
> 
> 1) don't have the additional complexity of adding firmware handling code
> and thus don't add a dependency on the firmware API
> 
> 2) don't have to actually carry two firmware images with the kernel

Well, that's certainly better than current situation.

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
