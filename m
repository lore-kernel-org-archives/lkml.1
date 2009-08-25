Return-Path: <linux-kernel-owner+w=401wt.eu-S932448AbZHYXpF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932448AbZHYXpF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 19:45:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932366AbZHYXpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 19:45:04 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47744 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932372AbZHYXpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 19:45:02 -0400
Date: Wed, 26 Aug 2009 01:44:55 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Neil Brown <neilb@suse.de>
Cc: Ric Wheeler <rwheeler@redhat.com>, Theodore Tso <tytso@mit.edu>,
       Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>, Rob Landley <rob@landley.net>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
	possible
Message-ID: <20090825234454.GI4300@elf.ucw.cz>
References: <20090824205209.GE29763@elf.ucw.cz> <4A930160.8060508@redhat.com> <20090824212518.GF29763@elf.ucw.cz> <20090824223915.GI17684@mit.edu> <20090824230036.GK29763@elf.ucw.cz> <20090825000842.GM17684@mit.edu> <20090825094244.GC15563@elf.ucw.cz> <4A93E908.6050908@redhat.com> <20090825211515.GA3688@elf.ucw.cz> <19092.28371.793339.764701@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19092.28371.793339.764701@notabene.brown>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> While I think it is, in principle, worth documenting this sort of
> thing, there are an awful lot of fine details and distinctions that
> would need to be considered.

Ok, can you help? Having a piece of MD documentation explaining the
"powerfail nukes entire stripe" and how current filesystems do not
deal with that would be nice, along with description when exactly that
happens.

It seems to need two events -- one failed disk and one powerfail. I
knew that raid5 only protects against one failure, but I never
realized that simple powerfail (or kernel crash) counts as a failure
here, too.

I guess it should go at the end of md.txt.... aha, it actually already
talks about the issue a bit, in:

#Boot time assembly of degraded/dirty arrays
#-------------------------------------------
#
#If a raid5 or raid6 array is both dirty and degraded, it could have
#undetectable data corruption.  This is because the fact that it is
#'dirty' means that the parity cannot be trusted, and the fact that it
#is degraded means that some datablocks are missing and cannot reliably
#be reconstructed (due to no parity).

(Actually... that's possibly what happened to friend of mine. One of
disks in raid5 stopped responding and whole system just hanged
up. Oops, two failures in one...)
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
