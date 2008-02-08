Return-Path: <linux-kernel-owner+w=401wt.eu-S932766AbYBHHEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932766AbYBHHEo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 02:04:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755327AbYBHHEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 02:04:34 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3452 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755128AbYBHHEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 02:04:33 -0500
Date: Fri, 8 Feb 2008 07:04:19 +0000
From: Pavel Machek <pavel@ucw.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>
Subject: Re: [rft] s2ram wakeup moves to .c, could fix few machines
Message-ID: <20080208070419.GA4544@ucw.cz>
References: <20080205190600.GB11613@elf.ucw.cz> <200802072312.31430.rjw@sisk.pl> <47AB887E.7010000@zytor.com> <200802080006.54151.rjw@sisk.pl> <20080207233509.GB21468@elf.ucw.cz> <47AB975C.1010902@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47AB975C.1010902@zytor.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >I really need the entry point to be at offset 0, so 
> >that I can get
> >pointers to my data. I could not figure out how to do 
> >it any other
> >way. And if 0 is taken, I thought I'd put header at the 
> >end.
> >
> 
> Why not just put the structure at 0, and put pointers in 
> the structure to everything else you need?

segments:offsets rear its ugly head here. I need %ds to point to my
data, and the way to do it is copy it from %cs; that needs start to be
at 0.

If you can find a solution that does not need this (some
segment/offset arithmetics at beggining of wakeup?) we could use it,
but I was lost between relocations.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
