Return-Path: <linux-kernel-owner+w=401wt.eu-S1762061AbYDURWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762061AbYDURWz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 13:22:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752830AbYDURWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 13:22:47 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:48379 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbYDURWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 13:22:46 -0400
Date: Mon, 21 Apr 2008 19:23:28 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, mingo@elte.hu, akpm@osdl.org,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] x86 NMI-safe INT3 and Page Fault (v5)
Message-ID: <20080421172327.GA32278@elf.ucw.cz>
References: <20080417165839.GA25198@Krystal> <20080417165944.GB25198@Krystal> <20080417201410.GB31616@Krystal> <20080421140054.GB4685@ucw.cz> <480CA337.3090709@zytor.com> <20080421150825.GA4070@Krystal> <480CADD3.3010209@zytor.com> <20080421154756.GA2424@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080421154756.GA2424@Krystal>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-04-21 11:47:56, Mathieu Desnoyers wrote:
> * H. Peter Anvin (hpa@zytor.com) wrote:
> > Mathieu Desnoyers wrote:
> >> Just to be clear : the added cost on normal interrupt return is to add a
> >> supplementary test of the thread flags already loaded in registers and
> >> a conditional branch. This is used to detect if we are nested over an
> >> NMI handler. I doubt anyone ever notice an impact caused by this added
> >> test/branch.
> >
> > Why the **** would you do this except in the handful of places where you 
> > actually *could* be nested over an NMI handler (basically #MC, #DB and 
> > INT3)?

> 
> There is also the page fault case. I think putting this test in
> ret_from_exception would be both safe (it is executed for any
> exception return) and fast (exceptions are rare).

Eh? I thought that page fault is one of the hottest paths in kernel
(along with syscall and packet receive/send)...
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
