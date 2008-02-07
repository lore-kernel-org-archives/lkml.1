Return-Path: <linux-kernel-owner+w=401wt.eu-S1759983AbYBGT1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759983AbYBGT1n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 14:27:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753798AbYBGT1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 14:27:31 -0500
Received: from hobbit.corpit.ru ([81.13.94.6]:20403 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761788AbYBGT1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 14:27:30 -0500
Message-ID: <47AB5B9F.8090302@msgid.tls.msk.ru>
Date: Thu, 07 Feb 2008 22:27:27 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Icedove 1.5.0.14pre (X11/20071018)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] quota: Turn quotas off when remounting read-only
References: <20080207143721.GH6140@duck.suse.cz> <20080207103655.14ce8512.akpm@linux-foundation.org>
In-Reply-To: <20080207103655.14ce8512.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 7 Feb 2008 15:37:21 +0100 Jan Kara <jack@suse.cz> wrote:
> 
>> Turn off quotas before filesystem is remounted read only. Otherwise quota will
>> try to write to read-only filesystem which does no good... We could also just
>> refuse to remount ro when quota is enabled but turning quota off is consistent
>> with what we do on umount.

[a nice one-liner snipped]

> Cool.  And this is applicable to 2.6.23, 2.6.22 and even earlier, isn't it?

Provided the amount of time this issue exists, I don't think it's worth
to push it to -stable.  It's an oooooooold, issue, which happens quite
rarely, and no one bothered to report it so far...  But it's not my
call... ;)

But...  I'm thinking about this scenario:

 # mount /data
 # quotaon /data
 (some maintenance stuff to be planned)
 # mount -o remount,ro /data
 (do backup etc)
 # mount -r remount,rw /data

at this point, it's expected that quota on /data is enabled.
After this patch, it's not anymore...

I think it's more usual scenario than mine (umount instead of
remount-rw).  And this change will break it.  So I'm not sure
what really to do here.  Probably refusing remount-ro if quota
is on is better...  it's annoying for sure, but at least it's
explicit, and avoids the handg too.

/mjt
