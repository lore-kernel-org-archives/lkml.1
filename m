Return-Path: <linux-kernel-owner+w=401wt.eu-S1755450AbYLaHIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450AbYLaHIS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 02:08:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752039AbYLaHIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 02:08:07 -0500
Received: from ipmail05.adl2.internode.on.net ([203.16.214.145]:7458 "EHLO
	ipmail05.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752027AbYLaHIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 02:08:06 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjUEAImnWkl5LB1fgWdsb2JhbACDHJBfAQEWIrgmhkQ
X-IronPort-AV: E=Sophos;i="4.36,306,1228051800"; 
   d="scan'208";a="284785858"
Date: Wed, 31 Dec 2008 18:08:02 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Peter W. Morreale" <pmorreale@novell.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] pdflush fix and enhancement
Message-ID: <20081231070802.GE10725@disturbed>
Mail-Followup-To: "Peter W. Morreale" <pmorreale@novell.com>,
	Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
References: <20081230231152.10427.50620.stgit@hermosa.site> <87fxk5ur0h.fsf@basil.nowhere.org> <1230688589.3470.45.camel@hermosa.site> <20081231024609.GQ496@one.firstfloor.org> <1230696664.3470.105.camel@hermosa.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230696664.3470.105.camel@hermosa.site>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 30, 2008 at 09:11:04PM -0700, Peter W. Morreale wrote:
> Actually, it seems to me that we need to look at a radically different
> approach.  What about making background writes a property of the super
> block? (which implies the file system)  Has that been discussed before?

Sure - there was a recent discussion in the context of how broken the
sync(2) syscall is.

That is, some filesystems (e.g. XFS) have certain requirements
to ensure sync actually works in all circumstances and the current
methods that sync employs make it impossible to sync correctly.

It's made worse by the fact that XFS already has internal methods
to completely and cleanly sync the filesystem (i.e. the freeze
code) but that can't be called in the sync() context because
writeback is a property of the VFS and not the filesystem.

It was discussed on linux-fsdevel. <rummage>

http://marc.info/?l=linux-fsdevel&m=122535673232638&w=2

I simply haven't had time to dig into this far enough to
come up with a patchset to fix the problem....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
