Return-Path: <linux-kernel-owner+w=401wt.eu-S1760120AbZDCHe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760120AbZDCHe0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 03:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755352AbZDCHeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 03:34:09 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48677 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328AbZDCHeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 03:34:08 -0400
Date: Fri, 3 Apr 2009 09:33:49 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Theodore Tso <tytso@mit.edu>,
       "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Ray Lee <ray-lk@madrabbit.org>, david@lang.hm,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Sitsofe Wheeler <sitsofe@yahoo.com>, Alberto Gonzalez <info@gnebu.es>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Ext4 and the "30 second window of death"
Message-ID: <20090403073349.GA24569@elf.ucw.cz>
References: <20090401052050.GA20456@sucs.org> <20090401151219.GA12285@srcf.ucam.org> <20090401173521.GA15423@mit.edu> <20090401174336.GA14726@srcf.ucam.org> <alpine.DEB.1.10.0904021116500.28893@asgard.lang.hm> <20090402182925.GA4502@srcf.ucam.org> <alpine.DEB.1.10.0904021134560.28893@asgard.lang.hm> <2c0942db0904021307w2c311dc2s9bf31c9ed3c1e6ba@mail.gmail.com> <49D5273B.60806@ursus.ath.cx> <20090402233806.GG9870@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090402233806.GG9870@mit.edu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> If you are a mail client developer, and the user says, "I want the
> advantages of IMAP, but I refuse to switch to an ISP that provides
> IMAP; you must give me *all* the advantages IMAP even though I'm using
> POP3", you'd probably tell the user, "Yes, and do you want a pony,
> too?"

Somebody wants a pony?

> The problem is, this is what the application programmers are telling
> the filesystem developers.  They refuse to change their programs; and
> the features they want are sometimes mutually contradictory, or at
> least result in a overconstrained problem --- and then they throw the
> whole mess at the filesystem developers' feet and say, "you fix it!"
> 
> I'm not saying the filesystems are blameless, but give us a little
> slack, guys; we NEED some help from the application developers here.

>From what I seen on the gtk lists, application developers are willing
to change they code. _But_ we should make sure that it does not
regress. fsync() is a regression: spins the disk up too much, slow on
ext3. (They may be willing to do that, but I believe that's a very bad
idea). And yes, I hope your "lets add fsync() everywhere, then break
the fsync with eat-my-data-^W-laptop-mode" plan does not
happen. (Please acknowledge that it is a stupid idea...)

If you give them fbarrier() or replace() or something that is nop or
nearly so on ext3 data=ordered and fixes ext4/btrfs, they'll happily
use it. But we do not have such thing now, and we should not be really
asking them to regress on existing setups.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
