Return-Path: <linux-kernel-owner+w=401wt.eu-S1754068Ab0AHAPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab0AHAPy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 19:15:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753952Ab0AHAPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 19:15:53 -0500
Received: from mx2.netapp.com ([216.240.18.37]:26284 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753937Ab0AHAPw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 19:15:52 -0500
X-IronPort-AV: E=Sophos;i="4.49,238,1262592000"; 
   d="scan'208";a="298885411"
Subject: Re: [GIT PULL] Please pull NFS client bugfixes....
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, torvalds@osdl.org
In-Reply-To: <20100107235149.GD16076@basil.fritz.box>
References: <1262896174.2659.3.camel@localhost>
	 <87zl4pmxzp.fsf@basil.nowhere.org> <1262901198.2659.38.camel@localhost>
	 <20100107235149.GD16076@basil.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: NetApp
Date: Thu, 07 Jan 2010 19:14:42 -0500
Message-ID: <1262909682.2659.45.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
X-OriginalArrivalTime: 08 Jan 2010 00:15:37.0157 (UTC) FILETIME=[B3E90F50:01CA8FF7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-08 at 00:51 +0100, Andi Kleen wrote: 
> > I'd like to see this fixed, but I do not want to jump onto a solution
> > that changes the behaviour of mmap() w.r.t. revalidation. The current
> > behaviour dates back at least to 2.3.x if not before.
> 
> So do you have a plan to fix it?

Yes. I want to pursue Peter Zijlstra's patches, which split up the mmap
function into a set of parts which require the mmap_sem, and other parts
which don't, and that adds a filesystem callback that allows for
revalidation to occur outside the mmap_sem.

> I don't think it'll be possible to do drastic changes in the
> VFS for 2.6.33, and it seems preserving the current semantics
> would need that.
> 
> > That's why I'm working slowly on this.
> 
> Delaying a fix to after 2.6.33 is not an option imho.
> 
> It hits everyone with LOCKDEP enabled who uses mmap over NFS.
> That's new in 2.6.33, previously LOCKDEP didn't diagnose this.
> 
> I'll keep using my patch, but I suppose once we're going more
> towards a release you'll get more reports of this.

Why should this particular issue require us to rush into a solution?
This has been there for literally _years_, and I've never heard of a
single incident in which a deadlock actually occurred. The only reason
why we've noticed it at all is because lockdep has started to whine.

I agree it should be fixed.

I don't agree that it is urgent enough to warrant kneejerk reactions in
2.6.33 which change long established behaviours that people are actually
relying on.

  Trond
