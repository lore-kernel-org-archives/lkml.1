Return-Path: <linux-kernel-owner+w=401wt.eu-S1761849AbXGJB46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761849AbXGJB46 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 21:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757270AbXGJB4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 21:56:51 -0400
Received: from ozlabs.org ([203.10.76.45]:57197 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756010AbXGJB4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 21:56:50 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18066.59225.533802.387340@cargo.ozlabs.ibm.com>
Date: Tue, 10 Jul 2007 11:56:41 +1000
From: Paul Mackerras <paulus@samba.org>
To: nigel@suspend2.net
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org,
       Kyle Moffett <mrmacman_g4@mac.com>, Pavel Machek <pavel@ucw.cz>,
       linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] Re: hibernation/snapshot design [was Re: [PATCH] Remove
	process freezer from suspend to RAM pathway]
In-Reply-To: <200707101133.01566.nigel@nigel.suspend2.net>
References: <Pine.LNX.4.44L0.0707072224270.10912-100000@netrider.rowland.org>
	<20070708221315.GF5401@elf.ucw.cz>
	<200707090101.28832.rjw@sisk.pl>
	<200707101133.01566.nigel@nigel.suspend2.net>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nigel Cunningham writes:

> (Finally catching up on emails since Saturday!)

Yes, I know what you mean; I was occupied with other work stuff on
Friday and not well on Saturday, and by that stage there was a backlog
of about 500 emails for me to wade through... :/

> The freezer is also essential for doing a full image of memory - you
> have to be able to guarantee that some of the image won't change in
> order to be able to write it out before the atomic copy. Of course the
> freezer alone isn't enough, but it solves 95% of the issue.

Sure.  As I pointed out in another email, it's unrealistic to expect
the freezer to be able to stop everything in a state where any
arbitrary mutex is free.  But as long as you don't need to do anything
that depends on getting a mutex while the system is frozen, there
should be no problem.

Paul.
