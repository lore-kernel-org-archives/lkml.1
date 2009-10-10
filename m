Return-Path: <linux-kernel-owner+w=401wt.eu-S932470AbZJJN1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932470AbZJJN1w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 09:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932250AbZJJN1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 09:27:50 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44531 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932191AbZJJN1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 09:27:49 -0400
Date: Sat, 10 Oct 2009 15:27:07 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jan Beulich <JBeulich@novell.com>
Cc: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       hpa@zytor.com
Subject: Re: [PATCH] x86-64: don't leak kernel register values to 32-bit
 processes
Message-ID: <20091010132707.GB8349@elf.ucw.cz>
References: <4AC34D73020000780001744A@vpn.id2.novell.com>
 <20091007094248.GA1425@ucw.cz>
 <4ACDEC070200007800018B57@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ACDEC070200007800018B57@vpn.id2.novell.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-10-08 12:41:27, Jan Beulich wrote:
> >>> Pavel Machek <pavel@ucw.cz> 07.10.09 11:44 >>>
> >How can userspace "temporarily switch itself" to 64bit mode?
> 
> By just determining (or guessing) the 64-bit user mode CS value, and far-
> jumping/calling to an address with this CS as the selector.
> 
> >Such ability would lead to very interesting behaviour on 32-bit
> >kernel, I'd say...
> 
> That won't work - you have to have a 64-bit kernel: EFER.LME and the L
> bit of some user mode code segment descriptor must be set (or settable).
> 
> Consequently a 64-bit kernel could, if it wanted to, make it impossible for
> user mode code to do such switching (and an example of this, where
> security requires it, is 64-bit Xen disallowing 32-bit para-virtual guests
> [kernel or user mode] to switch themselves into 64-bit mode).

I guess we should do just that -- 32-bit application temporary going
64-bit is asking for trouble. How will attached gdb behave? What if I
try the same code on 32-bit machine?

It seems only useful for malware... 
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
