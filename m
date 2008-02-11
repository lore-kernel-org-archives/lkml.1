Return-Path: <linux-kernel-owner+w=401wt.eu-S1756232AbYBKMji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232AbYBKMji (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 07:39:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753034AbYBKMj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 07:39:29 -0500
Received: from styx.suse.cz ([82.119.242.94]:45964 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752154AbYBKMj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 07:39:29 -0500
Date: Mon, 11 Feb 2008 13:39:27 +0100
From: Jan Kara <jack@suse.cz>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH] quota: Turn quotas off when remounting read-only
Message-ID: <20080211123927.GF9622@duck.suse.cz>
References: <20080207143721.GH6140@duck.suse.cz> <20080207103655.14ce8512.akpm@linux-foundation.org> <47AB5B9F.8090302@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47AB5B9F.8090302@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 07-02-08 22:27:27, Michael Tokarev wrote:
> Andrew Morton wrote:
> > On Thu, 7 Feb 2008 15:37:21 +0100 Jan Kara <jack@suse.cz> wrote:
> > 
> >> Turn off quotas before filesystem is remounted read only. Otherwise quota will
> >> try to write to read-only filesystem which does no good... We could also just
> >> refuse to remount ro when quota is enabled but turning quota off is consistent
> >> with what we do on umount.
> 
> [a nice one-liner snipped]
> 
> > Cool.  And this is applicable to 2.6.23, 2.6.22 and even earlier, isn't it?
> 
> Provided the amount of time this issue exists, I don't think it's worth
> to push it to -stable.  It's an oooooooold, issue, which happens quite
> rarely, and no one bothered to report it so far...  But it's not my
> call... ;)
> 
> But...  I'm thinking about this scenario:
> 
>  # mount /data
>  # quotaon /data
>  (some maintenance stuff to be planned)
>  # mount -o remount,ro /data
>  (do backup etc)
>  # mount -r remount,rw /data
> 
> at this point, it's expected that quota on /data is enabled.
> After this patch, it's not anymore...
  Yes, it previously accidentally worked this way (for an year or so,
before that we refused to remount read-only). Hmm, but maybe we could
somehow tweak quotas to be turned on when remounting read-write again.
We have all the information we need at the time of remounting read-only
so we could store it and use it later when remounting read-write. I'll have
a look into that.

> I think it's more usual scenario than mine (umount instead of
> remount-rw).  And this change will break it.  So I'm not sure
> what really to do here.  Probably refusing remount-ro if quota
> is on is better...  it's annoying for sure, but at least it's
> explicit, and avoids the handg too.
  On the other hand when you umount the filesystem, quotas are
automatically turned off and when you mount it again, they are not enabled.
So the behavior as I've changed it is consistent as well... But probably
what I wrote above is the safest solution.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
