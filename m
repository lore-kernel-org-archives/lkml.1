Return-Path: <linux-kernel-owner+w=401wt.eu-S1752204AbZHBMtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204AbZHBMtw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 08:49:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751908AbZHBMtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 08:49:51 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47883 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbZHBMtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 08:49:51 -0400
Date: Thu, 30 Jul 2009 11:06:45 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       selinux@tycho.nsa.gov, sds@tycho.nsa.gov, jmorris@namei.org,
       spender@grsecurity.net, dwalsh@redhat.com, cl@linux-foundation.org,
       arjan@infradead.org, alan@lxorguk.ukuu.org.uk
Subject: Re: mmap_min_addr and your local LSM (ok, just SELinux)
Message-ID: <20090730090645.GB1364@ucw.cz>
References: <1248132223.2654.278.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248132223.2654.278.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Brad Spengler recently pointed out that the SELinux decision on how to
> handle mmap_min_addr in some ways weakens system security vs on a system
> without SELinux (and in other ways can be stronger).  There is a trade
> off and a reason I did what I did but I would like ideas and discussion
> on how to get the best of both worlds.
> 
> With SELinux mapping the 0 page requires an SELinux policy permission,
> mmap_zero.  Without SELinux mapping the 0 page requires CAP_SYS_RAWIO.
> Note that CAP_SYS_RAWIO roughly translates to uid=0 since noone really
> does interesting things with capabilities.

I wonder if cap_sys_rawio is right capability for this..? rawio
normally grants you kernel-llevel access, so you don't want to give it
to wine. But maybe if it checked cap_sys_nice or some new capability,
we could reasonably give that to wine, and problem would be gone?

cap_sys_obscure_features ?

(I guess vm86 mode should fall under that, too :-)

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
