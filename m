Return-Path: <linux-kernel-owner+w=401wt.eu-S965023AbYBHAkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965023AbYBHAkS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 19:40:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934649AbYBHAcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 19:32:48 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:59113 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933896AbYBHAcp (ORCPT
	<rfc822;@sgi.com:linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 19:32:45 -0500
Date: Fri, 8 Feb 2008 11:32:27 +1100
From: David Chinner <dgc@sgi.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Jan Kara <jack@suse.cz>, Michael Tokarev <mjt@tls.msk.ru>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: remount-ro & umount & quota interaction
Message-ID: <20080208003227.GD155407@sgi.com>
References: <47A9F495.8060400@msgid.tls.msk.ru> <20080207102815.GB26403@atrey.karlin.mff.cuni.cz> <47AAE250.8040702@msgid.tls.msk.ru> <20080207140441.GF6140@duck.suse.cz> <Pine.LNX.4.64.0802071508110.25157@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802071508110.25157@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2008 at 03:10:18PM +0100, Jan Engelhardt wrote:
> 
> On Feb 7 2008 15:04, Jan Kara wrote:
> >On Thu 07-02-08 13:49:52, Michael Tokarev wrote:
> >> Jan Kara wrote:
> >> [deadlock after remount-ro followed with umount when
> >>  quota is enabled]
> >> 
> >> Hmm.  While that will prevent the lockup, maybe it's better to
> >> perform an equivalent of quotaoff on mount-ro instead? [...]
> >
> >  We couldn't leave quota on when filesystem is remounted ro because we
> >need to modify quotafile when quota is being turned off. We could turn off
> >quotas when remounting read-only. As we turn them off during umount, it
> >probably makes sence to turn them off on remount-ro as well.
> 
> Objection. XFS handles quotas differently that does not involve
> modifying a file on the fs, so quotas could stay on (even if it does
> not make much sense) while the fs is ro.

Wrong and right. XFS uses files for the backing store for quota
information, though it does handle quotas very differently to every
other Linux filesystem.

On remount-ro, we simply flush all the dirty dquots to their backing
store so the dquots can then be treated as ro just like every other object
in the filesystem. You don't need to turn off quotas to do this....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
