Return-Path: <linux-kernel-owner+w=401wt.eu-S1755787AbZCDAq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787AbZCDAq5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 19:46:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752652AbZCDAqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 19:46:48 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34174 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbZCDAqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 19:46:48 -0500
Date: Wed, 4 Mar 2009 01:49:34 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Arve Hj?nnev?g <arve@android.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Kyle Moffett <kyle@moffetthome.net>, Oliver Neukum <oliver@neukum.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
Message-ID: <20090304004934.GC6280@elf.ucw.cz>
References: <200902192215.18365.rjw@sisk.pl> <200903020017.52390.rjw@sisk.pl> <d6200be20903021548h11f57283t6d6a9053f3feb3fd@mail.gmail.com> <200903032339.02002.rjw@sisk.pl> <d6200be20903031538s42c8243dk59c505857cdab7cb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d6200be20903031538s42c8243dk59c505857cdab7cb@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > That need not happen at once (eg. in one patch or something).  Once we've
> > introduced the basics, the changes can be made gradually wherever necessary,
> > step by step.
> 
> If you are OK with merging an unfinished system then this may work.

Good.

> > So, I'd suggest to just separate the timeouted suspend blockers from the
> > basic code and introduce the latter first.
> 
> How do you want to handle drivers that return -EBUSY from suspend. The
> basic code uses a wakelock with a timeout to handle this now. Without
> this we can either try suspend again immediately, or activate a
> suspend blocker and use a timer to release it.

Just printk() and complain. That should be good enough solution for
now... (Those drivers are arguably buggy already. If user told machine
to go to sleep, it should not randomly refuse to do that.)

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
