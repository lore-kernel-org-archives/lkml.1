Return-Path: <linux-kernel-owner+w=401wt.eu-S1753759AbZIAU25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759AbZIAU25 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 16:28:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752869AbZIAU24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 16:28:56 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56319 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbZIAU2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 16:28:55 -0400
Date: Tue, 1 Sep 2009 16:01:21 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jeff Garzik <jeff@garzik.org>
Cc: Ric Wheeler <rwheeler@redhat.com>, Theodore Tso <tytso@mit.edu>,
       Rob Landley <rob@landley.net>, Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
Subject: Re: MD/DM and barriers (was Re: [patch] ext2/3: document
	conditions when reliable operation is possible)
Message-ID: <20090901140120.GD2028@ucw.cz>
References: <20090825225114.GE4300@elf.ucw.cz> <4A948C94.7040103@redhat.com> <20090826025849.GF32712@mit.edu> <200908270019.04231.rob@landley.net> <20090827122423.GO6997@mit.edu> <4A9685D4.2070906@redhat.com> <4A96BA2D.60804@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A96BA2D.60804@garzik.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-08-27 12:54:05, Jeff Garzik wrote:
> On 08/27/2009 09:10 AM, Ric Wheeler wrote:
>> One thing that does need fixing for some MD configurations is to stress
>> again that we need to make sure that barrier operations are properly
>> supported or users will need to disable the write cache on devices with
>> volatile write caches.
>
> Agreed; chime in on Christoph's linux-vfs thread if people have input.
>
> I quickly glanced at MD and DM.  Currently, upstream, we see a lot of
>
>         if (unlikely(bio_barrier(bio))) {
>                 bio_endio(bio, -EOPNOTSUPP);
>                 return 0;
>         }
>
> in DM and MD make_request functions.
>
> Only md/raid1 supports barriers at present, it seems.  None of the other  
> MD drivers support barriers.

Not even md/raid0? Ouch :-(.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
