Return-Path: <linux-kernel-owner+w=401wt.eu-S1764260AbXGUTMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764260AbXGUTMW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 15:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754711AbXGUTMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 15:12:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43071 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753324AbXGUTMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 15:12:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [linux-pm] Re: Hibernation considerations
Date: Sat, 21 Jul 2007 21:20:03 +0200
User-Agent: KMail/1.9.5
Cc: jbms@cmu.edu, nigel@nigel.suspend2.net, miltonm@bga.com,
       stern@rowland.harvard.edu, ying.huang@intel.com,
       linux-kernel@vger.kernel.org, david@lang.hm,
       linux-pm@lists.linux-foundation.org
References: <Pine.LNX.4.64.0707171319140.2467@asgard.lang.hm> <87lkd9ohtn.fsf@jbms.ath.cx> <E1ICJRG-0000OG-00@dorka.pomaz.szeredi.hu>
In-Reply-To: <E1ICJRG-0000OG-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707212120.04645.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 21 July 2007 20:12, Miklos Szeredi wrote:
> > It seems that you could still potentially get a failure to freeze if one
> > FUSE process depends on another, and the one that is frozen second just
> > happens to be waiting on the one that is frozen first when it is frozen.
> > I admit that this situation is unlikely, and perhaps acceptable.
> 
> It isn't all that unlikely.  There's sshfs for example, that depends
> on a separate ssh process for transport.
> 
> Oh, there are also userspace network transports, like tun/tap,
> nfqueue, etc.  They could block any network filesystem (not just fuse)
> if frozen first, making the freezer fail.
> 
> Hmm, wonder why this isn't affecting people with VPNs?  Probably
> network mounts over VPN are rare, and ever rarer to have fs activity
> on them during suspend.
> 
> Anyway, I think it's long overdue to stop thinking about how to "fix"
> fuse, and concentrate on fixing the underlying problem instead ;)

To conclude this branch of the thread, I have a patch in the works that may
help a bit with unfreezable FUSE filesystems and it only affects the freezer.
I'll post it when 2.6.23-rc1 is out, because it's on top of some other patches
that need to go first.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
