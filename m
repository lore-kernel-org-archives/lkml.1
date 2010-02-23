Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153Ab0BWPUU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 10:20:20 -0500
Received: from DMZ-MAILSEC-SCANNER-5.MIT.EDU ([18.7.68.34]:46822 "EHLO
	dmz-mailsec-scanner-5.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752499Ab0BWPUR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 10:20:17 -0500
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Feb 2010 10:20:17 EST
X-AuditID: 12074422-b7c71ae000000a1a-6f-4b83f1024d1a
Subject: Re: QUERY: Inclusion of header files in kernel header files
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <22dbbef21002230337i104c63dcm5d59064ca48a07f0@mail.gmail.com>
Date: Tue, 23 Feb 2010 10:15:11 -0500
Cc: Borislav Petkov <petkovbb@googlemail.com>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <07BBC9AE-C1A1-449F-AE5E-EB5B1C6323C2@mit.edu>
References: <22dbbef21002222241h711402f1me6b60ac7502cccd4@mail.gmail.com> <22dbbef21002222243s7afb8e2cy1c783a29fe22ac55@mail.gmail.com> <20100223065953.GB32503@liondog.tnic> <22dbbef21002222331o6a59dc25mea3fc7e62dae6710@mail.gmail.com> <20100223095025.GA18559@liondog.tnic> <22dbbef21002230337i104c63dcm5d59064ca48a07f0@mail.gmail.com>
To: viresh kumar <viresh.linux@gmail.com>
X-Mailer: Apple Mail (2.1077)
X-Brightmail-Tracker: AAAAARLvbOs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 23, 2010, at 6:37 AM, viresh kumar wrote:
> 
> Actually this issue is not present only in bus.h, but some other
> kernel header files.
> Like: arch/arm/include/asm/clkdev.h don't include list.h file but
> using struct list_head
> 
> May be we need to check this in other header files also.


Before someone goes crazy and starts sending hundreds of patches to the trivial patch folks, please make sure that you only do this for places where header file foo uses "struct bar" in bar.h --- and NOT if it is using "struct bar *".    Blind structure pointers don't cause compile failures, and is a perfectly good thing from the standpoint of data hiding.

Also, it's highly desirable that as much as possible multiple inclusion is fixed up at the same time you add extra #includes into header files.   Protecting against multiple inclusion is critical, yes, but even with the protection against multiple inclusion, the header file has to get parsed a second time, and that slows down kernel compiles.

Regards,

-- Ted

