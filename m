Return-Path: <linux-kernel-owner+w=401wt.eu-S1756303AbYBGOEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303AbYBGOEx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 09:04:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752695AbYBGOEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 09:04:43 -0500
Received: from styx.suse.cz ([82.119.242.94]:55089 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752680AbYBGOEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 09:04:43 -0500
Date: Thu, 7 Feb 2008 15:04:41 +0100
From: Jan Kara <jack@suse.cz>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: remount-ro & umount & quota interaction
Message-ID: <20080207140441.GF6140@duck.suse.cz>
References: <47A9F495.8060400@msgid.tls.msk.ru> <20080207102815.GB26403@atrey.karlin.mff.cuni.cz> <47AAE250.8040702@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47AAE250.8040702@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 07-02-08 13:49:52, Michael Tokarev wrote:
> Jan Kara wrote:
> [deadlock after remount-ro followed with umount when
>  quota is enabled]
> 
> >   Of course, thanks for report :). The problem is we allow remounting
> > read only which we should refuse when quota is enabled. I'll fix that in
> > a minute.
> 
> Hmm.  While that will prevent the lockup, maybe it's better to
> perform an equivalent of quotaoff on mount-ro instead?  Or even
> do something more useful, like flush the quota stuff like the
> rest of the filesystem is flushed to disk, so that on umount,
> quota will not stay on the way...
  We couldn't leave quota on when filesystem is remounted ro because we
need to modify quotafile when quota is being turned off. We could turn off
quotas when remounting read-only. As we turn them off during umount, it
probably makes sence to turn them off on remount-ro as well.
 
> I mean, why it locks in the first place?  Quota subsystem trying
> to write something into an read-only filesystem?  If so, WHY it
> is trying to do that on umount instead on a remount-ro?
  Actually, I couldn't reproduce the hang on my testing machine so I don't
know exactly why it hangs. But my guess is that it's because we try to
write to the filesystem...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
